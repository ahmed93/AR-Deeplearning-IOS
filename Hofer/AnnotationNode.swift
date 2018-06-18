//
//  AnnotationNode.swift
//  Test
//
//  Created by Ahmed Magdi on 5/23/18.
//  Copyright © 2018 Ahmed Magdi. All rights reserved.
//

import Foundation
import ARKit

class Node: SCNNode {
    
    var title:String = ""
    var values:[String]?
    
    private var WIDTH:CGFloat = 200
    private var HEIGHT:CGFloat = 200
    private let CORNER_RADIUS:CGFloat = 5
    private let FILL_COLOR:UIColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.4649537852)//#colorLiteral(red: 0.8082000613, green: 0.09914044291, blue: 0.3305912912, alpha: 1)
    private let STROKE_COLOR:UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0)
    private let LINE_WIDTH:CGFloat = 2
    private let ALPHA:CGFloat = 0.8
    
    var clickedPoint:SCNVector3!
    
    var selected:(()->())?
    
    init(name:String, title:String, values:[String]? = nil, loc:SCNVector3) {
        super.init()
        self.name = name
        self.title = title
        self.values = values
        self.clickedPoint = loc
        
        viewData(view: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewData(view:Int = 0) {
        if view == 0 { // list
            listView()
        } else { // cirular
            cirularView()
        }
    }
    
    
    func listView() {
        //        let billboardConstraint = SCNBillboardConstraint()
        //        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        //
        //        let skScene = SKScene(size: CGSize(width: WIDTH, height: HEIGHT))
        //        skScene.backgroundColor = UIColor.clear
        //
        //        let rectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT), cornerRadius: CORNER_RADIUS)
        //        rectangle.fillColor = FILL_COLOR
        //        rectangle.strokeColor = STROKE_COLOR
        //        rectangle.lineWidth = LINE_WIDTH
        //        rectangle.alpha = ALPHA
        //
        //        let labelNode = createLabel(text: title, fontSize: 20)
        //
        //        skScene.addChild(rectangle)
        //        skScene.addChild(labelNode)
        //
        //        if let vals = values, vals.count > 0 {
        //            let moreLabelNode = createLabel(text: "more...", fontSize: 15, location: CGPoint(x: 40,y: HEIGHT - 10))
        //            skScene.addChild(moreLabelNode)
        //            var currectHeight:CGFloat = labelNode.frame.size.height + 5
        //
        //            for val in vals {
        //                let lNode = createNode(scene:skScene, text: val, fontSize: 15, location: CGPoint(x: 40 ,y: currectHeight))
        //                currectHeight += lNode
        //            }
        //        }
        //
        //        let plane = SCNPlane(width: 0.1 , height: 0.1)
        //        let material = SCNMaterial()
        //        material.isDoubleSided = true
        //        material.diffuse.contents = skScene
        //        plane.materials = [material]
        //
        //        //        self.pivot
        //        self.geometry = plane
        //        self.constraints = [billboardConstraint]
    }
    
    func cirularView() {
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        let cWIDTH:CGFloat = 500
        let cHEIGHT:CGFloat = 500
        
        let skScene = SKScene(size: CGSize(width: cWIDTH, height: cHEIGHT))
        skScene.backgroundColor = .clear
        skScene.anchorPoint = CGPoint(x: 0, y: 0)
        
        let rectangle = SKShapeNode(rect: CGRect(x: cWIDTH/4, y: cHEIGHT/4, width: cWIDTH/2, height: cHEIGHT/2), cornerRadius: cWIDTH/4)
        rectangle.fillColor = FILL_COLOR
        rectangle.strokeColor = STROKE_COLOR
        rectangle.lineWidth = LINE_WIDTH
        rectangle.alpha = ALPHA
        
        let labelNode = SKLabelNode(text: title.trimmingCharacters(in: .whitespaces))
        labelNode.fontSize = 20
        labelNode.fontName = "San Fransisco"
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        labelNode.preferredMaxLayoutWidth = WIDTH
        labelNode.position = CGPoint(x: cWIDTH/2, y: cHEIGHT/2)
        labelNode.numberOfLines = 0
        labelNode.yScale = -1
        
        skScene.addChild(rectangle)
        skScene.addChild(labelNode)
        
        if let vals = values, vals.count > 0 {
            let angle:CGFloat = CGFloat(360) / CGFloat(vals.count)
            let r = cHEIGHT / 4
            for a in 0..<vals.count {
                let ang = CGFloat(angle * CGFloat(a))
                let x = cWIDTH/4 + r * cos(CGFloat( ang * CGFloat.pi / 180)) + cWIDTH/4
                let y = cHEIGHT/4 + r * sin(CGFloat(ang *  CGFloat.pi / 180)) + cHEIGHT/4
                let node = ItemLabelNode(title:  String(vals[a].split(separator: ":").first!), value:  String(vals[a].split(separator: ":").last!), preferredMaxLayoutWidth: WIDTH - 10)
                node.position = CGPoint(x: x ,y: y)
                skScene.addChild(node)
                print(angle)
                if ang == 0 || ang == 360 {
                    node.position = CGPoint(x: x - node.width/4 ,y: y - node.height/2)
                }else if ang == 90 || ang == 270 {
                    node.position = CGPoint(x: x - node.width/2 ,y: y)
                }else if ang == 180 {
                    node.position = CGPoint(x: x - node.width*0.7 ,y: y - node.height/2)
                }else
                if ang > 0 && ang < 90 {
                    node.position = CGPoint(x: x ,y: y)
                }else if ang > 90 && ang < 180 {
                    node.position = CGPoint(x: x - node.width*0.7 ,y: y )
                }else if ang > 180 && ang < 270 {
                    node.position = CGPoint(x: x - node.width*0.7 ,y: y )
                }else if ang > 270 && ang < 360 {
                    node.position = CGPoint(x: x ,y: y)
                }
            }
        }
        
        let plane = SCNPlane(width: 0.5 , height: 0.5)
        let material = SCNMaterial()
        
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        plane.materials = [material]
        

        self.geometry = plane
        self.constraints = [billboardConstraint]
    }
    
    
    private func createNode(scene:SKScene, text:String, fontSize:CGFloat, location:CGPoint = CGPoint(x:20,y:20), overrideLocation:Bool = false) -> CGFloat {
        let l = ItemLabelNode(title:  String(text.split(separator: ":").first!), value:  String(text.split(separator: ":").last!), preferredMaxLayoutWidth: WIDTH - 10)
        l.position = overrideLocation ? location : CGPoint(x: 5,y: location.y + 10)
        scene.addChild(l)
        return l.height
        
        //        let label = createLabel(text: String(text.split(separator: ":").first!), fontSize: 15)
        //        label.fontColor = .red
        //        label.preferredMaxLayoutWidth = (WIDTH - 10 ) * 0.30
        //        label.position = CGPoint(x: 5,y: location.y + 10)
        //        label.numberOfLines = 2
        //
        //        label.lineBreakMode = .byWordWrapping
        //        scene.addChild(label)
        //
        //        let valueLabel = createLabel(text: String(text.split(separator: ":").last!), fontSize: 12)
        //        valueLabel.preferredMaxLayoutWidth = (WIDTH - 10 ) * 0.70
        //        valueLabel.position = CGPoint(x: (WIDTH - 10 ) * 0.30 ,y: location.y + 10)
        //        valueLabel.numberOfLines = 2
        //        scene.addChild(valueLabel)
        //
        //        return CGFloat.maximum(label.frame.size.height, valueLabel.frame.size.height)
    }
    
    private func createLabel(text:String, fontSize:CGFloat, location:CGPoint = CGPoint(x:20,y:20), overrideLocation:Bool = false) -> SKLabelNode {
        let labelNode = SKLabelNode(text: text.trimmingCharacters(in: .whitespaces))
        labelNode.fontSize = fontSize
        labelNode.fontName = "San Fransisco"
        labelNode.horizontalAlignmentMode = .left
        labelNode.verticalAlignmentMode = .center
        labelNode.preferredMaxLayoutWidth = WIDTH - 10
        labelNode.position = overrideLocation ? location : CGPoint(x: 5, y: location.y + 5)
        labelNode.numberOfLines = 0
        labelNode.yScale = -1
        return labelNode
    }
    
    
}
