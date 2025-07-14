import UIKit
import AVFoundation

// 在 MusicControlView 类定义前添加协议
protocol MusicControlViewDelegate: AnyObject {
    func musicControlViewDidFinishPlaying(_ musicControlView: MusicControlView)
}

class MusicControlView: UIView {
    
    private var audioPlayer: AVAudioPlayer?
    private var currentTime: TimeInterval = 0
    private var audioIntensities: [Float] = []
    // 波形图配置参数
    private let barWidth: CGFloat = 2.0
    private let centerLineWidth: CGFloat = 2.0
    
    private let barSpace:CGFloat = 2
    private let audioIntervalSecond:Double = 0.1
    
    weak var delegate: MusicControlViewDelegate?
    
    // CollectionView 相关属性
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = barSpace
        layout.minimumLineSpacing = barSpace
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = true
        collection.showsVerticalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false
        collection.register(AudioBarCell.self, forCellWithReuseIdentifier: "AudioBarCell")
        return collection
    }()
    
    // 中间指示线
    private let centerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
  
    // 播放进度更新计时器
    private var playbackTimer: CADisplayLink?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // 添加CollectionView
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // 添加中间指示线
        addSubview(centerLineView)
        NSLayoutConstraint.activate([
            centerLineView.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerLineView.topAnchor.constraint(equalTo: topAnchor),
            centerLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            centerLineView.widthAnchor.constraint(equalToConstant: centerLineWidth)
        ])
        
        // 将CollectionView的内容偏移到中间位置
       

    }
    
    // 设置音频文件
    func setAudioFile(url: URL, complete:((MusicControlView)->())?) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self // 设置代理
            audioPlayer?.prepareToPlay()
            DispatchQueue.global().async {
                self.analyzeAudioIntensity(url: url)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    // 设置初始偏移位置为负的左边距，这样内容就会从中间开始
                    let initialOffset = -self.collectionView.contentInset.left
                    self.collectionView.setContentOffset(CGPoint(x: initialOffset, y: 0), animated: false)
                    complete?(self)
                }
            }
        } catch {
            print("Error loading audio file: \(error)")
        }
    }
    
    // 开始播放
    func play() {
        audioPlayer?.play()
        startPlaybackTimer()
    }
    
    // 暂停播放
    func pause() {
        audioPlayer?.pause()
        stopPlaybackTimer()
    }
    
    // 停止播放
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        stopPlaybackTimer()
        resetCollection()
        self.collectionView.reloadData()
    }
    
    // 开始播放进度更新计时器
    private func startPlaybackTimer() {
        stopPlaybackTimer()
        playbackTimer = CADisplayLink(target: self, selector: #selector(updatePlaybackProgress))
        playbackTimer?.add(to: .main, forMode: .common)
    }
    
    // 停止播放进度更新计时器
    private func stopPlaybackTimer() {
        playbackTimer?.invalidate()
        playbackTimer = nil
    }
    
    private func resetCollection() {
        let initialOffset = -self.collectionView.contentInset.left
        self.collectionView.setContentOffset(CGPoint(x: initialOffset, y: 0), animated: false)
    }
    
    // 更新播放进度
    @objc private func updatePlaybackProgress() {
        
        
        guard let player = audioPlayer else { return }
        
        let progress = player.currentTime / player.duration
        let totalWidth = CGFloat(audioIntensities.count) * (barWidth + barSpace)
        let offsetX = totalWidth * CGFloat(progress) - self.collectionView.contentInset.left
        
        // 使用动画使滚动更平滑
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear, .allowUserInteraction]) {
            self.collectionView.contentOffset = CGPoint(x: offsetX, y: 0)
        }
        
        restCollectionViewColor(progress:progress)
       
    }
    
    private func restCollectionViewColor(progress:Double){
        // 刷新可见单元格的颜色
        self.collectionView.visibleCells.forEach { cell in
            if let audioCell = cell as? AudioBarCell,
               let indexPath = self.collectionView.indexPath(for: cell) {
                let isPlayed = Double(indexPath.item) / Double(audioIntensities.count) <= progress
                audioCell.configure(with: nil, isPlayed: isPlayed)
            }
        }
    }
    
    // 分析音频文件并获取每100ms的音频强度
    private func analyzeAudioIntensity(url: URL) {
        do {
            let audioFile = try AVAudioFile(forReading: url)
            let format = audioFile.processingFormat
            let frameCount = UInt32(audioFile.length)
            let sampleRate = format.sampleRate
            
            // 计算100ms对应的采样点数
            let samplesPerInterval = Int(sampleRate * audioIntervalSecond) // 0.1秒 = 100毫秒
            let intervalCount = Int(ceil(Double(frameCount) / Double(samplesPerInterval)))
            
            // 创建音频缓冲区
            let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
            try audioFile.read(into: buffer)
            
            // 获取音频数据
            guard let channelData = buffer.floatChannelData else { return }
            let channelCount = Int(format.channelCount)
            
            // 初始化强度数组
            audioIntensities = Array(repeating: 0.0, count: intervalCount)
            
            // 计算每100ms的音频强度
            for interval in 0..<intervalCount {
                let startFrame = interval * samplesPerInterval
                let endFrame = min(startFrame + samplesPerInterval, Int(frameCount))
                var sum: Float = 0.0
                var count = 0
                
                for frame in startFrame..<endFrame {
                    for channel in 0..<channelCount {
                        let sample = abs(channelData[channel][frame])
                        sum += sample
                        count += 1
                    }
                }
                
                // 计算这100ms的平均强度
                let intensity = count > 0 ? sum / Float(count) : 0
                audioIntensities[interval] = intensity
                
                // 打印每100ms的强度值
                print("Interval \(interval * 100)ms: Intensity = \(intensity)，count:\(count)")
            }
         
        } catch {
            print("Error analyzing audio file: \(error)")
        }
        
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: self.bounds.width / 2, bottom: 0, right: self.bounds.width / 2)
    }
    
    deinit {
        self.stop()
        audioPlayer = nil
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MusicControlView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return audioIntensities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AudioBarCell", for: indexPath) as! AudioBarCell
        let intensity = audioIntensities[indexPath.item]
        let maxIntensity = audioIntensities.max() ?? 1.0
        let normalizedHeight = (intensity / maxIntensity)
        
        // 计算当前项是否已播放
        let currentProgress = (audioPlayer?.currentTime ?? 0) / (audioPlayer?.duration ?? 1)
        let isPlayed = Double(indexPath.item) / Double(audioIntensities.count) < currentProgress
        
        cell.configure(with: normalizedHeight, isPlayed: isPlayed)
                
        if indexPath.item % Int(1.0 / audioIntervalSecond) == 0{
            let totalSecond = Int(Double(indexPath.item) * audioIntervalSecond)
            let minute = totalSecond / 60
            let second = totalSecond % 60
            cell.timeLabel.text = String(format: "%02d:%02d", minute,second)
        }else{
            cell.timeLabel.text = nil
        }
        
       
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: barWidth, height: collectionView.bounds.height)
    }
    
    // 添加滚动代理方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let player = audioPlayer , player.isPlaying else { return }
        
        // 如果是由播放进度更新引起的滚动，不处理
        if playbackTimer != nil {
            return
        }
        
        // 计算当前滚动位置对应的播放进度
        let offsetX = scrollView.contentOffset.x + scrollView.contentInset.left
        let totalWidth = CGFloat(audioIntensities.count) * (barWidth + barSpace)
        let progress = offsetX / totalWidth
        
        // 设置音频播放位置
        let newTime = player.duration * Double(progress)
        player.currentTime = max(0, min(newTime, player.duration))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 暂停播放进度更新
        stopPlaybackTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            // 如果音频正在播放，恢复播放进度更新
            if audioPlayer?.isPlaying == true {
                startPlaybackTimer()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 如果音频正在播放，恢复播放进度更新
        if audioPlayer?.isPlaying == true {
            startPlaybackTimer()
        }
    }
}

// MARK: - AudioBarCell
class AudioBarCell: UICollectionViewCell {
    
    let heightRate:CGFloat = 0.5
    
    private let barView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    func configure(with normalizedHeight: Float?, isPlayed: Bool) {
        if let normalizedHeight {
            let height = CGFloat(normalizedHeight) * bounds.height * heightRate
            let yPosition = (bounds.height - height) / 2
            
            barView.frame = CGRect(x: 0,
                                   y: yPosition,
                                   width: bounds.width,
                                   height: height)
            
        }
    
      
        // 根据是否已播放设置颜色
        barView.backgroundColor = isPlayed ? .systemBlue : .gray
    }
}

// 在文件末尾添加 AVAudioPlayerDelegate 扩展
extension MusicControlView: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stop()
        delegate?.musicControlViewDidFinishPlaying(self) // 通知外部播放完成
    }
}
