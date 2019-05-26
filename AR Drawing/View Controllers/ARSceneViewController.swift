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
import JGProgressHUD

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
    
    private let recordButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let buttonBlur: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style:
            .light))
        blur.isUserInteractionEnabled = false //This allows touches to forward to the button.
        blur.clipsToBounds = true
        return blur
    }()
    
    private let secondButtonBlur: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style:
            .light))
        blur.isUserInteractionEnabled = false //This allows touches to forward to the button.
        blur.clipsToBounds = true
        return blur
    }()
    
    var isRecording: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.isRecording {
                    self.recordButton.setTitle("Stop", for: .normal)
                    self.recordButton.backgroundColor = UIColor.init(red: 1, green: 0, blue: 4/255, alpha: 0.4)
                    self.recordButton.setTitleColor(.white, for: .normal)
                    self.recordButton.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
                } else {
                    self.recordButton.setTitle("Record", for: .normal)
                    self.recordButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
                    self.recordButton.setTitleColor(.black, for: .normal)
                    self.recordButton.setTitleColor(UIColor.black.withAlphaComponent(0.3), for: .highlighted)
                }
            }
        }
    }
    
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
    
    /// The view controller that displays the status and "restart experience" UI.
    lazy var statusView: StatusView = {
        return StatusView()
    }()
    
    lazy var infoView: InfoView = {
        return InfoView()
    }()
    
    lazy var privacyView: InfoView = {
        return InfoView()
    }()
    
    lazy var fullScreenBlurView: BlurView = {
        return BlurView()
    }()
    
    lazy var hud = JGProgressHUD(style: .light)
    
    private var shouldDismissInfo: Bool = true
    private var dismissThreshold: CGFloat = 50
    
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
            make.width.equalTo(90)
            make.height.equalTo(49)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        recordButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        recordButton.setTitle("Record", for: .normal)
        recordButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        recordButton.setTitleColor(.black, for: .normal)
        recordButton.setTitleColor(UIColor.black.withAlphaComponent(0.3), for: .highlighted)
        recordButton.layer.cornerRadius = 8.0
        recordButton.contentHorizontalAlignment = .center
        
        recordButton.insertSubview(buttonBlur, at: 0)
        
        view.addSubview(infoButton)
        infoButton.snp.makeConstraints { (make) in
            make.width.equalTo(90)
            make.height.equalTo(49)
            make.left.equalToSuperview().offset(30)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        infoButton.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        infoButton.setTitle("About", for: .normal)
        infoButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        infoButton.setTitleColor(.black, for: .normal)
        infoButton.setTitleColor(UIColor.black.withAlphaComponent(0.3), for: .highlighted)
        infoButton.layer.cornerRadius = 8.0
        
        infoButton.insertSubview(secondButtonBlur, at: 0)
        
        
        self.view.addSubview(statusView)
        statusView.frame = self.view.bounds
        
        
        hud.textLabel.text = "Record video saved\n to Photos!"
        hud.detailTextLabel.text = nil
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonBlur.frame = recordButton.bounds
        secondButtonBlur.frame = infoButton.bounds
        
        buttonBlur.layer.cornerRadius = recordButton.layer.cornerRadius
        secondButtonBlur.layer.cornerRadius = infoButton.layer.cornerRadius
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func hideButton() {
        DispatchQueue.main.async {
            self.recordButton.isHidden = !self.recordButton.isHidden
            self.infoButton.isHidden = !self.infoButton.isHidden
            self.penNode.isHidden = !self.penNode.isHidden
        }
    }
    
    // Switch between record and stop recording
    @objc
    func switchRecording() {
        
        isRecording = !isRecording
        if isRecording {
            recorder?.record()
        } else {
            recorder?.stopAndExport({ [unowned self] (_, _, success) in
                if success {

                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                        self.hud.show(in: self.view)
                        self.hud.dismiss(afterDelay: 2.0)
                    }
                }
            })
        }
    }
    
    @objc
    func showInfo() {
        self.shouldDismissInfo = true
        self.view.addSubview(self.fullScreenBlurView)
        self.fullScreenBlurView.frame = self.view.bounds
        self.fullScreenBlurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissInfoView)))
        self.fullScreenBlurView.isActive = true
        self.fullScreenBlurView.alpha = 0
        
        self.view.addSubview(self.infoView)
        self.infoView.textViewDelegate = self
        
        self.infoView.closeViewHandler = { [unowned self] in
            self.dismissInfoView(nil)
        }
        
        self.infoView.snp.makeConstraints { (make) in
            
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                make.width.equalToSuperview().multipliedBy(0.92)
                make.centerX.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.4)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(self.view.frame.height*0.4 + 30)
                break
            case .pad:
                make.width.equalTo(320)
                make.height.equalTo(340)
                make.left.equalToSuperview().offset(24)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(370)
            default:
                break
            }
        }
        
        self.infoView.privacyViewHandler = { [unowned self] in
            self.showPrivacyView()
        }
        
        self.view.layoutIfNeeded()
        
        // animate info view to show
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.fullScreenBlurView.alpha = 1
            
            self.infoView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            })
            
            self.view.layoutIfNeeded()
            
        }) { (finished) in
            if finished {
                
            }
        }
    }
    
    @objc
    func dismissInfoView(_ button: UIButton?) {
        let duration = button == nil ? 0.2 : 0.25
        UIView.animate(withDuration: duration, animations: {
            self.fullScreenBlurView.alpha = 0
            
            self.infoView.snp.updateConstraints({ (make) in
                switch UIDevice.current.userInterfaceIdiom {
                case .phone:
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(self.view.frame.height*0.4 + 30)
                    break
                case .pad:
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(370)
                default:
                    break
                }
            })
            self.view.layoutIfNeeded()
        }) { (finished) in
            if finished {
                self.infoView.snp.removeConstraints()
                self.infoView.removeFromSuperview()
                
                self.fullScreenBlurView.removeFromSuperview()
            }
        }
    }
    
    
    @objc
    func showPrivacyView() {
        for recognizer in self.fullScreenBlurView.gestureRecognizers ?? [] {
            self.fullScreenBlurView.removeGestureRecognizer(recognizer)
        }
        self.fullScreenBlurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPrivacyView)))
        
        self.view.addSubview(privacyView)
        self.privacyView.textViewDelegate = self
        
        self.privacyView.closeViewHandler = { [unowned self] in
            self.dismissPrivacyView(nil)
        }
        
        self.privacyView.snp.makeConstraints { (make) in
            
            
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                make.width.equalToSuperview().multipliedBy(0.92)
                make.centerX.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.55)
                // set the view a little bit off the screen(30)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(self.view.frame.height*0.55 + 30)
                break
            case .pad:
                make.width.equalTo(320)
                make.height.equalTo(450)
                make.left.equalToSuperview().offset(24)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(480)
            default:
                break
            }
        }
        
        self.privacyView.setUpPrivacyView()
        
        self.view.layoutIfNeeded()
        
        // dismiss info view first
        UIView.animate(withDuration: 0.2, animations: {
            
            self.infoView.snp.updateConstraints({ (make) in
                switch UIDevice.current.userInterfaceIdiom {
                case .phone:
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(self.view.frame.height*0.4 + 30)
                    break
                case .pad:
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(370)
                default:
                    break
                }
            })
            self.view.layoutIfNeeded()
        }) { (finished) in
            // show privacy view
            if finished {
                self.infoView.snp.removeConstraints()
                self.infoView.removeFromSuperview()
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    
                    self.privacyView.snp.updateConstraints({ (make) in
                        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
                    })
                    
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc
    func dismissPrivacyView(_ button: UIButton?) {
        let duration = button == nil ? 0.2 : 0.25
        UIView.animate(withDuration: duration, animations: {
            self.fullScreenBlurView.alpha = 0
            
            self.privacyView.snp.updateConstraints({ (make) in
                switch UIDevice.current.userInterfaceIdiom {
                case .phone:
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(self.view.frame.height*0.55 + 30)
                    break
                case .pad:
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(480)
                default:
                    break
                }
            })
            self.view.layoutIfNeeded()
        }) { (finished) in
            if finished {
                self.privacyView.snp.removeConstraints()
                self.privacyView.removeFromSuperview()
                
                self.fullScreenBlurView.removeFromSuperview()
            }
        }
    }
    
}

//MARK: - functions for dimiss information view and privacy view
extension ARSceneViewController: UITextViewDelegate {
    
    func animateInforViewAndBlurView(offset: CGFloat, tag: Int) {
        
        let targetView = tag == Constants.shared.tagForInforView ? self.infoView : self.privacyView
        
        DispatchQueue.main.async {
            self.fullScreenBlurView.alpha = (self.dismissThreshold - offset/6) / self.dismissThreshold
            
            targetView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20 + offset)
            })
            self.view.layoutIfNeeded()
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold = -scrollView.contentOffset.y
        let tag = scrollView.tag
        
        if threshold >= 0, threshold < dismissThreshold - 1, shouldDismissInfo {
            animateInforViewAndBlurView(offset: threshold, tag: tag)
        }
        if threshold > dismissThreshold, shouldDismissInfo {
            shouldDismissInfo = false
            if tag == Constants.shared.tagForInforView {
                dismissInfoView(nil)
            } else {
                dismissPrivacyView(nil)
            }
        }
    }
}
