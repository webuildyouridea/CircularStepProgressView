//
//  CircularStepProgressView.swift
//  CircularStepProgressView
//
//  Created by Arpad Larrinaga on 4/17/17.
//  Copyright © 2017 muub. All rights reserved.
//

import UIKit
import pop

public protocol CircularStepProgressDelegate: class {
    func didFinishCompleteAnimation(sender: CircularStepProgressView)
}

@IBDesignable
public class CircularStepProgressView: UIView {

    weak public var delegate: CircularStepProgressDelegate?
    var backgroundCircleLayer: CAShapeLayer!
    var progressLayer: CAShapeLayer!
    var completeLayer: CAShapeLayer!
    var circlePoints:[CAShapeLayer] = []
    var pointDuration: CFTimeInterval = 0.4
    public var points: Int = 0
    @IBInspectable
    public var steps: Int = 10 {
        didSet {
            drawSteps()
        }
    }
    @IBInspectable
    public var fillColor: UIColor = UIColor(red: 1.000, green: 0.281, blue: 0.000, alpha: 1.000){
        didSet {
            configureInitial()
            drawSteps()
        }
    }
    @IBInspectable
    public var backColor: UIColor = UIColor(red: 0.777, green: 0.751, blue: 0.751, alpha: 1.000){
        didSet {
            configureInitial()
            drawSteps()
        }
    }
    @IBInspectable
    public var circleColor: UIColor = UIColor.white{
        didSet {
            configureInitial()
            drawSteps()
        }
    }
    @IBInspectable
    public var pathLineWidth:CGFloat = 9.0{
        didSet {
            configureInitial()
            drawSteps()
        }
    }
    @IBInspectable
    public var circleLineWidth:CGFloat = 1.0{
        didSet {
            configureInitial()
            drawSteps()
        }
    }
    @IBInspectable
    public var padding:CGFloat = 12.0{
        didSet {
            configureInitial()
            drawSteps()
        }
    }
    @IBInspectable
    public var circleRadius:CGFloat = 15.0{
        didSet {
            configureInitial()
            drawSteps()
        }
    }
    
    private var progress: CGFloat = 0
    private var radius: CGFloat = 0
    private var progressPoint: CGFloat = 0
    
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        configureInitial()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        configureInitial()
        drawSteps()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func configureInitial() {
        if let backgroundCircleLayer = backgroundCircleLayer {
            backgroundCircleLayer.removeFromSuperlayer()
        }
        if let progressLayer = progressLayer {
            progressLayer.removeFromSuperlayer()
        }
        if let completeLayer = completeLayer {
            completeLayer.removeFromSuperlayer()
        }
        self.backgroundColor = UIColor.clear
        
        radius = (bounds.width - padding - circleRadius)/2
        
        let ovalPath = UIBezierPath()
        ovalPath.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: radius, startAngle: -250 * CGFloat.pi/180, endAngle: 70 * CGFloat.pi/180, clockwise: true)
        
        
        backgroundCircleLayer = CAShapeLayer()
        backgroundCircleLayer.path = ovalPath.cgPath
        backgroundCircleLayer.fillColor = UIColor.clear.cgColor
        backgroundCircleLayer.strokeColor = backColor.cgColor
        backgroundCircleLayer.lineWidth = pathLineWidth;
        backgroundCircleLayer.lineCap = kCALineCapRound
        
        progressLayer = CAShapeLayer()
        progressLayer.path = ovalPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = fillColor.cgColor
        progressLayer.lineWidth = pathLineWidth;
        progressLayer.lineCap = kCALineCapRound
        progressLayer.strokeEnd = 0
        
        completeLayer = CAShapeLayer()
        completeLayer.path = ovalPath.cgPath
        completeLayer.fillColor = UIColor.clear.cgColor
        completeLayer.strokeColor = backColor.cgColor
        completeLayer.lineWidth = pathLineWidth;
        completeLayer.lineCap = kCALineCapRound
        completeLayer.strokeEnd = 0
        
        layer.addSublayer(backgroundCircleLayer)
        layer.addSublayer(progressLayer)
        layer.addSublayer(completeLayer)
    }
    
    func drawSteps() {
        if circlePoints.count > 0 {
            for smallCircleLayer in circlePoints {
                smallCircleLayer.removeFromSuperlayer()
            }
            circlePoints.removeAll()
        }
        
        var points = circleCircumferencePoints(steps + 1, bounds.midX, bounds.midY, (bounds.width - padding - circleRadius)/2, 286)
        progressPoint = 1.0 / CGFloat(steps + 1)
        points.removeFirst()
        points.removeLast()
        for point in points {
            
            // decide on radius
            let rad = circleRadius
            
            let endAngle = CGFloat(2*Double.pi)
            
            // add the circle to the context
            let circlePath = UIBezierPath()
            circlePath.addArc(withCenter: point,
                              radius: rad,
                              startAngle: 0,
                              endAngle: endAngle,
                              clockwise: true)
            
            let newCircleLayer = CAShapeLayer()
            newCircleLayer.path = circlePath.cgPath
            newCircleLayer.anchorPoint = point
            newCircleLayer.fillColor = circleColor.cgColor
            newCircleLayer.lineWidth = circleLineWidth;
            newCircleLayer.strokeColor = backColor.cgColor
            layer.addSublayer(newCircleLayer)
            circlePoints.append(newCircleLayer)
        }
        
        circlePoints = circlePoints.reversed()
    }

    func degree2radian(_ a:CGFloat)->CGFloat {
        let b = CGFloat(Double.pi) * a/180
        return b
    }
    
    func circleCircumferencePoints(_ sides:Int,_ x:CGFloat,_ y:CGFloat,_ radius:CGFloat,_ adjustment:CGFloat=0)->[CGPoint] {
        let angle = degree2radian(330/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides {
            let xpo = cx - r * cos(angle * CGFloat(i)+degree2radian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i)+degree2radian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i = i - 1
        }
        return points
    }
    
    public func addPoint() {
        guard points < steps else {
            return
        }
        
        if points == 0 {
            completeLayer.pop_removeAllAnimations()
            progressLayer.pop_removeAllAnimations()
        }
        
        if points == steps - 1 {
            animateLastPoint()
            animateCircle()
            return
        }
        
        animateProgressBar()
        animateCircle()
        
    }
    
    public func animate(toStep step: Int) {
        let fillStrokeAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)!
        fillStrokeAnimation.duration = pointDuration
        fillStrokeAnimation.fromValue = 0
        fillStrokeAnimation.toValue = progressPoint * CGFloat(step)
        fillStrokeAnimation.removedOnCompletion = false
        fillStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        progressLayer.pop_add(fillStrokeAnimation, forKey: "FillStrokeAnimation")
        
        progress = progressPoint * CGFloat(step)
        points = step
        
        animateCircles(toStep: step)
    }
    
    func animateCircles(toStep step: Int) {
        let circleDuration = pointDuration / CFTimeInterval(step+1)
        var begintime = CACurrentMediaTime()
        for i in 0..<step {
            let pointLayer = circlePoints[i]
            begintime = begintime + circleDuration
            let fillColorAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerFillColor)!
            fillColorAnimation.beginTime = begintime
            fillColorAnimation.duration = 0.001
            fillColorAnimation.removedOnCompletion = false
            fillColorAnimation.fromValue = circleColor.cgColor
            fillColorAnimation.toValue = fillColor.cgColor
            fillColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            
            let strokeColorAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeColor)!
            strokeColorAnimation.beginTime = begintime
            strokeColorAnimation.duration = 0.001
            strokeColorAnimation.removedOnCompletion = false
            strokeColorAnimation.fromValue = backColor.cgColor
            strokeColorAnimation.toValue = fillColor.cgColor
            strokeColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            
            pointLayer.pop_add(fillColorAnimation, forKey: "FillCircle")
            pointLayer.pop_add(strokeColorAnimation, forKey: "FillStroke")
        }
    }
    
    func animateProgressBar() {
        let fillStrokeAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)!
        fillStrokeAnimation.duration = pointDuration
        fillStrokeAnimation.fromValue = progress
        fillStrokeAnimation.toValue = progress + progressPoint
        fillStrokeAnimation.removedOnCompletion = false
        fillStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        progressLayer.pop_add(fillStrokeAnimation, forKey: "FillStrokeAnimation")
        
        progress = progress + progressPoint
    }
    
    func animateCircle() {
        let fillColorAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerFillColor)!
        fillColorAnimation.beginTime = CACurrentMediaTime() + pointDuration/10*9
        fillColorAnimation.duration = 0.15
        fillColorAnimation.removedOnCompletion = false
        fillColorAnimation.fromValue = circleColor.cgColor
        fillColorAnimation.toValue = fillColor.cgColor
        fillColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        let strokeColorAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeColor)!
        strokeColorAnimation.beginTime = CACurrentMediaTime() + pointDuration/10*9
        strokeColorAnimation.duration = 0.15
        strokeColorAnimation.removedOnCompletion = false
        strokeColorAnimation.fromValue = backColor.cgColor
        strokeColorAnimation.toValue = fillColor.cgColor
        strokeColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        circlePoints[points].pop_add(fillColorAnimation, forKey: "FillCircle")
        circlePoints[points].pop_add(strokeColorAnimation, forKey: "FillStroke")
        
        points = points + 1
    }
    
    func animateLastPoint() {
        let fillStrokeAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)!
        fillStrokeAnimation.duration = pointDuration * 2
        fillStrokeAnimation.fromValue = progress
        fillStrokeAnimation.toValue = progress + progressPoint * 2
        fillStrokeAnimation.removedOnCompletion = false
        fillStrokeAnimation.delegate = self
        fillStrokeAnimation.name = "FillStrokeEndAnimation"
        fillStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        progressLayer.pop_add(fillStrokeAnimation, forKey: "FillStrokeEndAnimation")
        
        progress = progress + progressPoint * 2
        
    }
    
    func animateReverse() {
        let animationToZero = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)!
        animationToZero.duration = 0
        animationToZero.fromValue = progress
        animationToZero.toValue = 0.0
        animationToZero.beginTime = CACurrentMediaTime() + pointDuration * 4
        animationToZero.removedOnCompletion = false
        animationToZero.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        progressLayer.pop_add(animationToZero, forKey: "EndAnimation")
        
        let fillAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)!
        fillAnimation.duration = pointDuration * 4
        fillAnimation.fromValue = 0.0
        fillAnimation.toValue = 1
        fillAnimation.removedOnCompletion = false
        fillAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        fillAnimation.delegate = self
        fillAnimation.name = "EndAnimation"
        completeLayer.pop_add(fillAnimation, forKey: "EndAnimation")
        
        progress = 0
        points = 0
        
    }
    
    func animatePointsReverse() {
        let circleDuration = pointDuration * 4 / CFTimeInterval(steps+1)
        var begintime = CACurrentMediaTime()
        for pointLayer in circlePoints {
            begintime = begintime + circleDuration
            let fillColorAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerFillColor)!
            fillColorAnimation.beginTime = begintime
            fillColorAnimation.duration = 0.001
            fillColorAnimation.removedOnCompletion = false
            fillColorAnimation.fromValue = fillColor.cgColor
            fillColorAnimation.toValue = circleColor.cgColor
            fillColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            
            let strokeColorAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeColor)!
            strokeColorAnimation.beginTime = begintime
            strokeColorAnimation.duration = 0.001
            strokeColorAnimation.removedOnCompletion = false
            strokeColorAnimation.fromValue = fillColor.cgColor
            strokeColorAnimation.toValue = backColor.cgColor
            strokeColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            
            pointLayer.pop_add(fillColorAnimation, forKey: "EmptyFillColorAnimation")
            pointLayer.pop_add(strokeColorAnimation, forKey: "EmptyStrokeColorAnimation")
        }
    }
    
    func pop_animationDidStop(_ anim: POPAnimation!, finished: Bool) {
        if anim.name == "FillStrokeEndAnimation" {
            if finished {
                animateReverse()
                animatePointsReverse()
            }
        } else if anim.name == "EndAnimation" {
            if finished {
                completeLayer.strokeEnd = 0
                delegate?.didFinishCompleteAnimation(sender: self)
            }
        }
        
    }
}
