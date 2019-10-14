//
//  Extension.swift
//  VouchSDK
//
//  Created by Ajie Pramono Arganata on 29/08/19.
//  Copyright © 2019 GITS Indonesia. All rights reserved.
//

import UIKit
import GrowingTextView
import SocketIO

internal class CardView: UIView {
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable private var shadow: CGFloat = 1 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable private var shadowRadius: CGFloat = 2.0 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable private var borderWidth: CGFloat = 0.0 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable public var borderColor: UIColor = .clear {
        didSet { setNeedsDisplay() }
    }
   
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: shadow)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = shadowRadius
        layer.shadowPath = shadowPath.cgPath
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

internal class CustomButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable public var shadow: CGFloat = 1 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable public var shadowRadius: CGFloat = 2.0 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var borderColor: UIColor = .clear {
        didSet { setNeedsDisplay() }
    }
    
    internal func changeFont(font: String) {
        guard let titleLabel = self.titleLabel else { return }
        titleLabel.font = FontHelper.font(fontEnum: FontHelperEnum(rawValue: font) ?? .unknown, currentFont: titleLabel.font)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        if shadow != 0 {
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            layer.shadowColor = UIColor.gray.cgColor
            layer.shadowOffset = CGSize(width: 0, height: shadow)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = shadowRadius
            layer.shadowPath = shadowPath.cgPath
        }
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

internal extension UILabel {
    func changeFont(fontText: String) {
        self.font = FontHelper.font(fontEnum: FontHelperEnum(rawValue: fontText) ?? .unknown, currentFont: font)
    }
}


internal extension GrowingTextView {
    func changeFont(fontText: String) {
        guard let font = font else { return }
        self.font = FontHelper.font(fontEnum: FontHelperEnum(rawValue: fontText) ?? .unknown, currentFont: font)
    }
}

internal extension Double {
    private var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }
    
    func secondsToString() -> String {
        return formatter.string(from: self) ?? ""
    }
    
}

internal extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}

internal enum ScrollDirection {
    case Top
    case Right
    case Bottom
    case Left
    
    func contentOffsetWith(scrollView: UIScrollView) -> CGPoint {
        var contentOffset = CGPoint.zero
        switch self {
        case .Top:
            contentOffset = CGPoint(x: 0, y: -scrollView.contentInset.top)
        case .Right:
            contentOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.size.width, y: 0)
        case .Bottom:
            contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        case .Left:
            contentOffset = CGPoint(x: -scrollView.contentInset.left, y: 0)
        }
        return contentOffset
    }
}

internal extension UIScrollView {
    func scrollTo(direction: ScrollDirection, animated: Bool = true) {
        self.setContentOffset(direction.contentOffsetWith(scrollView: self), animated: animated)
    }
}
