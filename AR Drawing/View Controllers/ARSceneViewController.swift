//
//  ARSceneViewController.swift
//  AR Drawing
//
//  Created by Shawn Ma on 4/7/19.
//  Copyright © 2019 Shawn Ma. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import SnapKit
import ARVideoKit

class ARSceneViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate {
    
    // recorder for screen recording
    var recorder: RecordAR?

    var arView: ARSCNView = {
        let view = ARSCNView()
        return view
    }()
    
    var scene: SCNScene {
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
    
    private let rectangleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Rectangle", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    private let halfCircle: UIButton = {
        let button = UIButton()
        button.setTitle("HalfCircle", for: .normal)
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
                Service.shared.fadeViewInThenOut(view: infoLabel, delay: 0.1)
            }
        }
    }
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    let clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    var screenDown: Bool = false
    
    let cameraRelativePosition = Constants.shared.cameraRelativePosition
    
    var strokeIDCount: Int = 0
    
    var currentType: ShapeType = .circle
    var templatePoints: [[Point]] = [[]]
    var templateShapes: [Shape]?
    
    var testingPoints: [Point] = []
    
    let penNode: SCNNode = {
        let sphere = SCNNode()
        sphere.name = "pointerNode"
        sphere.geometry = SCNSphere(radius: 0.0015)
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.4)
        return sphere
    }()
    
    var isRecording: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.isRecording {
                    self.recordButton.setImage(UIImage(named: "stop"), for: .normal)
                } else {
                    self.recordButton.setImage(UIImage(named: "record"), for: .normal)
                }
            }
        }
    }
    private let recordButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let developmentView: UIView = {
        let view = UIView()
        return view
    }()
    
    // Be careful with the threshold
    // This threshold should be related to numbers of sample points for shapes
    let pointsDistanceThreshold: CGFloat = 0.003
    
    var testingMode: Bool = false
    let releaseMode = Constants.shared.releaseMode
    
    var startNode: SCNNode?
    
    var interestNodePositions = [Int: [SCNVector3]]()
    
    fileprivate func setupARViewAndRecorder() {
        // Set the view's delegate
        arView.delegate = self
        
        // Show statistics such as fps and timing information
        arView.showsStatistics = true
        arView.autoenablesDefaultLighting = true
        arView.debugOptions = [.showWorldOrigin]
        
        
        // Performance 
        if let camera = arView.pointOfView?.camera {
            camera.wantsHDR = false
            camera.wantsExposureAdaptation = false
            camera.exposureOffset = -1
            camera.minimumExposure = -1
        }
        
        //MARK:-  Add Pointer to camera
        let pointer = penNode
        pointer.scale = SCNVector3(1.2, 1.2, 1.2)
        pointer.position = Constants.shared.cameraRelativePosition
        arView.pointOfView?.addChildNode(pointer)
        
        //MARK:- Initiate SCNTechnique
        if let path = Bundle.main.path(forResource: "NodeTechnique", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path)  {
                let dict2 = dict as! [String : AnyObject]
                let technique = SCNTechnique(dictionary:dict2)
                self.arView.technique = technique
            }
        }
        
        //MARK:- Setup screen recorder
        recorder = RecordAR(ARSceneKit: arView)
    }
    
    fileprivate func setupViews() {
        setupARViewAndRecorder()
        
        view.addSubview(arView)
        arView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(recordButton)
        recordButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.view.safeAreaInsets.top).offset(50)
        }
        recordButton.tintColor = UIColor.white.withAlphaComponent(0.8)
        recordButton.setImage(UIImage(named: "record"), for: .normal)
        recordButton.contentVerticalAlignment = .fill
        recordButton.contentHorizontalAlignment = .fill
        recordButton.imageEdgeInsets = Constants.shared.buttonInsets
        
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(self.view.safeAreaInsets.top).offset(50)
        }
        infoButton.tintColor = UIColor.white.withAlphaComponent(0.8)
        infoButton.setImage(UIImage(named: "information"), for: .normal)
        infoButton.contentVerticalAlignment = .fill
        infoButton.contentHorizontalAlignment = .fill
        infoButton.imageEdgeInsets = Constants.shared.buttonInsets
        
        // if is not in releaseMode, initiate all components to developmentView
        if !releaseMode {
            
            view.addSubview(developmentView)
            developmentView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            developmentView.addSubview(circleButton)
            circleButton.snp.makeConstraints { (make) in
                make.height.equalTo(50)
                make.width.equalTo(80)
                make.left.equalToSuperview().offset(30)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            }
            
            developmentView.addSubview(triangleButton)
            triangleButton.snp.makeConstraints { (make) in
                make.height.equalTo(50)
                make.width.equalTo(80)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            }
            
            developmentView.addSubview(halfCircle)
            halfCircle.snp.makeConstraints { (make) in
                make.height.equalTo(50)
                make.width.equalTo(80)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(self.triangleButton.snp.bottom).offset(-30)
            }
            
            developmentView.addSubview(lineButton)
            lineButton.snp.makeConstraints { (make) in
                make.height.equalTo(50)
                make.width.equalTo(80)
                make.right.equalToSuperview().offset(-30)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-30)
            }
            
            developmentView.addSubview(rectangleButton)
            rectangleButton.snp.makeConstraints { (make) in
                make.height.equalTo(50)
                make.width.equalTo(80)
                make.right.equalToSuperview().offset(-30)
                make.bottom.equalTo(lineButton.snp.top).offset(-30)
            }
            
            developmentView.addSubview(testButton)
            testButton.snp.makeConstraints { (make) in
                make.height.equalTo(50)
                make.width.equalTo(80)
                make.left.equalToSuperview().offset(30)
                make.top.equalToSuperview().offset(100)
            }
            
            developmentView.addSubview(typeLabel)
            typeLabel.snp.makeConstraints { (make) in
                make.height.equalTo(50)
                make.width.equalTo(80)
                make.left.equalToSuperview().offset(30)
                make.top.equalTo(testButton.snp.bottom).offset(20)
            }
            typeLabel.textAlignment = .center
            
            developmentView.addSubview(clearButton)
            clearButton.snp.makeConstraints { (make) in
                make.height.equalTo(50)
                make.width.equalTo(80)
                make.right.equalToSuperview().offset(-30)
                make.top.equalToSuperview().offset(100)
            }
            
            developmentView.addSubview(infoLabel)
            infoLabel.snp.makeConstraints { (make) in
                make.width.equalTo(180)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(triangleButton.snp.top).offset(-30)
            }
            infoLabel.textAlignment = .center
            infoLabel.alpha = 0
        }
    }
    
    fileprivate func setupGesture() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.minimumPressDuration = 0.2
        tap.delaysTouchesBegan = true
        tap.delegate = self
        self.arView.addGestureRecognizer(tap)
    }
    
    fileprivate func setupButtons() {
        circleButton.addTarget(self, action: #selector(switchType), for: .touchUpInside)
        triangleButton.addTarget(self, action: #selector(switchType), for: .touchUpInside)
        halfCircle.addTarget(self, action: #selector(switchType), for: .touchUpInside)
        lineButton.addTarget(self, action: #selector(switchType), for: .touchUpInside)
        rectangleButton.addTarget(self, action: #selector(switchType), for: .touchUpInside)
        
        testButton.addTarget(self, action: #selector(testButtonDown), for: .touchUpInside)
        
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        
        recordButton.addTarget(self, action: #selector(switchRecording), for: .touchUpInside)
        
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setupGesture()
        
        setupButtons()
        
        if releaseMode {
            setRelease()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        arView.session.run(configuration)
        
        recorder?.prepare(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        arView.session.pause()
        
        recorder?.rest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }


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

//MARK:- switch mode here
extension ARSceneViewController {
    func classify() {
        testingMode = !testingMode
        self.currentType = .test
        testButton.setTitle(testingMode ? "Testing" : "Classify", for: .normal)
        
        if testingMode {
            if let shapes = Service.shared.readFile(type: [Shape].self) {
                self.templateShapes = shapes
            }
        }
    }
    
    // Set the App to release mode
    // - Include: Disable AR debugging, recrive template shapes from .plist file
    func setRelease() {
        testingMode = true
        self.currentType = .test
        
        if let shapes = Service.shared.readFileFromBundle(name: Constants.shared.jsonFileName, type: [Shape].self) {
            self.templateShapes = shapes
        }
        
        // reset AR debugOptions
        arView.showsStatistics = false
        arView.autoenablesDefaultLighting = true
        arView.debugOptions = []
    }
    
    // Clear all nodes
    // Remove all Shapes from scene
    @objc
    func clear() {
        DispatchQueue.main.async {
            self.scene.rootNode.childNodes.forEach({$0.removeFromParentNode()})
        }
    }
    
    @objc
    func testButtonDown() {
        testingMode = !testingMode
        self.currentType = .test
        testButton.setTitle(testingMode ? "Testing" : "Classify", for: .normal)
    }
    
    // Switch Shape type
    @objc
    func switchType(_ button: UIButton) {
        switch button.currentTitle {
        case "Circle":
            self.currentType = .circle
        case "Triangle":
            self.currentType = .triangle
        case "Line":
            self.currentType = .line
        case "Rectangle":
            self.currentType = .rectangle
        case "HalfCircle":
            self.currentType = .halfCircle
        default:
            break
        }
    }
    
    
    // Switch between record and stop recording
    @objc
    func switchRecording() {
        isRecording = !isRecording
        if isRecording {
            recorder?.record()
        } else {
            recorder?.stopAndExport({ [weak self] (_, _, success) in
                if success {
                    let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    DispatchQueue.main.async {
                        self?.present(alertController, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @objc
    func showInfo() {
        let infoView = InforViewController()
        infoView.modalPresentationStyle = .overFullScreen
        self.present(infoView, animated: true) {
            //
        }
    }
}
