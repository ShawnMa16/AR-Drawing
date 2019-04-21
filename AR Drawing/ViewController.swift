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
    
    var typeString: String? {
        didSet {
            if let type = typeString {
                typeLabel.text = type
                infoLabel.text = "This is a \(type)"
                Service.fadeViewInThenOut(view: infoLabel, delay: 0.1)
            }
        }
    }
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 25)
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
        typeLabel.textAlignment = .center
        
        view.addSubview(clearButton)
        clearButton .snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(80)
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(100)
        }
        
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { (make) in
            make.width.equalTo(180)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(triangleButton.snp.top).offset(-30)
        }
        infoLabel.textAlignment = .center
        infoLabel.alpha = 0
        
    }
    
    fileprivate func setupGesture() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.minimumPressDuration = 0
        tap.cancelsTouchesInView = false
        tap.delegate = self
        self.arView.addGestureRecognizer(tap)
    }
    
    fileprivate func setupButtons() {
        circleButton.addTarget(self, action: #selector(switchType), for: .touchUpInside)
        triangleButton.addTarget(self, action: #selector(switchType), for: .touchUpInside)
        lineButton.addTarget(self, action: #selector(switchType), for: .touchUpInside)
        testButton.addTarget(self, action: #selector(testButtonDown), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setupGesture()
        
        setupButtons()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        let sphere = SCNNode()
        sphere.geometry = SCNSphere(radius: 0.0025)
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        
        guard let startPoint = self.startPoint else {return}
        let position = Service.to2D(startPoint: startPoint, inView: self.arView)
        
        self.addPoint(pointPos: position)
        
        Service.addNode(sphere, toNode: self.scene.rootNode, inView: self.arView, cameraRelativePosition: self.cameraRelativePosition)
        
    }
    
    private func addPoint(pointPos: (x: Float, y: Float)) {
        let point = Point(x: pointPos.x, y: pointPos.y, strokeID: self.strokeIDCount)
        guard !point.x.isNaN, !point.y.isNaN else {return}
        
        if !self.testingMode {
            self.templatePoints[self.templatePoints.count - 1].append(point)
        } else {
            self.testingPoints.append(point)
        }
    }
    
    @objc
    func clear() {
//        DispatchQueue.main.async {
//            self.scene.rootNode.childNodes.forEach { (node) in
//                node.removeFromParentNode()
//            }
//        }
        
//        let path = Service.testPath
//        let circle = Circle(path: path)
//        Service.addNode(circle, toNode: self.scene.rootNode, inView: self.arView, cameraRelativePosition: self.cameraRelativePosition)
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
        log.info(startPoint)
    }
    @objc
    func screenTouchUp() {
        screenDown = false
        startPoint = nil

        if testingMode {
            let shape = Shape(points: self.testingPoints, name: "test")
            guard let shapes = testingShape else {return}
            let type = QPointCloudRecognizer.classify(inputShape: shape, templateSet: shapes)
            self.typeString = type
            
            Service.get3DShapeNode(forShape: shape)
            
            self.testingPoints = []
        } else {
            let latestPoints = templatePoints.filter({$0.count != 0}).last
            let latestShape = Shape(points: latestPoints!, name: self.currentType)
            if testingShape == nil {
                testingShape = []
            }
            
            
            testingShape?.append(latestShape)
            strokeIDCount += 1
            guard let shapes = testingShape else {return}
            let type = QPointCloudRecognizer.classify(inputShape: latestShape, templateSet: shapes)
            let count = shapes.filter({$0.name == type}).count - 1
            infoLabel.text = "\(type):\(count) added"
            Service.fadeViewInThenOut(view: infoLabel, delay: 0.1)
            log.debug(type)
            
            if let node = Service.get3DShapeNode(forShape: latestShape) {
                Service.addNode(node, toNode: self.scene.rootNode, inView: self.arView, cameraRelativePosition: self.cameraRelativePosition)
            }

        }
    }
}
