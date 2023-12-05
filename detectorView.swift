//
//  detectorView.swift
//  InSight
//
//
//

/*
 
/*
This module is to set up the camera for object detection.
'detectorView' for real-time camera-based object detection. It
utilizes AVFoundation for camera access, Vision for object
detection, and Core ML with the YOLOv3Int8LUT model. The code sets 
up a capture session, handles permissions, and configures the UI for
live camera preview. Further down you there is another detector
class that can be used in the event that one of the implementation
are not working correctly.
*/

 
 
import UIKit
import SwiftUI
import AVFoundation
import Vision


//Pairs with detectorViewExt
 
class detectorView: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var permissionGranted = false // Flag for permission
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect! = nil // For view dimensions
    
    // Detector
    private var videoOutput = AVCaptureVideoDataOutput()
    var requests = [VNRequest]()
    var detectionLayer: CALayer! = nil
    
      
    override func viewDidLoad() {
        checkPermission()
        
        sessionQueue.async { [unowned self] in
            guard permissionGranted else { return }
            self.setupCaptureSession()
            
            self.setupLayers()
            self.setupDetector()
            
            self.captureSession.startRunning()
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        screenRect = UIScreen.main.bounds
        self.previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)

        switch UIDevice.current.orientation {
            // Home button on top
            case UIDeviceOrientation.portraitUpsideDown:
                self.previewLayer.connection?.videoOrientation = .portraitUpsideDown
             
            // Home button on right
            case UIDeviceOrientation.landscapeLeft:
                self.previewLayer.connection?.videoOrientation = .landscapeRight
            
            // Home button on left
            case UIDeviceOrientation.landscapeRight:
                self.previewLayer.connection?.videoOrientation = .landscapeLeft
             
            // Home button at bottom
            case UIDeviceOrientation.portrait:
                self.previewLayer.connection?.videoOrientation = .portrait
                
            default:
                break
            }
        
        // Detector
        updateLayers()
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            // Permission has been granted before
            case .authorized:
                permissionGranted = true
                
            // Permission has not been requested yet
            case .notDetermined:
                requestPermission()
                    
            default:
                permissionGranted = false
            }
    }
    
    func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
            self.sessionQueue.resume()
        }
    }
    
    func setupCaptureSession() {
        // Camera input
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera,for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
           
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
                         
        // Preview layer
        screenRect = UIScreen.main.bounds
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // Fill screen
        previewLayer.connection?.videoOrientation = .portrait
        
        // Detector
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        
        // Updates to UI must be on main queue
        DispatchQueue.main.async { [weak self] in
            self!.view.layer.addSublayer(self!.previewLayer)
        }
    }
}

struct HostedViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return detectorView()
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
}
*/





import UIKit
import AVKit
import Vision




class detectorView: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let identifierLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let speechSynthesizer = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //initializing and setting up camera
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(preview)
        
        preview.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        //VNImageRequestHandler(cgImage: <#T##CGImage#>, options: [:]).perform(<#T##requests: [VNRequest]##[VNRequest]#>)
        
        setupIdentifierConfidenceLabel()

    }
    
    fileprivate func setupIdentifierConfidenceLabel(){
        view.addSubview(identifierLabel)
        identifierLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        identifierLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        identifierLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        identifierLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //print("Camera has captured a frame", Data())
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: YOLOv3TinyInt8LUT(configuration: MLModelConfiguration()).model) else { return }
        
        _ = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        let request = VNCoreMLRequest(model: model) { [weak self] (finishedReq, err) in
            
            guard let results =  finishedReq.results as? [VNRecognizedObjectObservation] else { return }
            
            // Find the closest object
            let closestObject = results.min { a, b in
                a.boundingBox.width * a.boundingBox.height < b.boundingBox.width * b.boundingBox.height
        }
        //guard let model = try? VNCoreMLModel(for: Resnet50(configuration: MLModelConfiguration()).model) else { return }
        
        //guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
    
                
            guard let object = closestObject else { return }
                
                // Assuming firstObs is an object with properties identifier and confidence
                
                //print(firstObs.identifier, firstObs.confidence)
                
                //let obj = firstObs.identifier
                //let conf = String(firstObs.confidence)

            DispatchQueue.main.async {
                let text = "\(object.labels.first?.identifier ?? "") \(object.labels.first?.confidence ?? 0 * 100)"
                self?.identifierLabel.text = text
                    
                let say = AVSpeechUtterance(string: text)
                self?.speechSynthesizer.speak(say)
                    //self.identifierLabel.text = "\(firstObs.identifier) \(firstObs.confidence * 100)"
            }
                
                //UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: NSLocalizedString(obj, comment: conf))
                
                //UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, NSLocalizedString(obj, comment: conf))
        }
        
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }

}

