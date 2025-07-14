

import Foundation
import CommonCrypto
import CryptoSwift




struct FernetDecryption {
    
    
    static func decryptAES(key:String,iv:String, ciphertext: String) throws -> String? {
        // 确保IV和密钥长度正确
        
        guard let keyData = key.data(using: .utf8) , let ivData = iv.data(using: .utf8) , let cipData = Data(base64Encoded: ciphertext) else {
            return nil
        }
        
        // 使用CryptoSwift库进行AES解密
        do {
            let aes = try AES(key: keyData.bytes, blockMode: CBC(iv: ivData.bytes), padding: .pkcs7)
            let decryptedBytes = try aes.decrypt(cipData.bytes)
            return String(data: Data(decryptedBytes), encoding: .utf8)
        } catch {
            throw FernetError.decryptionFailed
        }
    }
    
    enum FernetError: Error {
        case invalidToken
        case invalidKey
        case decryptionFailed
        case paddingError
    }
    
    private let signingKey: Data
    private let encryptionKey: Data
    
    init(key: String) throws {
        // 替换URL安全的Base64字符
        let urlSafeKey = key.replacingOccurrences(of: "-", with: "+")
                            .replacingOccurrences(of: "_", with: "/")
        
        // 添加必要的填充
        var paddedKey = urlSafeKey
        let padding = urlSafeKey.count % 4
        if padding > 0 {
            paddedKey += String(repeating: "=", count: 4 - padding)
        }
        
        guard let keyData = Data(base64Encoded: paddedKey) else {
            throw FernetError.invalidKey
        }
        
        if keyData.count != 32 {
            throw FernetError.invalidKey
        }
        
        self.signingKey = keyData.subdata(in: 0..<16)
        self.encryptionKey = keyData.subdata(in: 16..<32)
    }
    
    func decrypt(token: String) throws -> String {
        // 替换URL安全的Base64字符
        let urlSafeToken = token.replacingOccurrences(of: "-", with: "+")
                               .replacingOccurrences(of: "_", with: "/")
        
        // 添加必要的填充
        var paddedToken = urlSafeToken
        let padding = urlSafeToken.count % 4
        if padding > 0 {
            paddedToken += String(repeating: "=", count: 4 - padding)
        }
        
        guard let tokenData = Data(base64Encoded: paddedToken) else {
            throw FernetError.invalidToken
        }
        
        // 验证token格式
        if tokenData.count < 41 || tokenData[0] != 0x80 {
            throw FernetError.invalidToken
        }
        
        // 提取各部分数据
        let versionByte = tokenData[0]
        let timestamp = tokenData.subdata(in: 1..<9)
        let iv = tokenData.subdata(in: 9..<25)
        let ciphertext = tokenData.subdata(in: 25..<(tokenData.count - 32))
        let hmac = tokenData.subdata(in: (tokenData.count - 32)..<tokenData.count)
        
        // 验证HMAC签名
        let signedData = tokenData.subdata(in: 0..<(tokenData.count - 32))
        try verifyHMAC(data: signedData, expectedHMAC: hmac)
        
        // 解密数据
        let decryptedData = try decryptAES(ciphertext: ciphertext, iv: iv)
        
        // 移除PKCS7填充
        let unpaddedData = try removePKCS7Padding(from: decryptedData)
        
        guard let result = String(data: unpaddedData, encoding: .utf8) else {
            throw FernetError.decryptionFailed
        }
        
        return result
    }
    
    private func verifyHMAC(data: Data, expectedHMAC: Data) throws {
        var hmacContext = CCHmacContext()
        CCHmacInit(&hmacContext, CCHmacAlgorithm(kCCHmacAlgSHA256), [UInt8](signingKey), signingKey.count)
        CCHmacUpdate(&hmacContext, [UInt8](data), data.count)
        
        var computedHMAC = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmacFinal(&hmacContext, &computedHMAC)
        
        let computedHMACData = Data(computedHMAC)
        
        if computedHMACData != expectedHMAC {
            throw FernetError.invalidToken
        }
    }
    
    private func decryptAES(ciphertext: Data, iv: Data) throws -> Data {
        let dataLength = ciphertext.count
        var bufferSize = dataLength + kCCBlockSizeAES128
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        
        var numBytesDecrypted = 0
        
        let cryptStatus = ciphertext.withUnsafeBytes { cryptBytes in
            iv.withUnsafeBytes { ivBytes in
                encryptionKey.withUnsafeBytes { keyBytes in
                    CCCrypt(
                        CCOperation(kCCDecrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress, encryptionKey.count,
                        ivBytes.baseAddress,
                        cryptBytes.baseAddress, dataLength,
                        &buffer, bufferSize,
                        &numBytesDecrypted
                    )
                }
            }
        }
        
        if cryptStatus != kCCSuccess {
            throw FernetError.decryptionFailed
        }
        
        return Data(bytes: buffer, count: numBytesDecrypted)
    }
    
    private func removePKCS7Padding(from data: Data) throws -> Data {
        guard let lastByte = data.last, lastByte <= kCCBlockSizeAES128, lastByte > 0 else {
            throw FernetError.paddingError
        }
        
        let paddingLength = Int(lastByte)
        let messageLength = data.count - paddingLength
        
        // 验证所有填充字节是否一致
        for i in messageLength..<data.count {
            if data[i] != lastByte {
                throw FernetError.paddingError
            }
        }
        
        return data.subdata(in: 0..<messageLength)
    }
    
    // 辅助方法：从Base64解密API密钥
    static func decryptAPIKey(encryptedKey: String, encryptionKey: String) throws -> String {
        guard let keyData = Data(base64Encoded: encryptionKey) else {
            throw FernetError.invalidKey
        }
        
        let fernet = try FernetDecryption(key: keyData.base64EncodedString())
        return try fernet.decrypt(token: encryptedKey)
    }
}

