//
//  ViewController.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/7/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SnapKit

class ViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate {

    private var arView: ARSCNView = {
        let view = ARSCNView()
        return view
    }()
    
    private var scene: SCNScene {
        get {
            return arView.scene
        }
    }
    
    private var buttonDown: Bool = false
    
    let cameraRelativePosition = SCNVector3(0,0,-0.1)
    
    var strokeIDCount: Int = 0
    
    var testingPoints: [[Point]] = [[]]
    var testingShape: [Shape] = []
    
    fileprivate func setupViews() {
        // Set the view's delegate
        arView.delegate = self
        
        // Show statistics such as fps and timing information
        arView.showsStatistics = true
        arView.autoenablesDefaultLighting = true
        
        view.addSubview(arView)
        arView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func setupGesture() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.minimumPressDuration = 0
        tap.cancelsTouchesInView = false
        tap.delegate = self
        self.arView.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        arView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        arView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

extension ViewController {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if buttonDown {
            addSphere()
        }
    }
}

extension ViewController {
    
    func addSphere() {
        DispatchQueue.main.async {
            let sphere = SCNNode()
            sphere.geometry = SCNSphere(radius: 0.0025)
            //        print(sphere.simdWorldPosition)
            sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            
            guard let currentFrame = self.arView.session.currentFrame else { return }
            let camera = currentFrame.camera
            let transform = camera.transform
            var translationMatrix = matrix_identity_float4x4
            translationMatrix.columns.3.x = self.cameraRelativePosition.x
            translationMatrix.columns.3.y = self.cameraRelativePosition.y
            translationMatrix.columns.3.z = self.cameraRelativePosition.z
            let modifiedMatrix = simd_mul(transform, translationMatrix)
            sphere.simdTransform = modifiedMatrix
            let location = self.arView.projectPoint(sphere.position)
            if (sphere.position - self.cameraRelativePosition).length() > 0.005 {
                print(location)
                print(sphere.position.to2D(cameraPos: self.cameraRelativePosition))
                let position = sphere.position.to2D(cameraPos: self.cameraRelativePosition)
                let point = Point(x: position.x, y: position.y, strokeID: self.strokeIDCount)
                
                self.testingPoints[self.testingPoints.count - 1].append(point)
                
                self.scene.rootNode.addChildNode(sphere)
            }

        }
    }
    
    // called by gesture recognizer
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
        
        // handle touch down and touch up events separately
        if gesture.state == .began {
            // do something...
            buttonTouchDown()
        } else if gesture.state == .ended { // optional for touch up event catching
            // do something else...
            buttonTouchUp()
        }
    }
    
    @objc func buttonTouchDown() {
        buttonDown = true
        testingPoints.append([])
    }
    @objc func buttonTouchUp() {
        buttonDown = false
        print(testingPoints)
        let shapes = testingPoints.filter({$0.count != 0}).map { (points) -> Shape in
            return Shape(points: points, name: "circle")
        }
        
//        print(shapes)
        strokeIDCount += 1
        
        print(QPointCloudRecognizer.classify(inputShape: shapes.last!, templateSet: shapes))
    }
}
