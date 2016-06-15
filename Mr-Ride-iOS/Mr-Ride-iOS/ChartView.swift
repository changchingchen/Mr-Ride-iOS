//
//  TestView.swift
//  Chart
//
//  Created by Chang-Ching CHEN on 6/8/16.
//  Copyright © 2016 Chang-Ching CHEN. All rights reserved.
//

import UIKit

@IBDesignable
class ChartView: UIView {

    
    var graphPoints = [Double]() { didSet { setNeedsDisplay() } }
    var needsToMarkToday = false
    var todayLabel: UILabel!
    private let maxGraphHeight: CGFloat = 153.0
    
    override func drawRect(rect: CGRect) {
    
        // Drawing code
        let width = bounds.width
        let height = min(maxGraphHeight, bounds.height)

        UIColor.clearColor().setStroke()
        
        var startColor = UIColor.mrTurquoiseBlue()
        var endColor = UIColor.mrBrightSkyBlue()
        
        
        if needsToMarkToday {
            startColor = UIColor.mrWaterBlue()
            endColor = UIColor.mrLightblueColor()
//            startColor = UIColor.mrLightblueColor()
//            endColor = UIColor.mrWaterBlue()

        
        } else {
            startColor = UIColor.mrTurquoiseBlue()
            endColor = UIColor.mrBrightSkyBlue()
        }
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor] // start and end color of the gradient
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0] // color stop number within [0.0, 1.0]; count should match colors of the gradient
        
        let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
        
        let numberOfRows = 6
        let verticalSpace = height / CGFloat(numberOfRows)
        

        
        let numberOfColumns = graphPoints.count
        let margin: CGFloat = 0.0
        let horizontalSpace = (width - margin*2) / CGFloat(numberOfColumns - 1)
        let topBorder: CGFloat = 20.0
        let graphHeight = height - topBorder

        if !graphPoints.isEmpty {
            let maxGraphPoint = graphPoints.maxElement()!
            var graphCurvePath = UIBezierPath()
            var currentPoint =  CGPoint(
                x: calculateXPoint(margin: margin, horizontalSpace: horizontalSpace, column: 0),
                y: calculateYPoint(topBorder: topBorder, graphHeight: graphHeight, maxGraphPoint: maxGraphPoint, graphPoint: graphPoints[0])
            )
            graphCurvePath.moveToPoint(currentPoint)
            for index in 1..<graphPoints.count {
                let nextPoint = CGPoint(
                    x: calculateXPoint(margin: margin, horizontalSpace: horizontalSpace, column: index),
                    y: calculateYPoint(topBorder: topBorder, graphHeight: graphHeight, maxGraphPoint: maxGraphPoint, graphPoint: graphPoints[index])
                )
                graphCurvePath = addSinusoidalCurvedPathWithPoints(graphCurvePath, startPoint: currentPoint, endPoint: nextPoint)
                currentPoint = nextPoint
            }
            

            graphCurvePath.lineWidth = 2.0
            graphCurvePath.stroke()
            
            
            CGContextSaveGState(context)
            
            let clippingPath = graphCurvePath.copy() as! UIBezierPath
            
            clippingPath.addLineToPoint(CGPoint(x: calculateXPoint(margin: margin, horizontalSpace: horizontalSpace, column: graphPoints.count - 1), y: height))
            clippingPath.addLineToPoint(CGPoint(x: calculateXPoint(margin: margin, horizontalSpace: horizontalSpace, column: 0), y: height))
            clippingPath.closePath()
            clippingPath.addClip()
            
            let highestYPoint = calculateYPoint(topBorder: topBorder, graphHeight: graphHeight, maxGraphPoint: maxGraphPoint, graphPoint: maxGraphPoint)
            let startPoint = CGPoint(x: margin, y: highestYPoint)
            let endPoint = CGPoint(x: margin, y: height)
            
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, CGGradientDrawingOptions(rawValue: 0))
            
            CGContextRestoreGState(context)
            
            if needsToMarkToday {
                let graphPointIndex = graphPoints.count-2
                let todayPointRadius: CGFloat = 4.0
                let todayPointDiameter = todayPointRadius * 2
                var todayPoint = CGPoint(
                    x: calculateXPoint(margin: margin, horizontalSpace: horizontalSpace, column: graphPointIndex),
                    y: calculateYPoint(topBorder: topBorder, graphHeight: graphHeight, maxGraphPoint: maxGraphPoint, graphPoint: graphPoints[graphPointIndex])
                    )
                todayPoint.x -= todayPointRadius
                todayPoint.y -= todayPointRadius
                
                let circle = UIBezierPath(ovalInRect: CGRect(origin: todayPoint, size: CGSize(width: todayPointDiameter, height: todayPointDiameter)))
                UIColor.mrWhiteColorWithAlpha(0.7).setFill()
                circle.fill()
                
                let todayLabelWidth: CGFloat = 30.0
                let todayLabelHeight: CGFloat = 12.0
                if todayLabel != nil {
                    todayLabel.removeFromSuperview()
                }
                todayLabel = UILabel(frame: CGRectMake(todayPoint.x - todayLabelWidth/2+todayPointRadius, todayPoint.y-todayPointDiameter-todayLabelHeight, todayLabelWidth, todayLabelHeight))
                todayLabel.text = "Today"
                todayLabel.textColor = UIColor.mrWhiteColorWithAlpha(0.5)
                todayLabel.font = UIFont.mrTextStyleFontSFUITextRegular(10.0)
                todayLabel.textAlignment = .Center
                self.addSubview(todayLabel)
            }
            
            
            
        }
        
        if !needsToMarkToday {
            // Draw horizontal lines
            let linePath = UIBezierPath()
            for row in 0..<numberOfRows {
                linePath.moveToPoint(CGPoint(x: 0.0, y: height - CGFloat(row) * verticalSpace))
                linePath.addLineToPoint(CGPoint(x: width, y:height - CGFloat(row) * verticalSpace))
            }
            UIColor.whiteColor().setStroke()
            linePath.lineWidth = 0.5
            linePath.stroke()
        }
//        graphPath.lineWidth = 2.0
//        graphPath.stroke()
        
//        for i in 0..<graphPoints.count {
//            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
//            point.x -= 5.0/2
//            point.y -= 5.0/2
//            
//            let circle = UIBezierPath(
//                ovalInRect: CGRect(origin: point,
//                    size: CGSize(width: 5.0, height: 5.0)))
//            circle.fill()
//        }
        

        
        
//        let graphPath = UIBezierPath()
//        graphPath.moveToPoint(
//            CGPoint(
//                x: calculateXPoint(margin: margin, horizontalSpace: horizontalSpace, column: 0),
//                y: calculateYPoint(topBorder: topBorder, graphHeight: graphHeight, maxGraphPoint: maxGraphPoint, graphPoint: graphPoints[0])
//                    )
//            )
//        for index in 1..<graphPoints.count {
//            let nextPoint = CGPoint(
//                x: calculateXPoint(margin: margin, horizontalSpace: horizontalSpace, column: index),
//                y: calculateYPoint(topBorder: topBorder, graphHeight: graphHeight, maxGraphPoint: maxGraphPoint, graphPoint: graphPoints[index])
//            )
//            graphPath.addLineToPoint(nextPoint)
//        }
//        
//        UIColor.redColor().setStroke()
//        graphPath.stroke()
        

        
    }
    
    private func calculateXPoint(margin margin: CGFloat, horizontalSpace: CGFloat, column: Int) -> CGFloat {
        return CGFloat(column) * horizontalSpace + margin
    }

    private func calculateYPoint(topBorder topBorder: CGFloat, graphHeight: CGFloat, maxGraphPoint: Double, graphPoint: Double) -> CGFloat {
        
        return topBorder + (1 - CGFloat(graphPoint/maxGraphPoint)) * graphHeight //Flip the graph

    }

    private func addSinusoidalCurvedPathWithPoints(path: UIBezierPath, startPoint: CGPoint, endPoint: CGPoint) -> UIBezierPath {
        
        let midPoint = calculateMidPoint(point1: startPoint, point2: endPoint)
        
        path.addQuadCurveToPoint(midPoint, controlPoint: calculateControlPointFromMidPoint(midPoint, point2: startPoint))
        path.addQuadCurveToPoint(endPoint, controlPoint: calculateControlPointFromMidPoint(midPoint, point2: endPoint))
        
        return path

        
    }
    
    private func quadCurvedPathWithPoints(startPoint startPoint: CGPoint, endPoint: CGPoint) -> UIBezierPath {
        
        let midPoint = calculateMidPoint(point1: startPoint, point2: endPoint)
        
        
        let curvePath = UIBezierPath()
        curvePath.moveToPoint(startPoint)
        
        curvePath.addQuadCurveToPoint(midPoint, controlPoint: calculateControlPointFromMidPoint(midPoint, point2: startPoint))
   
        curvePath.addQuadCurveToPoint(endPoint, controlPoint: calculateControlPointFromMidPoint(midPoint, point2: endPoint))
            
        
        
        curvePath.lineWidth = 3.0
        
        return curvePath
        
    }

    private func calculateMidPoint(point1 point1: CGPoint, point2: CGPoint) -> CGPoint {
        return CGPoint(x: (point1.x+point2.x)/2 , y: (point1.y+point2.y)/2)
    }
    
    
    private func calculateControlPointFromMidPoint(point1: CGPoint, point2: CGPoint) -> CGPoint {
        let midPoint = calculateMidPoint(point1: point1, point2: point2)
        
        let controlPoint = CGPoint(x: midPoint.x, y: point2.y)
        
        return controlPoint
    }

    
    
}
