//
//  ViewController.swift
//  Hofer
//
//  Created by Ahmed Magdi on 4/26/18.
//  Copyright © 2018 Ahmed Magdi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

import Vision

class ViewController: UIViewController, ARSCNViewDelegate {
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?

    @IBOutlet weak var infoView: UIView!
    // SCENE
    @IBOutlet var sceneView: ARSCNView!
    let bubbleDepth : Float = 0.01 // the 'depth' of 3D text
    var latestPrediction : String = "…" // a variable containing the latest CoreML prediction
    var image: UIImage = UIImage()
    
    // COREML
    var visionRequests = [VNRequest]()
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    @IBOutlet weak var debugTextView: UITextView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var detectionImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Enable Default Lighting - makes the 3D text a bit poppier.
        sceneView.autoenablesDefaultLighting = true
        
        //////////////////////////////////////////////////
        // Tap Gesture Recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognize:)))
        view.addGestureRecognizer(tapGesture)
        
        //////////////////////////////////////////////////
        
        // Set up Vision Model
        guard let selectedModel = try? VNCoreMLModel(for: Inceptionv3().model) else { // (Optional) This can be replaced with other models on https://developer.apple.com/machine-learning/
            fatalError("Could not load model. Ensure model has been drag and dropped (copied) to XCode Project from https://developer.apple.com/machine-learning/ . Also ensure the model is part of a target (see: https://stackoverflow.com/questions/45884085/model-is-not-part-of-any-target-add-the-model-to-a-target-to-enable-generation ")
        }
        
        // Set up Vision-CoreML Request
        let classificationRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompleteHandler)
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop // Crop from centre of images and scale to appropriate size.
        visionRequests = [classificationRequest]
        
        // Begin Loop to Update CoreML
        loopCoreMLUpdate()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Enable plane detection
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            // Do any desired updates to SceneKit here.
        }
    }
    
    // MARK: - Status Bar: Hide
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: - Interaction
    
    func handleGuesture(guestureReg:UIPanGestureRecognizer) {
        var velocity = guestureReg.velocity(in: self.view)
        
        if velocity.x > 0 {
            
        }else {
            
        }
        
        if velocity.y > 0
        {
            
        }else {
            
        }
        
    }
    
    @objc func handleTap(gestureRecognize: UITapGestureRecognizer) {
        // HIT TEST : REAL WORLD
        // Get Screen Centre
        let screenCentre : CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
        
        
        if let node : [SCNHitTestResult]  = sceneView.hitTest(screenCentre, options: nil), node.count > 0 {
            let n = node.last!.node as! Node
            print(n.values)
            
            self.performSegue(withIdentifier: "moreInfo", sender: n)
            return
        }

        
        let arHitTestResults : [ARHitTestResult] = sceneView.hitTest(screenCentre, types: [.featurePoint]) // Alternatively, we could use '.existingPlaneUsingExtent' for more grounded hit-test-points.
        
        if let closestResult = arHitTestResults.first {
            // Get Coordinates of HitTest
            let transform : matrix_float4x4 = closestResult.worldTransform
            let worldCoord : SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            
            // Create 3D Text
            var val:[String] = []
//            if latestPrediction.trimmingCharacters(in: .whitespaces) == "apple" {
//                val = ["Brennwert: 267kj/100ml  668kj/250ml", "Fatt: 3,5g/100ml 8,8g/250ml", "davon gesättigte Fettsâuren: 2,5g/100ml 5,8g/250ml", "Eiweiß: 3,3g/100ml 8,3g/250ml", "Salz: 0,13g/100ml 0,33g/250ml"]
            
            val = ["Brennwert: 267kj/100ml  668kj/250ml", "Fatt: 3,5g/100ml 8,8g/250ml", "Eiweiß: 3,3g/100ml 8,3g/250ml", "Salz: 0,13g/100ml 0,33g/250ml","Salz: 0,13g/100ml 0,33g/250ml","Salz: 0,13g/100ml 0,33g/250ml", "Salz: 0,13g/100ml 0,33g/250ml"]
//            }
            
            let node : SCNNode = Node(name: "" ,title: latestPrediction, values: val, loc: worldCoord)
            sceneView.scene.rootNode.addChildNode(node)
            node.position = worldCoord
            latestPrediction = ""
        }
        
    }
    
    @objc func dismissView(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .down {
            
        }
        UIView.animate(withDuration: 0.4) {
            
            //            if let theWindow = UIApplication.shared.keyWindow {
            //                infoView?.frame = CGRect(x:theWindow.frame.width - 15 , y: theWindow.frame.height - 15, width: 10 , height: 10)
            //            }
        }
    }
    
//    func createNewBubbleParentNode(_ text : String) -> SCNNode {
//        // Warning: Creating 3D Text is susceptible to crashing. To reduce chances of crashing; reduce number of polygons, letters, smoothness, etc.
//
//        // TEXT BILLBOARD CONSTRAINT
//        let billboardConstraint = SCNBillboardConstraint()
//        billboardConstraint.freeAxes = SCNBillboardAxis.Y
//
//        // BUBBLE-TEXT
//
//        let bubble = SCNText(string: text, extrusionDepth: CGFloat(bubbleDepth))
//        var font = UIFont(name: "Futura", size: 0.15)
//        font = font?.withTraits(traits: .traitBold)
//        bubble.font = font
//        bubble.alignmentMode = kCAAlignmentCenter
//        bubble.firstMaterial?.diffuse.contents = UIColor.orange
//        bubble.firstMaterial?.specular.contents = UIColor.white
//        bubble.firstMaterial?.isDoubleSided = true
//        bubble.flatness = 1 // setting this too low can cause crashes.
//        bubble.chamferRadius = CGFloat(bubbleDepth)
//
//        // BUBBLE NODE
//        let (minBound, maxBound) = bubble.boundingBox
//        let bubbleNode = SCNNode(geometry: bubble)
//        // Centre Node - to Centre-Bottom point
//        bubbleNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
//        // Reduce default text size
//        bubbleNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
//
//        // CENTRE POINT NODE
//        let sphere = SCNSphere(radius: 0.005)
//        sphere.firstMaterial?.diffuse.contents = UIColor.cyan
//        let sphereNode = SCNNode(geometry: sphere)
//
//        // BUBBLE PARENT NODE
//        let bubbleNodeParent = SCNNode()
//        bubbleNodeParent.addChildNode(bubbleNode)
//        bubbleNodeParent.addChildNode(sphereNode)
//        bubbleNodeParent.constraints = [billboardConstraint]
//
//        return bubbleNodeParent
//    }
    
    // MARK: - CoreML Vision Handling
    
    func loopCoreMLUpdate() {
        // Continuously run CoreML whenever it's ready. (Preventing 'hiccups' in Frame Rate)
        
        dispatchQueueML.async {
            // 1. Run Update.
            self.updateCoreML()
            
            // 2. Loop this function.
            self.loopCoreMLUpdate()
        }
        
    }
    
    func classificationCompleteHandler(request: VNRequest, error: Error?) {
        // Catch Errors
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let observations = request.results else {
            print("No results")
            return
        }
        
        // Get Classifications
        let classifications = observations[0...1] // top 2 results
            .compactMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier) \(String(format:"- %.2f", $0.confidence))" })
            .joined(separator: "\n")
        
        
        DispatchQueue.main.async {
            // Print Classifications
            print(classifications)
            print("--")
            
            // Display Debug Text on screen
            var debugText:String = ""
            debugText += classifications
            self.debugTextView.text = debugText
            
            // Store the latest prediction
            var objectName:String = "…"
            objectName = classifications.components(separatedBy: "-")[0]
            objectName = objectName.components(separatedBy: ",")[0]
            self.latestPrediction = objectName
            
        }
    }
    
    func updateCoreML() {
        ///////////////////////////
        // Get Camera Image as RGB
        
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        var ciImage = CIImage(cvPixelBuffer: pixbuff!)


        // Note: Not entirely sure if the ciImage is being interpreted as RGB, but for now it works with the Inception model.
        // Note2: Also uncertain if the pixelBuffer should be rotated before handing off to Vision (VNImageRequestHandler) - regardless, for now, it still works well with the Inception model.
        
        ///////////////////////////
        // Prepare CoreML/Vision Request
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
//         let imageRequestHandler = VNImageRequestHandler(cgImage: cgimage, orientation: self.supportedInterfaceOrientations, options: [:]) // Alternatively; we can convert the above to an RGB CGImage and use that. Also UIInterfaceOrientation can inform orientation values.
        
        self.image = UIImage(ciImage: ciImage).image(withRotation: CGFloat(Double.pi/2))
        ///////////////////////////
        // Run Image Request
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let navi = (segue.destination as! AppNavController).topViewController as! ModalViewController
        
        navi.node = sender as! Node
        
        self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: segue.destination)
        
        segue.destination.modalPresentationStyle = .custom
        segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate
    }
}

extension UIFont {
    // Based on: https://stackoverflow.com/questions/4713236/how-do-i-set-bold-and-italic-on-uilabel-of-iphone-ipad
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
}

extension UIImage {
    func image(withRotation radians: CGFloat) -> UIImage {
        guard let cgImage = self.cgImage else {
            return UIImage()
        }
        let LARGEST_SIZE = CGFloat(max(self.size.width, self.size.height))
        let context = CGContext.init(data: nil, width:Int(LARGEST_SIZE), height:Int(LARGEST_SIZE), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)!
        
        var drawRect = CGRect.zero
        drawRect.size = self.size
        let drawOrigin = CGPoint(x: (LARGEST_SIZE - self.size.width) * 0.5,y: (LARGEST_SIZE - self.size.height) * 0.5)
        drawRect.origin = drawOrigin
        var tf = CGAffineTransform.identity
        tf = tf.translatedBy(x: LARGEST_SIZE * 0.5, y: LARGEST_SIZE * 0.5)
        tf = tf.rotated(by: CGFloat(radians))
        tf = tf.translatedBy(x: LARGEST_SIZE * -0.5, y: LARGEST_SIZE * -0.5)
        context.concatenate(tf)
        context.draw(cgImage, in: drawRect)
        var rotatedImage = context.makeImage()!
        
        drawRect = drawRect.applying(tf)
        
        rotatedImage = rotatedImage.cropping(to: drawRect)!
        let resultImage = UIImage(cgImage: rotatedImage)
        return resultImage
    }
    
    
}
