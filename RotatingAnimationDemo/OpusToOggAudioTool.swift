//
//  OpusToOggAudioTool.swift
//  RotatingAnimationDemo
//
//  Created by App005 SYNERGY on 2025/6/21.
//

import UIKit
import zlib

class OpusToOggAudioTool: NSObject {

    private let streamSerialNumber: UInt32
    private var pageSequenceNumber: UInt32 = 0
    private var granulePosition: UInt64 = 0
    private var headersGenerated = false

    private let channels: UInt8
    private let sampleRate: UInt32
    private let preskip: UInt16
    private let outputGain: Int16
    private let channelMappingFamily: UInt8
    
    /// 初始化Opus到Ogg转换器
    /// - Parameters:
    ///   - channels: 声道数 (1 for mono, 2 for stereo).
    ///   - sampleRate: 输入音频的采样率 (例如 16000, 24000, 48000). Opus内部总是重采样到48kHz.
    ///   - preskip: 解码器需要跳过的样本数，通常由编码器指定.
    ///   - outputGain: 应用于解码音频的增益.
    ///   - channelMappingFamily: 声道映射方案. 0表示单声道/立体声.
    init(channels: UInt8 = 1, sampleRate: UInt32 = 16000, preskip: UInt16 = 3840, outputGain: Int16 = 0, channelMappingFamily: UInt8 = 0) {
        self.streamSerialNumber = arc4random()
        self.channels = channels
        self.sampleRate = sampleRate
        self.preskip = preskip
        self.outputGain = outputGain
        self.channelMappingFamily = channelMappingFamily
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// 转换单个Opus数据包为Ogg页.
    /// 如果这是第一次调用, 它将首先生成并返回头部页.
    /// - Parameter opusPacket: 单个原始Opus数据包.
    /// - Returns: 包含一个或多个Ogg页的Data对象.
    public func convert(opusPacket: Data) -> Data {
        var oggData = Data()
        
        if !headersGenerated {
            oggData.append(createHeaderPages())
            headersGenerated = true
        }
        
        // Each Opus packet gets its own Ogg page.
        let samplesInPacket = getOpusPacketSampleCount(packet: opusPacket)
        granulePosition += UInt64(samplesInPacket)
        
        let oggPage = createOggPage(with: opusPacket, headerType: 0, granulePosition: self.granulePosition)
        oggData.append(oggPage)
        
        pageSequenceNumber += 1
        
        return oggData
    }
    
    /// 生成并返回标记流结束的Ogg页.
    /// - Returns: 包含EOS页的Data对象.
    public func finalizeStream() -> Data {
        let oggPage = createOggPage(with: Data(), headerType: 4, granulePosition: self.granulePosition) // EOS
        pageSequenceNumber += 1
        return oggPage
    }
    
    // MARK: - Private Helper Methods
    
    private func createHeaderPages() -> Data {
        var headerData = Data()

        // Page 1: OpusHead (BOS - Beginning of Stream)
        let opusHeadPacket = createOpusHeadPacket()
        // Granule position for header pages is 0.
        let opusHeadPage = createOggPage(with: opusHeadPacket, headerType: 2, granulePosition: 0)
        headerData.append(opusHeadPage)
        pageSequenceNumber += 1

        // Page 2: OpusTags
        let opusTagsPacket = createOpusTagsPacket()
        let opusTagsPage = createOggPage(with: opusTagsPacket, headerType: 0, granulePosition: 0)
        headerData.append(opusTagsPage)
        pageSequenceNumber += 1
        
        return headerData
    }
    
    private func createOpusHeadPacket() -> Data {
        var packet = Data()
        // Magic Signature: "OpusHead"
        packet.append(contentsOf: [0x4F, 0x70, 0x75, 0x73, 0x48, 0x65, 0x61, 0x64])
        // Version (1 byte)
        packet.append(1)
        // Channel Count (1 byte)
        packet.append(channels)
        // Pre-skip (2 bytes, little-endian)
        packet.append(contentsOf: [UInt8(preskip & 0xFF), UInt8(preskip >> 8)])
        // Input Sample Rate (4 bytes, little-endian)
        packet.append(contentsOf: [
            UInt8(sampleRate & 0xFF),
            UInt8((sampleRate >> 8) & 0xFF),
            UInt8((sampleRate >> 16) & 0xFF),
            UInt8((sampleRate >> 24) & 0xFF)
        ])
        // Output Gain (2 bytes, little-endian, S7.8 fixed-point)
        packet.append(contentsOf: [UInt8(outputGain & 0xFF), UInt8(outputGain >> 8)])
        // Channel Mapping Family (1 byte)
        packet.append(channelMappingFamily)
        
        return packet
    }
    
    private func createOpusTagsPacket() -> Data {
        var packet = Data()
        // Magic Signature: "OpusTags"
        packet.append(contentsOf: [0x4F, 0x70, 0x75, 0x73, 0x54, 0x61, 0x67, 0x73])
        // Vendor String Length (4 bytes, little-endian)
        let vendorString = "OpusToOggAudioTool"
        let vendorStringData = vendorString.data(using: .utf8)!
        var vendorLength = UInt32(vendorStringData.count).littleEndian
        packet.append(Data(bytes: &vendorLength, count: 4))
        // Vendor String
        packet.append(vendorStringData)
        // User Comment List Length (4 bytes, little-endian)
        var commentListLength: UInt32 = 0
        packet.append(Data(bytes: &commentListLength, count: 4))
        
        return packet
    }
    
    private func createOggPage(with payload: Data, headerType: UInt8, granulePosition: UInt64) -> Data {
        var page = Data()
        let payloadSize = payload.count
        
        // Max segments per page is 255.
        // Each segment can have max 255 bytes.
        let numSegments = (payloadSize + 254) / 255
        var segmentTable = Data(count: numSegments)
        
        for i in 0..<numSegments {
            let segmentLength = min(255, payloadSize - (i * 255))
            segmentTable[i] = UInt8(segmentLength)
        }

        // Page Header
        // Capture Pattern "OggS"
        page.append(contentsOf: [0x4F, 0x67, 0x67, 0x53])
        // Version
        page.append(0)
        // Header Type
        page.append(headerType)
        // Granule Position (little-endian)
        var leGranulePosition = granulePosition.littleEndian
        page.append(Data(bytes: &leGranulePosition, count: 8))
        // Stream Serial Number (little-endian)
        var leStreamSerialNumber = streamSerialNumber.littleEndian
        page.append(Data(bytes: &leStreamSerialNumber, count: 4))
        // Page Sequence Number (little-endian)
        var lePageSequenceNumber = pageSequenceNumber.littleEndian
        page.append(Data(bytes: &lePageSequenceNumber, count: 4))
        // CRC Checksum (placeholder)
        page.append(contentsOf: [0, 0, 0, 0])
        // Page Segments
        page.append(UInt8(numSegments))
        // Segment Table
        page.append(segmentTable)
        
        // Page Payload
        page.append(payload)

        // Calculate and insert CRC checksum
        let crc = crc32(for: page)
        var leCrc = crc.littleEndian
        let crcData = Data(bytes: &leCrc, count: 4)
        
        // Page starts at index 0. Checksum is at offset 22.
        page.replaceSubrange(22..<26, with: crcData)
        
        return page
    }
    
    private func getOpusPacketSampleCount(packet: Data) -> Int {
        guard !packet.isEmpty else { return 0 }

        let toc = packet[0]
        let Fs = 48000 // Opus uses a 48kHz internal sample rate

        let samplesPerFrame: Int
        let config = toc >> 3
        
        if config >= 16 { // CELT-only
            let audiosize_code = config & 0x03
            samplesPerFrame = (Fs << Int(audiosize_code)) / 400
        } else if config >= 12 { // SILK-only
            // configs 12-13 are 10ms, 14-15 are 20ms
            samplesPerFrame = (Fs / 100) * ((config & 0x02) == 0 ? 1 : 2)
        } else { // Hybrid or SILK-only
            let audiosize_code = config & 0x03
            if audiosize_code == 3 {
                samplesPerFrame = Fs * 60 / 1000 // 60ms
            } else {
                // 10ms, 20ms, 40ms
                samplesPerFrame = (Fs << Int(audiosize_code)) / 100
            }
        }
        
        let frameCountCode = toc & 0x03
        let numberOfFrames: Int
        switch frameCountCode {
        case 0:
            numberOfFrames = 1
        case 1, 2:
            numberOfFrames = 2
        default: // 3
            if packet.count < 2 { return 0 }
            numberOfFrames = Int(packet[1] & 0x3F)
        }
        
        return numberOfFrames * samplesPerFrame
    }
    
    
    // MARK: - CRC32 Helper
    private func crc32(for data: Data) -> UInt32 {
        var crc = zlib.crc32(0, nil, 0)
        
        crc = data.withUnsafeBytes { bytes in
            return zlib.crc32(crc, bytes.baseAddress?.assumingMemoryBound(to: Bytef.self), uInt(bytes.count))
        }
        
        return UInt32(crc)
    }

}

