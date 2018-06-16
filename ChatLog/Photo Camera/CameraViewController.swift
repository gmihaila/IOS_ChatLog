//
//  CameraViewController.swift
//  PhotoCamera
//
//  Created by George Mihaila on 5/27/18.
//  Copyright © 2018 George Mihaila. All rights reserved.
//

import UIKit
import AVKit

class CameraViewController: UIViewController {
    
    var messages = [Message]()
    var show_progress: Bool?
    
    var captureSesion = AVCaptureSession()
    var backCamera:AVCaptureDevice?
    var frontCamera:AVCaptureDevice?
    var currentCamera:AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // BUTTON SEND
        let sendButton = UIImageView()
        sendButton.isUserInteractionEnabled = true
        sendButton.image = UIImage(named: "snap_photo")
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSend)))
        view.addSubview(sendButton)
        //x y z
        sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        setupCaptureSesion()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSesion()
    }
    
    func setupCaptureSesion(){
        captureSesion.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice(){
        let deviceDiscoverySesion = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySesion.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back{
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }
    
    func setupInputOutput(){
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSesion.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSesion.addOutput(photoOutput!)
        } catch{
            print(error)
        }
    }
    
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSesion)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSesion(){
        captureSesion.startRunning()
    }
    
     @objc func handleSend(){
        let setting = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: setting, delegate: self)
    }
}

extension  CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            image = UIImage(data: imageData)
            let previewViewController = PreviewViewController()
            previewViewController.show_progress = self.show_progress
            previewViewController.image = image
            previewViewController.messages = self.messages
            present(previewViewController, animated: true, completion: nil)
            
        }
    }
}
