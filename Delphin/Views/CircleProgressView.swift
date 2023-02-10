//
//  CircleProgressView.swift
//  Delphin
//
//  Created by Рахат Султаналиулы on 09.02.2023.
//

import UIKit

class CircleProgressView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError(K.UIViewInitMsg)
    }
    
    public func drawProgress(percent: CGFloat) {
        layer.sublayers?.removeAll()
        // getting all sizes
        let circleFrame = UIScreen.main.bounds.width - 70 * 2
        let radius = circleFrame / 2
        let center = CGPoint(x: radius, y: radius)
        let startAngle = -CGFloat.pi * 2 / 9
        let endAngle = CGFloat.pi * 11 / 9
        
        // Setting points to stroke
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        
        // receiving shapes from custom method (method is written below)
        let circleLayer = getShapeFrom(path: circlePath, colour: K.Player.backSliderColour)
        let circleSlider = getShapeFrom(path: circlePath, colour: K.Player.mainSliderColour, end: percent)
        let dotLayer = getProgressDot(percent: percent, center: center, radius: radius)
        
        layer.addSublayer(circleLayer)
        layer.addSublayer(circleSlider)
        layer.addSublayer(dotLayer)
    }
    
    // drawing a shape with given path
    private func getShapeFrom(path: UIBezierPath, colour: UIColor, end: CGFloat = 1) -> CAShapeLayer {
        let circleSlider = CAShapeLayer()
            circleSlider.path = path.cgPath
            circleSlider.strokeColor = colour.cgColor
            circleSlider.lineWidth = 10
            circleSlider.strokeEnd = end
            circleSlider.fillColor = UIColor.clear.cgColor
            circleSlider.lineCap = .round
        return circleSlider
    }

    private func getProgressDot(percent: CGFloat, center: CGPoint, radius: CGFloat) -> CAShapeLayer {
        let dotAngle = CGFloat.pi * (2 / 9 - (13 / 9 * percent))
        let dotPoint = CGPoint(x: cos(-dotAngle) * radius + center.x, y: sin(-dotAngle) * radius + center.y)
        
        let dotPath = UIBezierPath()
            dotPath.move(to: dotPoint)
            dotPath.addLine(to: dotPoint)
        
        let dotLayer = getShapeFrom(path: dotPath, colour: .systemPink)
            dotLayer.lineWidth = 30
        
        return dotLayer
    }
}

// Rotate Animation
extension UIImageView{
    func rotate(_ active: Bool) {
        if active {
            let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotation.toValue = NSNumber(value: Double.pi * 2)
            rotation.duration = 25
            rotation.isCumulative = true
            rotation.repeatCount = Float.greatestFiniteMagnitude
            self.layer.add(rotation, forKey: "rotationAnimation")
        } else {
            self.layer.removeAllAnimations()
        }
    }
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
