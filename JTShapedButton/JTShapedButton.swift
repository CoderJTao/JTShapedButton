//
//  JTShapedButton.swift
//  ShapedButtonDemo
//
//  Created by 江涛 on 2019/4/8.
//  Copyright © 2019 江涛. All rights reserved.
//

import UIKit

class JTShapedButton: UIButton {
    private let DoNotResponseAlphaThreshold: CGFloat = 0.1
    
    // default value is a point which can never be touched
    private var previousTouchPoint = CGPoint(x: -9999, y: -999)
    
    private var previousTouchHitTestResponse = false
    
    private var btn_image: UIImage? {
        get {
            return self.currentImage
        }
    }
    private var btn_backgroundImage: UIImage? {
        get {
            return self.currentBackgroundImage
        }
    }
}

extension JTShapedButton {
    // UIView uses this method in hitTest:withEvent: to determine which subview should receive a touch event.
    // If pointInside:withEvent: returns YES, then the subview’s hierarchy is traversed; otherwise, its branch
    // of the view hierarchy is ignored.
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let superResult = super.point(inside: point, with: event)
        
        if !superResult {
            return superResult
        }
        
        // Don't check again if we just queried the same point
        // (because pointInside:withEvent: gets often called multiple times)
        if point.equalTo(previousTouchPoint) {
            return self.previousTouchHitTestResponse
        } else {
            self.previousTouchPoint = point
        }
        
        let response = self.shouldResponse(atPoint: point, forImage: btn_image) || self.shouldResponse(atPoint: point, forImage: btn_backgroundImage)
        
        self.previousTouchHitTestResponse = response
        
        return response
    }
    
    private func shouldResponse(atPoint point: CGPoint, forImage image: UIImage?) -> Bool {
        guard let contentImage = image, let contentView = self.imageView else {
            return false
        }
        
        var image_point = CGPoint(x: point.x - contentView.frame.origin.x, y: point.y - contentView.frame.origin.y)
        
        if contentImage == btn_backgroundImage {
            let imageV = UIImageView(frame: self.bounds)
            imageV.image = contentImage
            image_point = image_point.applying(imageV.viewToImageTransform())
        } else {
            image_point = image_point.applying(contentView.viewToImageTransform())
        }
        
        let pixelColor = contentImage.color(at: image_point)
        
        var alpha: CGFloat = 0.0
        
        if let getColor = pixelColor {
            getColor.getRed(nil, green: nil, blue: nil, alpha: &alpha)
        }
        
        return alpha >= DoNotResponseAlphaThreshold
    }
}

private extension UIImageView {
    func viewToImageTransform() -> CGAffineTransform {
        guard let currentImage = self.image else {
            return CGAffineTransform.identity
        }
        
        let contentMode = self.contentMode
        
        if self.frame.size.width == 0 || self.frame.size.height == 0
            || (contentMode != .scaleToFill && contentMode != .scaleAspectFit && contentMode != .scaleAspectFill) {
            return CGAffineTransform.identity
        }
        
        let ratioWidth: CGFloat = currentImage.size.width / self.frame.size.width
        let ratioHeight: CGFloat = currentImage.size.height / self.frame.size.height
        
        let imageWiderThanView = ratioWidth > ratioHeight
        
        if contentMode == .scaleAspectFill || contentMode == .scaleAspectFit {
            let ratio = ((imageWiderThanView && contentMode == .scaleAspectFit) || (!imageWiderThanView && contentMode == .scaleAspectFill)) ? ratioWidth:ratioHeight
            
            let xOffset = (currentImage.size.width - (self.frame.size.width * ratio)) * 0.5
            let yOffset = (currentImage.size.height - (self.frame.size.height * ratio)) * 0.5
            
            return CGAffineTransform(scaleX: ratio, y: ratio).concatenating(CGAffineTransform(translationX: xOffset, y: yOffset))
        } else {
            return CGAffineTransform(scaleX: ratioWidth, y: ratioHeight)
        }
    }
    
    func imageToViewTransfrom() -> CGAffineTransform {
        return self.viewToImageTransform().inverted()
    }
}

private extension UIImage {
    func color(at point: CGPoint) -> UIColor? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * Int(size.width)
        let bitsPerComponent = 8
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo),
            let ptr = context.data?.assumingMemoryBound(to: UInt8.self) else {
                return nil
        }
        
        guard let curentCGImage = self.cgImage else {
            return nil
        }
        
        context.draw(curentCGImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let i = bytesPerRow * Int(point.y) + bytesPerPixel * Int(point.x)
        
        let a = CGFloat(ptr[i + 3]) / 255.0
        let r = (CGFloat(ptr[i]) / a) / 255.0
        let g = (CGFloat(ptr[i + 1]) / a) / 255.0
        let b = (CGFloat(ptr[i + 2]) / a) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
}

