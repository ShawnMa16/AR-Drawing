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
    
    private let circleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Circle", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    private let triangleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Triangle", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    private let lineButton: UIButton = {
        let button = UIButton()
        button.setTitle("Line", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    private let testButton: UIButton = {
        let button = UIButton()
        button.setTitle("Classify", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    private var screenDown: Bool = false
    
    let cameraRelativePosition = Service.cameraRelativePosition
    
    var strokeIDCount: Int = 0
    
    var currentType = "circle"
    var templatePoints: [[Point]] = [[]]
    var testingShape: [Shape]?
    var testingPoints: [Point] = []
    
    var testingMode: Bool = false
    var startPoint: SCNVector3?
    
    fileprivate func setupViews() {
        // Set the view's delegate
        arView.delegate = self
        
        // Show statistics such as fps and timing information
        arView.showsStatistics = true
        arView.autoenablesDefaultLighting = true
        arView.debugOptions = [.showWorldOrigin]
        
        view.addSubview(arView)
        arView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(circleButton)
        circleButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(80)
            make.left.equalToSuperview().offset(30)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
        
        view.addSubview(triangleButton)
        triangleButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(80)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
        
        view.addSubview(lineButton)
        lineButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(80)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
        
        view.addSubview(testButton)
        testButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(80)
            make.left.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(100)
        }
        
        view.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(80)
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(testButton.snp.bottom).offset(20)
        }
        
        view.addSubview(clearButton)
        testButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(80)
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(100)
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
        
        circleButton.addTarget(self, action: #selector(switchType), for: .touchUpInside)
        triangleButton.addTarget(self, action: #selector(switchType), for: .touchUpInside)
        lineButton.addTarget(self, action: #selector(switchType), for: .touchUpInside)
        testButton.addTarget(self, action: #selector(testButtonDown), for: .touchUpInside)
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

    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        if screenDown {
            addSphere()
        }
    }
}

extension ViewController {
    
    func getPointerPosition() -> (pos : SCNVector3, valid: Bool, camPos : SCNVector3) {
        guard let camera = self.arView.session.currentFrame?.camera else {return (SCNVector3Zero, false, SCNVector3Zero)}
        guard let pointOfView = self.arView.pointOfView else { return (SCNVector3Zero, false, SCNVector3Zero) }
        
        let mat = SCNMatrix4.init(camera.transform)
        let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
        
        let currentPosition = pointOfView.position + cameraRelativePosition
        
        return (currentPosition, true, pointOfView.position)
    }
    
    func classify() {
        testingMode = !testingMode
        self.currentType = "test"
        testButton.setTitle(testingMode ? "Testing" : "Classify", for: .normal)
    }
    
    func showPointer() {
        let sphere = SCNNode()
        sphere.geometry = SCNSphere(radius: 0.001)
        sphere.name = "centerPosition"
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        Service.addNode(sphere, toNode: self.scene.rootNode, inView: self.arView, cameraRelativePosition: self.cameraRelativePosition)
    }
    
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

            let pointer = Service.getPointerPosition(inView: self.arView, cameraRelativePosition: self.cameraRelativePosition).pos
//            print((sphere.presentation.worldPosition - pointer).length())
            
//            Service.to2D(startPoint: self.startPoint!, inView: self.arView)
            
//            if (sphere.presentation.worldPosition - pointer).length() > 1.0 || self.testingPoints.count == 0 {
//                print(sphere.presentation)
            
//                sphere.presentation.worldPosition = pointer
                
                let position = Service.to2D(startPoint: self.startPoint!, inView: self.arView)
                
                let point = Point(x: position.x, y: position.y, strokeID: self.strokeIDCount)
                
                if !self.testingMode {
                    self.templatePoints[self.templatePoints.count - 1].append(point)
                } else {
                    self.testingPoints.append(point)
                }
                
                
                
                self.scene.rootNode.addChildNode(sphere)
//            }
        }
    }
    
    @objc
    func clear() {
        DispatchQueue.main.async {
            self.scene.rootNode.childNodes.forEach { (node) in
                node.removeFromParentNode()
            }
        }
        
        
    }
    
    @objc
    func testButtonDown() {
        testingMode = !testingMode
        self.currentType = "test"
        testButton.setTitle(testingMode ? "Testing" : "Classify", for: .normal)
    }
    
    @objc
    func switchType(_ button: UIButton) {
        switch button.currentTitle {
        case "Circle":
            self.currentType = "circle"
        case "Triangle":
            self.currentType = "triangle"
        case "Line":
            self.currentType = "line"
        default:
            break
        }
    }
    
    // called by gesture recognizer
    @objc
    func tapHandler(gesture: UITapGestureRecognizer) {
        
        // handle touch down and touch up events separately
        if gesture.state == .began {
            // do something...
            screenTouchDown()
        } else if gesture.state == .ended { // optional for touch up event catching
            // do something else...
            screenTouchUp()
        }
    }
    
    @objc
    func screenTouchDown() {
        screenDown = true
        templatePoints.append([])
        startPoint = Service.getPointerPosition(inView: self.arView, cameraRelativePosition: self.cameraRelativePosition).pos
    }
    @objc
    func screenTouchUp() {
        screenDown = false
        startPoint = nil
//        print(testingPoints)
//        let shapes = templatePoints.filter({$0.count != 0}).map { (points) -> Shape in
//            return Shape(points: points, name: self.currentType)
//        }
//
//        print(shapes)
        
        if testingMode {
            let shape = Shape(points: self.testingPoints, name: "test")
            guard let shapes = testingShape else {return}
            print(QPointCloudRecognizer.classify(inputShape: shape, templateSet: shapes))
            self.testingPoints = []
        } else {
            let latestPoints = templatePoints.filter({$0.count != 0}).last
            let latestShape = Shape(points: latestPoints!, name: self.currentType)
            if testingShape == nil {
                testingShape = []
            }
            testingShape?.append(latestShape)
            strokeIDCount += 1
            print(testingShape)
            guard let shapes = testingShape else {return}
            print(QPointCloudRecognizer.classify(inputShape: latestShape, templateSet: shapes))
        }
    }
}
