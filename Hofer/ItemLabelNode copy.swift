//
//  ItemLabelNode.swift
//  Hofer
//
//  Created by Ahmed Magdi on 5/30/18.
//  Copyright © 2018 Ahmed Magdi. All rights reserved.
//

import Foundation
import ARKit

class ItemLabelNode : SKNode
{
    var label : SKLabelNode!
    var valueLabel : SKLabelNode!
    
    var height:CGFloat {
        return CGFloat.maximum(label.frame.size.height, valueLabel.frame.size.height)
    }
    var width:CGFloat {
        return label.frame.size.width +  valueLabel.frame.size.width
    }
    
    private let CORNER_RADIUS:CGFloat = 5
    private let FILL_COLOR:UIColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)//#colorLiteral(red: 0.8082000613, green: 0.09914044291, blue: 0.3305912912, alpha: 1)
    private let STROKE_COLOR:UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    private let LINE_WIDTH:CGFloat = 2
    private let ALPHA:CGFloat = 0.8
    
//    var preferredMaxLayoutWidth:CGFloat = 0 {
//        didSet {
//            if preferredMaxLayoutWidth == 0 {
//                return
//            }
//            label.preferredMaxLayoutWidth = preferredMaxLayoutWidth * 0.30
//            valueLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth * 0.70
//        }
//    }
    
    init( title:String, value:String, preferredMaxLayoutWidth:CGFloat) {
        super.init()
        
        label = createLabel(text: "\(title) : ")
        label.position = CGPoint(x: 0, y: 0 )
        label.fontSize = 15
        label.fontColor = .red
        label.preferredMaxLayoutWidth = preferredMaxLayoutWidth * 0.30
        
        valueLabel = createLabel(text: "\(value)")
        valueLabel.position = CGPoint(x: label.preferredMaxLayoutWidth, y: 0)
        valueLabel.fontSize = 12
        valueLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth * 0.70
        
        let rectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: preferredMaxLayoutWidth, height: height), cornerRadius: 5)
        rectangle.fillColor = FILL_COLOR
        rectangle.strokeColor = STROKE_COLOR
        rectangle.lineWidth = LINE_WIDTH
        rectangle.alpha = ALPHA
        addChild(rectangle)
        
        addChild(label)
        addChild(valueLabel)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func createLabel(text:String) -> SKLabelNode {
        let labelNode = SKLabelNode(text: text)
//        labelNode.fontSize = fontSize
        labelNode.fontName = "San Fransisco"
        labelNode.horizontalAlignmentMode = .left
        labelNode.verticalAlignmentMode = .center
//        labelNode.preferredMaxLayoutWidth = self.frame.size.width - 10
//        labelNode.position = CGPoint(x: 5, y: location.y + 5)
        labelNode.numberOfLines = 0
        labelNode.yScale = -1
        return labelNode
    }
    
}
