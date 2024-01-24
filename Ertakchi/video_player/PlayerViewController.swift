//
//  PlayerViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 10/01/24.
//

import UIKit
import SceneKit
import CoreMotion
import SpriteKit
import AVFoundation
import Foundation
import Darwin
import CoreGraphics

// ViewController
class PlayerViewController: UIViewController, SCNSceneRendererDelegate, UIGestureRecognizerDelegate {
    
    // Voice commands
    
    var currentState: Command = .none
    
    var actions = [String]()
    
    var audioData: NSMutableData!
    
    var isFinishedPlaying = false
    
    let SAMPLE_RATE = 16000
    
    var leftSceneView = SCNView()
    var rightSceneView = SCNView()
        
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(playPausePlayer), for: .touchUpInside)
        return button
    }()
    
    lazy var playerSlideBar: UISlider = {
        let player = UISlider()

        // Set the minimum and maximum track colors
        player.minimumTrackTintColor = UIColor.red
        player.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.5)

        // Set the thumb color
        player.thumbTintColor = UIColor.red
        
        // Customize thumb image
        let thumbImage = UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
        
        player.setThumbImage(thumbImage, for: .normal)
        
        if let normalThumbImage = thumbImage {
             let highlightedThumbImage = resizeImage(normalThumbImage, targetSize: CGSize(width: normalThumbImage.size.width * 1.35, height: normalThumbImage.size.height * 1.35))
             player.setThumbImage(highlightedThumbImage, for: .highlighted)
         }
        player.addTarget(self, action: #selector(sliderChangeProgression), for: .valueChanged)
        player.addTarget(self, action: #selector(sliderStartSliding), for: .touchDown)
        player.addTarget(self, action: #selector(sliderEndSliding), for: .touchUpInside)
//              player.addTarget(self, action: #selector(sliderEndSliding), for: .touchUpOutside)
        return player
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .right
        label.text = "0:00 / 0:00"
        return label
    }()
    
    lazy var cardboardButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(activateCardboardView), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
//    @IBOutlet weak var heightSceneConstraint        : NSLayoutConstraint!
//    @IBOutlet weak var widthSceneConstraint         : NSLayoutConstraint!
    
    lazy var orientationButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backToCenter), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
//        checkMicPermission()
//        startAudio()
    }
    
    var scenes                                      : [SCNScene]!
    
    var videosNode                                  : [SCNNode]!
    var videosSpriteKitNode                         : [SKVideoNode]!
    
    var camerasNode                                 : [SCNNode]!
    var camerasRollNode                             : [SCNNode]!
    var camerasPitchNode                            : [SCNNode]!
    var camerasYawNode                              : [SCNNode]!
    
    var recognizer                                  : UITapGestureRecognizer?
    var panRecognizer                               : UIPanGestureRecognizer?
    var motionManager                               : CMMotionManager?
    
    var player                                      : AVPlayer!
    
    var currentAngleX                               : Float!
    var currentAngleY                               : Float!
    
    var oldY                                        : Float!
    var oldX                                        : Float!
    
    var progressObserver                            : AnyObject?
    
    var playingVideo                                : Bool = false
    var activateStereoscopicVideo                   : Bool = false
    var hiddenButton                                : Bool = false
    var cardboardViewOn                             : Bool = true
    
#if arch(arm64)
    var PROCESSOR_64BITS                            : Bool = true
#else
    var PROCESSOR_64BITS                            : Bool = false
#endif
    
//MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        AudioController.sharedInstance.delegate = self
        // Assuming you have initialized leftSceneView and rightSceneView elsewhere in your code
        view.addSubview(leftSceneView)
        view.addSubview(rightSceneView)
        
        leftSceneView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY)
        }

        rightSceneView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp.centerY)
        }

        // Assuming you have initialized playButton, playerSlideBar, and cardboardButton elsewhere in your code
        view.addSubview(playButton)
        view.addSubview(playerSlideBar)
        view.addSubview(cardboardButton)

        playButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalTo(playerSlideBar)
            make.width.height.equalTo(40)
        }

        playerSlideBar.snp.makeConstraints { (make) in
            make.leading.equalTo(playButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        view.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(playerSlideBar.snp.top).offset(0)
            make.right.equalToSuperview().offset(-20)
        }

        cardboardButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
 
        leftSceneView.backgroundColor              = UIColor.black
        rightSceneView.backgroundColor             = UIColor.black
        
        leftSceneView.delegate                      = self
        rightSceneView.delegate                     = self
        
        let camX                                    = 0.0 as Float
        let camY                                    = 0.0 as Float
        let camZ                                    = 0.0 as Float
        let zFar                                    = 50.0
        
        let leftCamera                              = SCNCamera()
        let rightCamera                             = SCNCamera()
        
        leftCamera.zFar                             = zFar
        rightCamera.zFar                            = zFar
        
        let leftCameraNode                          = SCNNode()
        leftCameraNode.camera                       = leftCamera
        
        let rightCameraNode                         = SCNNode()
        rightCameraNode.camera                      = rightCamera
        
        let scene1                                  = SCNScene()
        
        let cameraNodeLeft                          = SCNNode()
        let cameraRollNodeLeft                      = SCNNode()
        let cameraPitchNodeLeft                     = SCNNode()
        let cameraYawNodeLeft                       = SCNNode()
        
        cameraNodeLeft.addChildNode(leftCameraNode)
        cameraNodeLeft.addChildNode(rightCameraNode)
        cameraRollNodeLeft.addChildNode(cameraNodeLeft)
        cameraPitchNodeLeft.addChildNode(cameraRollNodeLeft)
        cameraYawNodeLeft.addChildNode(cameraPitchNodeLeft)
        
        leftSceneView.scene                         = scene1
        
        if true == activateStereoscopicVideo {
            let scene2                              = SCNScene()
            let cameraNodeRight                     = SCNNode()
            let cameraRollNodeRight                 = SCNNode()
            let cameraPitchNodeRight                = SCNNode()
            let cameraYawNodeRight                  = SCNNode()
    
            scenes                                  = [scene1, scene2]
            camerasNode                             = [cameraNodeLeft, cameraNodeRight]
            camerasRollNode                         = [cameraRollNodeLeft, cameraRollNodeRight]
            camerasPitchNode                        = [cameraPitchNodeLeft, cameraPitchNodeRight]
            camerasYawNode                          = [cameraYawNodeLeft, cameraYawNodeRight]
            
            rightSceneView.scene                   = scene2
            leftCamera.xFov                         = 80
            rightCamera.xFov                        = 80
            leftCamera.yFov                         = 80
            rightCamera.yFov                        = 80
            
            cameraNodeRight.addChildNode(rightCameraNode)
            cameraRollNodeRight.addChildNode(cameraNodeRight)
            cameraPitchNodeRight.addChildNode(cameraRollNodeRight)
            cameraYawNodeRight.addChildNode(cameraPitchNodeRight)
        } else {
            scenes                                  = [scene1]
            camerasNode                             = [cameraNodeLeft]
            camerasRollNode                         = [cameraRollNodeLeft]
            camerasPitchNode                        = [cameraPitchNodeLeft]
            camerasYawNode                          = [cameraYawNodeLeft]
            rightSceneView.scene                   = scene1
        }
        
        leftCameraNode.position                     = SCNVector3(x: camX - ((true == activateStereoscopicVideo) ? 0.0 : 0.5), y: camY, z: camZ)
        rightCameraNode.position                    = SCNVector3(x: camX + ((true == activateStereoscopicVideo) ? 0.0 : 0.5), y: camY, z: camZ)
        
        let camerasNodeAngles                       = getCamerasNodeAngle()
        
        for cameraNode in camerasNode {
            cameraNode.position                     = SCNVector3(x: camX, y:camY, z:camZ)
            cameraNode.eulerAngles                  = SCNVector3Make(Float(camerasNodeAngles[0]), Float(camerasNodeAngles[1]), Float(camerasNodeAngles[2]))
        }
        
        if scenes.count == camerasYawNode.count {
            for i in 0 ..< scenes.count {
                let scene                           = scenes[i]
                let cameraYawNode                   = camerasYawNode[i]
                
                scene.rootNode.addChildNode(cameraYawNode)
            }
        }
        
        leftSceneView.pointOfView                  = leftCameraNode
        rightSceneView.pointOfView                 = rightCameraNode
        
        leftSceneView.isPlaying                      = true
        rightSceneView.isPlaying                     = true
        
        // Respond to user head movement. Refreshes the position of the camera 60 times per second.
        motionManager                               = CMMotionManager()
        motionManager?.deviceMotionUpdateInterval   = 1.0 / 60.0
        motionManager?.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryZVertical)
        
        // Add gestures on screen
        recognizer                                  = UITapGestureRecognizer(target: self, action:#selector(PlayerViewController.tapTheScreen))
        recognizer!.delegate                        = self
        view.addGestureRecognizer(recognizer!)
        
//        if !cardboardViewOn {
//            panRecognizer                               = UIPanGestureRecognizer(target: self, action: #selector(PlayerViewController.panGesture(_:)))
//            panRecognizer?.delegate                     = self
//            view.addGestureRecognizer(panRecognizer!)
//        }
       
        //Initialize position variable (for the panGesture)
        currentAngleX                               = 0
        currentAngleY                               = 0
        
        oldX                                        = 0
        oldY                                        = 0
        
        //Launch the player
        play()
    }

//MARK: Camera Orientation
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        let camerasNodeAngles                       = getCamerasNodeAngle()
        
//        widthSceneConstraint?.isActive                = (.portrait != toInterfaceOrientation && .portraitUpsideDown != toInterfaceOrientation)
//        heightSceneConstraint?.isActive               = (.portrait == toInterfaceOrientation || .portraitUpsideDown == toInterfaceOrientation)
        
        for cameraNode in camerasNode {
            cameraNode.eulerAngles                  = SCNVector3Make(Float(camerasNodeAngles[0]), Float(camerasNodeAngles[1]), Float(camerasNodeAngles[2]))
        }
    }
    
    func getCamerasNodeAngle() -> [Double] {
        
        var camerasNodeAngle1: Double!              = 0.0
        var camerasNodeAngle2: Double!              = 0.0
        
        let orientation = UIApplication.shared.statusBarOrientation.rawValue
        
        if orientation == 1 {
            camerasNodeAngle1                       = -M_PI_2
        } else if orientation == 2 {
            camerasNodeAngle1                       = M_PI_2
        } else if orientation == 3 {
            camerasNodeAngle1                       = 0.0
            camerasNodeAngle2                       = M_PI
        }
        
        return [-M_PI_2, camerasNodeAngle1, camerasNodeAngle2]
    }
    
    @objc func backToCenter(){
        currentAngleX = 0
        currentAngleY = 0
        
    }
    
    var videoXXX = "https://storage.googleapis.com/videosforbookfly/demo-video.mp4"
    
//MARK: Video Player
    func play(){
        self.showLoadingViewVideo()
        
        let fileURL: NSURL? = NSURL(string: videoXXX)
        
//        let fileURL: URL? = URL(fileURLWithPath: Bundle.main.path(forResource: "demo-video", ofType: "mp4")!)

        if (fileURL != nil){
            
            var screenScale : CGFloat                                       = 1.0
            if PROCESSOR_64BITS {
                screenScale                                                 = CGFloat(3.0)
            }
            
            player                                                          = AVPlayer(url: fileURL! as URL)
            player.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
            let videoSpriteKitNodeLeft                                      = SKVideoNode(avPlayer: player)
            let videoNodeLeft                                               = SCNNode()
            let spriteKitScene1                                             = SKScene(size: CGSize(width: 1280 * screenScale, height: 1280 * screenScale))
            spriteKitScene1.shouldRasterize                                 = true
            var spriteKitScenes                                             = [spriteKitScene1]
            
            videoNodeLeft.geometry                                          = SCNSphere(radius: 30)
            spriteKitScene1.scaleMode                                       = .aspectFit
            videoSpriteKitNodeLeft.position                                 = CGPoint(x: spriteKitScene1.size.width / 2.0, y: spriteKitScene1.size.height / 2.0)
            videoSpriteKitNodeLeft.size                                     = spriteKitScene1.size
            
            if true == activateStereoscopicVideo {
                let videoSpriteKitNodeRight                                 = SKVideoNode(avPlayer: player)
                let videoNodeRight                                          = SCNNode()
                let spriteKitScene2                                         = SKScene(size: CGSize(width: 1280 * screenScale, height: 1280 * screenScale))
                spriteKitScene2.shouldRasterize                             = true
                
                videosSpriteKitNode                                         = [videoSpriteKitNodeLeft, videoSpriteKitNodeRight]
                videosNode                                                  = [videoNodeLeft, videoNodeRight]
                spriteKitScenes                                             = [spriteKitScene1, spriteKitScene2]
                
                videoNodeRight.geometry                                     = SCNSphere(radius: 30)
                spriteKitScene2.scaleMode                                   = .aspectFit
                videoSpriteKitNodeRight.position                            = CGPoint(x: spriteKitScene1.size.width / 2.0, y: spriteKitScene1.size.height / 2.0)
                videoSpriteKitNodeRight.size                                = spriteKitScene2.size
                
                let mask                                                    = SKShapeNode(rect: CGRect(x: 0, y: 0, width: spriteKitScene1.size.width, height: spriteKitScene1.size.width / 2.0))
                mask.fillColor                                              = SKColor.black
                
                let cropNode                                                = SKCropNode()
                cropNode.maskNode                                           = mask
                
                cropNode.addChild(videoSpriteKitNodeLeft)
                cropNode.yScale                                             = 2
                cropNode.position                                           = CGPoint(x: 0, y: 0)
                
                let mask2                                                   = SKShapeNode(rect: CGRect(x: 0, y: spriteKitScene1.size.width / 2.0, width: spriteKitScene1.size.width, height: spriteKitScene1.size.width / 2.0))
                mask2.fillColor                                             = SKColor.black
                let cropNode2                                               = SKCropNode()
                cropNode2.maskNode                                          = mask2
                
                cropNode2.addChild(videoSpriteKitNodeRight)
                cropNode2.yScale                                            = 2
                cropNode2.position                                          = CGPoint(x: 0, y: -spriteKitScene1.size.width)
                
                spriteKitScene1.addChild(cropNode2)
                spriteKitScene2.addChild(cropNode)
                
            } else {
                videosSpriteKitNode                                         = [videoSpriteKitNodeLeft]
                videosNode                                                  = [videoNodeLeft]
                
                spriteKitScene1.addChild(videoSpriteKitNodeLeft)
            }
            
            if videosNode.count == spriteKitScenes.count && scenes.count == videosNode.count {
                for i in 0 ..< videosNode.count {
                    weak var spriteKitScene                                         = spriteKitScenes[i]
                    let videoNode                                                   = videosNode[i]
                    let scene                                                       = scenes[i]
                    
                    videoNode.geometry?.firstMaterial?.diffuse.contents             = spriteKitScene
                    videoNode.geometry?.firstMaterial?.isDoubleSided                  = true
                    
                    // Flip video upside down, so that it's shown in the right position
                    var transform                                                   = SCNMatrix4MakeRotation(Float(M_PI), 0.0, 0.0, 1.0)
                    transform                                                       = SCNMatrix4Translate(transform, 1.0, 1.0, 0.0)
                    
                    videoNode.pivot                                                 = SCNMatrix4MakeRotation(Float(M_PI_2), 0.0, -1.0, 0.0)
                    videoNode.geometry?.firstMaterial?.diffuse.contentsTransform    = transform
                    
                    videoNode.position                                              = SCNVector3(x: 0, y: 0, z: 0)
                    videoNode.position                                              = SCNVector3(x: 0, y: 0, z: 0)
                    
                    scene.rootNode.addChildNode(videoNode)
                }
            }
            
            progressObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.1, preferredTimescale: Int32(NSEC_PER_SEC)),
                                                                         queue: nil,
                                                                    using: { [unowned self] (time) -> Void in
                                                                                    self.updateSliderProgression()
                                                                                }
                                                                        ) as AnyObject?
            playingVideo = false
            playPausePlayer()
        }
    }
    
    @objc func playPausePlayer() {
        if isFinishedPlaying {
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            isFinishedPlaying = false
            replayVideo()
        } else {
            for videoSpriteKitNode in videosSpriteKitNode {
                if true == playingVideo {
                    videoSpriteKitNode.pause()
                    playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                } else {
                    playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                    videoSpriteKitNode.play()
                }
            }
            
            playingVideo = !playingVideo
        }
      
    }
    
//MARK: Touch Methods
    @objc func tapTheScreen(){
        
        if (hiddenButton){
            playButton.isHidden                                               = false
            playerSlideBar.isHidden                                           = false
            cardboardButton.isHidden                                          = false
            orientationButton.isHidden                                        = false
            backButton.isHidden = false
            timeLabel.isHidden = false
        }else {
            playButton.isHidden                                               = true
            playerSlideBar.isHidden                                           = true
            cardboardButton.isHidden                                          = true
            orientationButton.isHidden                                        = true
            backButton.isHidden = true
            timeLabel.isHidden = true
        }
        hiddenButton                                                        = !hiddenButton
    }
    
    @objc func replayVideo() {
        player.seek(to: CMTime.zero)
        player.play()
    }
    
    @objc func panGesture(_ sender: UIPanGestureRecognizer){
        
        let translation                                                     = sender.translation(in: sender.view!)
        let protection : Float                                              = 2.0
        
        if (abs(Float(translation.x) - oldX) >= protection){
            let newAngleX                                                   = Float(translation.x) - oldX - protection
            currentAngleX                                                   = newAngleX/100 + currentAngleX
            oldX                                                            = Float(translation.x)
        }
        
        if (abs(Float(translation.y) - oldY) >= protection){
            let newAngleY                                                   = Float(translation.y) - oldY - protection
            currentAngleY                                                   = newAngleY/100 + currentAngleY
            oldY                                                            = Float(translation.y)
        }
        
        if(sender.state == UIGestureRecognizer.State.ended) {
            oldX                                                            = 0
            oldY                                                            = 0
        }
    }
    
    
//MARK: Render the scene
    func renderer(_ aRenderer: SCNSceneRenderer, updateAtTime time: TimeInterval){
        
        // Render the scene
        DispatchQueue.main.async { [weak self] () -> Void in
            if let strongSelf = self {
                if let mm = strongSelf.motionManager, let motion = mm.deviceMotion {
                    let currentAttitude                                     = motion.attitude
                    
                    var roll : Double                                       = currentAttitude.roll
                    
                    if(UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeRight) {
                        roll                                                = -1.0 * (-M_PI - roll)
                    }
                    
                    for cameraRollNode in strongSelf.camerasRollNode {
                        cameraRollNode.eulerAngles.x                        = Float(roll) - strongSelf.currentAngleY
                    }
                    
                    for cameraPitchNode in strongSelf.camerasPitchNode {
                        cameraPitchNode.eulerAngles.z                       = Float(currentAttitude.pitch)
                    }
                    
                    for cameraYawNode in strongSelf.camerasYawNode {
                        cameraYawNode.eulerAngles.y                         = Float(currentAttitude.yaw) + strongSelf.currentAngleX
                    }
                }
            }
        }
    }
    
//MARK: Slider
    fileprivate func updateSliderProgression() {
        
        let playerDuration = self.playerItemDuration()
        
        
        if CMTIME_IS_INVALID(playerDuration) {
            playerSlideBar.minimumValue                                     = 0.0
            return
        }
        
        let duration = Float(CMTimeGetSeconds(playerDuration))
        if duration.isFinite && (duration > 0) {
            let minValue                                                    = playerSlideBar.minimumValue
            let maxValue                                                    = playerSlideBar.maximumValue
            let time                                                        = Float(CMTimeGetSeconds(player.currentTime()))
            
            playerSlideBar.value                                            = (maxValue - minValue) * time / duration + minValue
            

            let currentTimeString = formattedTimeString(from: TimeInterval(time))
            let durationString = formattedTimeString(from: TimeInterval(duration))
            timeLabel.text = "\(currentTimeString) / \(durationString)"
            if currentTimeString == durationString {
                playButton.setImage(UIImage(systemName: "arrow.circlepath"), for: .normal)
                isFinishedPlaying = true
            }
        }
    }
    
    func formattedTimeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%2d:%02d", minutes, seconds)
    }
    
    fileprivate func playerItemDuration() -> CMTime {
        
        let thePlayerItem                                                   = player.currentItem
        
        if AVPlayerItem.Status.readyToPlay == thePlayerItem?.status {
            return thePlayerItem?.duration ?? CMTime.invalid
        }
        
        return CMTime.invalid
        
    }
    
    @objc func sliderChangeProgression(_ sender: UISlider) {
        
        let playerDuration = self.playerItemDuration()
        
        if CMTIME_IS_INVALID(playerDuration) {
            return;
        }
        
        let duration = Float(CMTimeGetSeconds(playerDuration))
        if duration.isFinite && (duration > 0) {
            player.seek(to: CMTimeMakeWithSeconds(Float64(duration) * Float64(playerSlideBar.value), preferredTimescale: 60000))
        }
        
    }

     @objc func sliderEndSliding() {
         animateThumbSizeChange()
         // Provide haptic feedback when the slider ends sliding
         let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
         impactFeedbackGenerator.prepare()
         impactFeedbackGenerator.impactOccurred()
         
         playingVideo = true
         playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
         player.play()
     }
    
    @objc func sliderStartSliding(_ sender: AnyObject) {
        animateThumbSizeChange()
        
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
        
        for videoSpriteKitNode in videosSpriteKitNode {
            videoSpriteKitNode.pause()
        }
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
//        playingVideo = false
    }
    
    @objc func activateCardboardView() {
        cardboardViewOn = !cardboardViewOn
        displayIfNeededCardboardView()
        if cardboardViewOn {
//            view.gestureRecognizers?.removeAll()
//            recognizer                                  = UITapGestureRecognizer(target: self, action:#selector(PlayerViewController.tapTheScreen))
//            recognizer!.delegate                        = self
//            view.addGestureRecognizer(recognizer!)
        } else {
//            panRecognizer                               = UIPanGestureRecognizer(target: self, action: #selector(PlayerViewController.panGesture(_:)))
//            panRecognizer?.delegate                     = self
//            view.addGestureRecognizer(panRecognizer!)
            
//            recognizer                                  = UITapGestureRecognizer(target: self, action:#selector(PlayerViewController.tapTheScreen))
//            recognizer!.delegate                        = self
//            view.addGestureRecognizer(recognizer!)
        }
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func displayIfNeededCardboardView() {
        
        let width = (view.bounds.width > view.bounds.height) ? view.bounds.width : view.bounds.height;
        
//        widthSceneConstraint?.constant                          = (true == cardboardViewOn) ? (width / 2.0) : 1
//        heightSceneConstraint?.constant                         = (true == cardboardViewOn) ? (width / 2.0) : 1
        if cardboardViewOn {
            rightSceneView.snp.updateConstraints { (make) in
                make.bottom.leading.trailing.equalToSuperview()
                make.top.equalTo(view.snp.centerY)
            }
        } else {
            rightSceneView.snp.updateConstraints { (make) in
                make.bottom.leading.trailing.equalToSuperview()
                make.top.equalTo(view.snp.centerY).offset(-width / 2.0)
            }
        }
        leftSceneView.isHidden                                    = (false == cardboardViewOn)
        cardboardButton.setImage(UIImage(named: (true == cardboardViewOn) ? "cardboardOn" : "cardboardOff"), for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        displayIfNeededCardboardView()
    }
    
//MARK: Clean perf
    deinit {
        
        motionManager?.stopDeviceMotionUpdates()
        motionManager = nil
        
        if let observer = progressObserver {
            player.removeTimeObserver(observer)
        }
        
        playingVideo = false
        
        for videoSKNode in videosSpriteKitNode {
            videoSKNode.removeFromParent()
        }
        
        for scene in scenes {
            for node in scene.rootNode.childNodes {
                removeNode(node)
            }
        }
        player.removeObserver(self, forKeyPath: "status")
    }
    
    func removeNode(_ node : SCNNode) {
        
        for node in node.childNodes {
            removeNode(node)
        }
        
        if 0 == node.childNodes.count {
            node.removeFromParentNode()
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}

func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size

    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height

    let newSize: CGSize
    if widthRatio > heightRatio {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }

    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage ?? UIImage()
}

extension PlayerViewController {
    func animateThumbSizeChange() {
        UIView.animate(withDuration: 0.2) {
            self.playerSlideBar.layoutIfNeeded()
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
           if keyPath == "status" {
               if player.status == .readyToPlay {
                   self.dissmissLoadingViewVideo()
               }
               else if player.status == .failed {
                   // Handle error
                   print("Error: \(player.error?.localizedDescription ?? "Unknown error")")
               }
           }
       }
    
}
