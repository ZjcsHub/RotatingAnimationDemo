import Foundation
import opus

/// 一个将Opus音频数据解码为PCM格式的工具类.
///
/// 这个类封装了 libopus 解码器，提供了一个简单的接口来处理流式或单个的Opus数据包.
///
/// **使用前提:**
/// 你的项目需要链接 `libopus` 库，并通过桥接头文件(Bridging-Header.h)导入 `opus.h`.
/// 例如，在你的桥接头文件中添加: `#import <opus/opus.h>`
class OpusToPcmAudioTool {

    private var decoder: OpaquePointer?
    private let sampleRate: Int32
    private let channels: Int32
    
    // Opus解码器支持的最大帧长是120ms.
    // 在48kHz采样率下，120ms对应的采样点数是 48000 * 0.120 = 5760.
    // 我们以此为基础设置一个足够大的缓冲区.
    private let maxFrameSize = 5760
    private let pcmBuffer: UnsafeMutablePointer<Int16>

    /// 初始化Opus解码器.
    ///
    /// - Parameters:
    ///   - sampleRate: 目标PCM输出的采样率. 支持 8000, 12000, 16000, 24000, 48000.
    ///   - channels: 声道数 (1 for mono, 2 for stereo).
    init?(sampleRate: Int32, channels: Int32) {
        self.sampleRate = sampleRate
        self.channels = channels
        
        var error: Int32 = 0
        // 创建解码器实例
        self.decoder = opus_decoder_create(sampleRate, channels, &error)
        
        // 检查解码器是否创建成功
        if error != OPUS_OK || self.decoder == nil {
            print("Failed to create Opus decoder: \(String(cString: opus_strerror(error)))")
            return nil
        }
        
        // 分配用于存放解码后PCM数据的缓冲区
        self.pcmBuffer = UnsafeMutablePointer<Int16>.allocate(capacity: maxFrameSize * Int(channels))
    }
    
    deinit {
        // 销毁解码器，释放资源
        if let decoder = decoder {
            opus_decoder_destroy(decoder)
        }
        // 释放PCM缓冲区内存
        pcmBuffer.deallocate()
    }

    /// 解码单个Opus数据包为PCM数据.
    ///
    /// - Parameter opusPacket: 包含单个Opus帧的Data对象.
    /// - Returns: 解码后的PCM数据 (16-bit little-endian signed integers)，如果解码失败则返回nil.
    func decode(opusPacket: Data) -> Data? {
        guard let decoder = decoder else {
            print("Decoder is not initialized.")
            return nil
        }

        let decodedSamples = opusPacket.withUnsafeBytes { (opusBytes: UnsafeRawBufferPointer) -> Int32 in
            let opusPointer = opusBytes.baseAddress?.assumingMemoryBound(to: UInt8.self)
            return opus_decode(
                decoder,
                opusPointer,
                Int32(opusPacket.count),
                pcmBuffer,
                Int32(maxFrameSize),
                0 // Forward Error Correction: 0 for disabled
            )
        }
        
        if decodedSamples < 0 {
            let error = decodedSamples
            print("Opus decode failed: \(String(cString: opus_strerror(error)))")
            return nil
        }
        
        let pcmDataSize = Int(decodedSamples) * Int(channels) * MemoryLayout<Int16>.size
        let pcmData = Data(bytes: pcmBuffer, count: pcmDataSize)
        
        return pcmData
    }
}
