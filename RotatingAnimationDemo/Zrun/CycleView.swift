//
//  CycleView.swift
//  WatchFit
//
//  Created by James_Zheng on 2023/10/9.
//

import UIKit

class CycleView: UIView {

    internal var lineWidth:CGFloat = 10.0
    // 绘画layer
    internal var shapeLayer:CAShapeLayer?
    
    internal var backGroundLayer:CAShapeLayer?
    
    var drawBackGroundColor:UIColor?
    
    var drawColor:UIColor? {
        didSet {
            shapeLayer?.strokeColor = drawColor?.cgColor

        }
    }
    
    var backDrawColor:UIColor? {
        didSet{
            bgLayer?.strokeColor = backDrawColor?.cgColor
        }
    }
    // 渐变layer
    var gradientLayer = CAGradientLayer()
    
    /// 背景layer
    var bgLayer:CAShapeLayer?
    
    var startAngle:CGFloat?
    var endAngle:CGFloat?
    
    var isShadow:Bool = false
    
    /// 是否显示渐变
    var isShowGradient:Bool = false
    /// 是否显示边框
    var isShowSideLine:Bool = false
    
    /// 旋转方向，默认逆时针
    var isclockwise:Bool = true
    
    var startImage:UIImage?
        
    var showAnimate = false
    
    var layoutOnce = true
    
    var gradientColor:[CGColor] = [UIColor(hex: "#E60019").cgColor,
                                   UIColor(hex: "#EF7D00").cgColor,
                                   UIColor(hex: "#F3EB0A").cgColor,
                                   UIColor(hex: "#B0CF01").cgColor,
                                   UIColor(hex: "#69B82D").cgColor,
                                   UIColor(hex: "#70C088").cgColor,
                                   UIColor(hex: "#6EC9E2").cgColor,
                                   UIColor(hex: "#4074BA").cgColor,
                                   UIColor(hex: "#33479C").cgColor,
                                   UIColor(hex: "#884797").cgColor,
                                   UIColor(hex: "#CD3F91").cgColor,
                                   UIColor(hex: "#E60431").cgColor]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect,startAngle:CGFloat = CGFloat(Double.pi/4 + Double.pi/2),endAngle:CGFloat = CGFloat(Double.pi / 4),lineWidth:CGFloat,drawColor:UIColor? = .orange, backDrawColor:UIColor? = UIColor(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1),withShadow:Bool = false,backgroundColor:UIColor? = nil,isShowGradient:Bool = false,isShowSideLine:Bool = false) {
        self.init(frame: frame)
        self.lineWidth = lineWidth
        
        self.startAngle = startAngle
        self.endAngle = endAngle
        
        self.backDrawColor = backDrawColor
        self.drawColor = drawColor
        self.isShadow = withShadow
        self.drawBackGroundColor = backgroundColor
        self.isShowGradient = isShowGradient
        self.isShowSideLine = isShowSideLine
        self.gradientColor = gradientColor
        
//        setBackGroundCycle()
    }
    
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func layoutSubviews() {
        // 画背景圆
//        if layoutOnce {
//            layoutOnce = false
//        }
        super.layoutSubviews()
        reloadData()
    }
    
    public var progress:CGFloat? {
        didSet{
            guard let progress = progress else {
                return
            }
//            reloadData()
            animateToProgress(progress: progress)
        }
    }
    
    
    func reloadData() {
        
        if let layers = self.layer.sublayers {
            
            layers.forEach({ (subLayer) in
//                if let subLayer = subLayer as? CAShapeLayer {
//                }
                subLayer.removeFromSuperlayer()
            })
        }
        
        setBackGroundCycle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setBackGroundCycle()  {
        
        let viewWidth = self.frame.size.width
        let viewHeight = self.frame.size.height
        
        let center = CGPoint(x: viewWidth/2, y: viewHeight/2)
        var circlePath:UIBezierPath
        var shadowPath:UIBezierPath
        var needReduce:CGFloat = 0
        
        guard let startAngle = startAngle , let endAngle = endAngle else {
           return
        }
        shadowPath = UIBezierPath(arcCenter: center, radius: (viewWidth)/2 , startAngle:startAngle, endAngle: endAngle, clockwise: isclockwise)
        if isShadow {
            let shadowLayer = CAShapeLayer()
            shadowLayer.frame = self.bounds
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowColor = UIColor.gray.cgColor
            let offset:CGFloat = 0
            shadowLayer.shadowOffset = CGSize(width: 0, height: offset)
            shadowLayer.shadowPath = shadowPath.cgPath
          
            shadowLayer.strokeColor = UIColor.gray.cgColor
            self.layer.mask = shadowLayer
            needReduce = lineWidth / 2
            
            let bgLayer = CAShapeLayer()
            bgLayer.frame = self.bounds
            bgLayer.fillColor = UIColor.clear.cgColor
            bgLayer.lineWidth = lineWidth / 2
//            bgLayer.strokeColor = ThemeColor.view8B80F8Color.withAlphaComponent(0.3).cgColor
            bgLayer.strokeStart = 0
            bgLayer.strokeEnd = 1
            bgLayer.lineCap = .round
            bgLayer.path = shadowPath.cgPath
            self.layer.addSublayer(bgLayer)
            
        }
        
        circlePath = UIBezierPath(arcCenter: center, radius: (viewWidth - lineWidth)/2 - needReduce , startAngle:startAngle, endAngle: endAngle, clockwise: isclockwise)
        bgLayer = CAShapeLayer()
        bgLayer?.frame = self.bounds
        bgLayer?.fillColor = drawBackGroundColor?.cgColor  //UIColor.clear.cgColor
        bgLayer?.lineWidth = lineWidth
        bgLayer?.strokeColor = backDrawColor?.cgColor
        bgLayer?.strokeStart = 0
        bgLayer?.strokeEnd = 1
        bgLayer?.lineCap = .round
        bgLayer?.path = circlePath.cgPath
        self.layer.addSublayer(bgLayer!)
        backGroundLayer = bgLayer
        // 画圆环边线
        if isShowSideLine {
//            let outPath = UIBezierPath(arcCenter: center, radius: (viewWidth - lineWidth)/2 - needReduce + lineWidth / 2 - 1, startAngle:startAngle, endAngle: endAngle, clockwise: isclockwise)
//            let outLayer = CAShapeLayer()
//            outLayer.frame = self.bounds
//            outLayer.fillColor = UIColor.clear.cgColor
//            outLayer.lineWidth = 2
//            outLayer.strokeColor = ThemeColor.view8B80F8Color.cgColor
//            outLayer.strokeStart = 0
//            outLayer.strokeEnd = 1
//            outLayer.lineCap = .round
//            outLayer.path = outPath.cgPath
//            self.layer.addSublayer(outLayer)
//            
//            let insidePath = UIBezierPath(arcCenter: center, radius: (viewWidth - lineWidth)/2 - needReduce - lineWidth / 2 + 1, startAngle:startAngle, endAngle: endAngle, clockwise: isclockwise)
//            let insideLayer = CAShapeLayer()
//            insideLayer.frame = self.bounds
//            insideLayer.fillColor = UIColor.clear.cgColor
//            insideLayer.lineWidth = 2
//            insideLayer.strokeColor = ThemeColor.view8B80F8Color.cgColor
//            insideLayer.strokeStart = 0
//            insideLayer.strokeEnd = 1
//            insideLayer.lineCap = .round
//            insideLayer.path = insidePath.cgPath
//            self.layer.addSublayer(insideLayer)
        }
        
        // 用于绘画圆环的layer
        shapeLayer = CAShapeLayer()
        shapeLayer?.frame = self.bounds
        shapeLayer?.fillColor = UIColor.clear.cgColor
        shapeLayer?.lineWidth = lineWidth
        shapeLayer?.lineCap = .round
        shapeLayer?.strokeColor = drawColor?.cgColor
        shapeLayer?.strokeStart = 0
        shapeLayer?.strokeEnd = 0
        shapeLayer?.path = circlePath.cgPath
        self.layer.addSublayer(shapeLayer!)
        
        if let startImage = startImage {
            let smartRect = CGRect(x: (viewWidth-lineWidth)/2, y: 0, width: lineWidth, height: lineWidth)
            let imagelayer = CALayer()
            imagelayer.frame = smartRect
            imagelayer.contents = startImage.cgImage
            imagelayer.contentsScale = 2
            imagelayer.contentsGravity = .resizeAspect
            self.layer.addSublayer(imagelayer)
        }

        // 渐变色的代码
        if isShowGradient {
            
            gradientLayer.frame = self.bounds
            gradientLayer.colors = gradientColor
            // 1. 调整颜色分布逻辑
            let colorCount = gradientColor.count
            let step = 1.0 / Double(colorCount)
            let locations: [NSNumber] = (0..<colorCount).map { NSNumber(value: step * Double($0)) }

            gradientLayer.locations = locations
            gradientLayer.type = .conic
            // 2. 修正渐变方向为环形渐变
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
                        
            gradientLayer.mask = shapeLayer!
          
            self.layer.addSublayer(gradientLayer)
        }

       
        self.animateToProgress(progress: self.progress ?? 0)
    }
    
    
    private func animateToProgress(progress:CGFloat) {
        
        var cuPro = progress
        if cuPro > 1 {
            cuPro = 1
        }
        
        shapeLayer?.strokeEnd = cuPro
        
//        let scale:Double = 1 / Double(gradientColor.count)
//        
//        let cur = cuPro / scale
//        var showCount:Int = Int(cur)
//        
//        if showCount >= gradientColor.count {
//            showCount = gradientColor.count - 1
//        }
//        
//        gradientLayer.colors = Array(gradientColor[0...showCount])
        
    }
}

extension CycleView {
    
    convenience init(frame: CGRect,startAngle:CGFloat = CGFloat(Double.pi/4 + Double.pi/2),endAngle:CGFloat = CGFloat(Double.pi / 4),lineWidth:CGFloat,drawColor:UIColor? = .orange, backDrawColor:UIColor? = UIColor(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1),withShadow:Bool = false,isclockwise:Bool = false,startImage:UIImage?) {
        self.init(frame: frame)
        self.lineWidth = lineWidth
        self.isclockwise = isclockwise
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.backDrawColor = backDrawColor
        self.drawColor = drawColor
        self.isShadow = withShadow
        self.startImage = startImage
        setBackGroundCycle()

    }
    
}

extension UIColor {
    convenience init(hex:String) {
        var colorHex = hex
        if hex.lowercased().hasPrefix("#") {
            colorHex = colorHex.substring(from: 1)
        }
        
        let scanner = Scanner(string: colorHex)
        scanner.scanLocation = 0
        var rgbValue:UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(red: CGFloat(Float(r)/255.0), green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
    }
}
extension String {
    /// String使用下标截取字符串
    /// string[index] 例如："abcdefg"[3] // c
    subscript (i:Int)->String{
        let startIndex = self.index(self.startIndex, offsetBy: i)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex..<endIndex])
    }
    /// String使用下标截取字符串
    /// string[index..<index] 例如："abcdefg"[3..<4] // d
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    /// String使用下标截取字符串
    /// string[index,length] 例如："abcdefg"[3,2] // de
    subscript (index:Int , length:Int) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: length)
            return String(self[startIndex..<endIndex])
        }
    }
    // 截取 从头到i位置
    func substring(to:Int) -> String{
        return self[0..<to]
    }
    // 截取 从i到尾部
    func substring(from:Int) -> String{
        return self[from..<self.count]
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        guard let from = range.lowerBound.samePosition(in: utf16) , let to = range.upperBound.samePosition(in: utf16) else {
            return nil
        }
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }

  
    
    
    /// 移除首尾字符
    /// - Returns: 结果字符
    func removeStarethar(string:String) -> String {
        
        var str = self
        
        while str.hasPrefix(string) {
            str.removeFirst()
        }
        return str
    }
    
    
    
    func subRangeString(startString:String,endString:String) -> String? {
        guard let firstrange = self.range(of: startString) else {
            return nil
        }
        let location = self.distance(from: self.startIndex, to: firstrange.upperBound)
        let subStr = self.suffix(self.count - location)

        guard let lastRange = subStr.range(of: endString) else {
            return nil
        }

        let lastLocation = subStr.distance(from: subStr.startIndex, to: lastRange.lowerBound)
        let code = subStr.prefix(lastLocation)
        return String(code)
    }
    
    func getEffectValueString() -> String {
        
        var newString = ""
        self.forEach { (c) in
            if c.isNumber {
                newString += "\(c)"
            }
            
        }
        return newString
        
        
    }
    
    
    func getDfuString(completeString:String) -> Bool {
        
        guard self.count > 2 , self.count == completeString.count else {
            return false
        }
        // 取后两位
        let startIndex = self.index(self.startIndex, offsetBy: self.count-2)
        let endIndex = self.index(startIndex, offsetBy: 2)
        let datalastString = String(self[startIndex ..< endIndex])
        let completeLastString = String(completeString[startIndex ..< endIndex])

        let dataUint = hexStringToInt(from: datalastString.uppercased())
        let completeUint = hexStringToInt(from: completeLastString.uppercased())
        
        // 取前几位
        let dataPreString = self.prefix(self.count-2)
        let completePreString = completeString.prefix(completeString.count - 2)
        
        let completeResult = UInt8((dataUint + 0x01) & 0xff) == UInt8(completeUint & 0xff) && dataPreString.uppercased() == completePreString.uppercased()
     
        return completeResult
        
    }
    
    /// 反转mac地址
    func reversalMacAddress() -> String {
        
        var macLists = self.components(separatedBy: ":")
        macLists = macLists.reversed()
        
        return macLists.joined(separator: ":")
        
    }
    
    func hexStringToInt(from:String) -> Int {
        let str = from.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
    
    var hexInt:UInt32 {
        
        var hexString = self.uppercased()
        if hexString.hasPrefix("0X") {
            hexString = substring(from: 2)
        }
        
        
        return UInt32(hexStringToInt(from: hexString) & 0xffffffff)
        
    }
    
    /// 传入一个字符串，获取首字母
    var firstEnLetter:String {
        // 先去首尾空格
        let strInput = self.trimmingCharacters(in: CharacterSet.whitespaces)
        
        guard strInput.count > 0 else {
            return "#"
        }
       
        let ms = NSMutableString(string: strInput)
            
        CFStringTransform(ms, UnsafeMutablePointer.init(bitPattern: 0), kCFStringTransformToLatin, false)
        CFStringTransform(ms, UnsafeMutablePointer.init(bitPattern: 0), kCFStringTransformStripDiacritics, false)
        let pArr = ms.components(separatedBy: " ")
        
//        var strResult = String()
        
        guard let firstCharacter = pArr.first?.first else {
            return "#"
        }
        
//        pArr.forEach { s in
//            if let firstCharacter = s.first {
//                strResult += String(firstCharacter).uppercased()
//            }
//
//
//        }
        
        return firstCharacter.uppercased()
    }
 
    
    var isURLLink:Bool {
        
        // 先去首尾空格
        let strInput = self.trimmingCharacters(in: CharacterSet.whitespaces)
        
        return strInput.hasPrefix("http")
        
    }
    
    func regex(pattern:String) -> Bool {
        
        let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        
        guard let result = regex?.numberOfMatches(in: self,options: NSRegularExpression.MatchingOptions(rawValue: 0) ,range: NSRange(location: 0, length: self.count)) else {
            return false
        }
        
        return result > 0
    }
    
}
