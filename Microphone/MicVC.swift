//
//  MicVC.swift
//  Microphone
//
//  Created by Neil Sood on 9/25/18.
//  Copyright © 2018 Neil Sood. All rights reserved.
//

import UIKit
import AVFoundation

class MicVC: UIViewController, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var onButton: UIButton!
    
//    var isSwitched = false
    let onColor = UIColor(red: 142/255, green: 17/255, blue: 7/255, alpha: 1.0)
    
    
    let settings = [
        AVFormatIDKey: kAudioFormatMPEG4AAC,
        AVNumberOfChannelsKey : 1,
        AVSampleRateKey : 44100]
    let captureSession = AVCaptureSession()
    
    let queue = DispatchQueue(label: "AudioSessionQueue", attributes: [])
    let captureDevice = AVCaptureDevice.default(for: AVMediaType.audio)
    var audioInput : AVCaptureDeviceInput? = nil
    var audioOutput : AVCaptureAudioDataOutput? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onButton.backgroundColor = .orange
        offButton.backgroundColor = .gray
        
        onButton.layer.cornerRadius = 10
        offButton.layer.cornerRadius = 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        output.connection(with: AVMediaType(rawValue: AVAudioSessionPortBuiltInSpeaker))
        
        print("Audio data received")
        
//        audioOutput = output as? AVCaptureAudioDataOutput
//        audioOutput?.connection(with: .audio)
       
    }
    
    @IBAction func stopPressed(_ sender: UIButton) {
        onButton.backgroundColor = .orange
        offButton.backgroundColor = .gray
        
        captureSession.stopRunning()
        print("stop")
    }
    
    @IBAction func onPressed(_ sender: UIButton) {
        
        onButton.backgroundColor = .white
        offButton.backgroundColor = onColor
    
        
        do {
            try captureDevice?.lockForConfiguration()
            audioInput = try AVCaptureDeviceInput(device: captureDevice!)
            captureDevice?.unlockForConfiguration()
            print(captureDevice!)
            audioOutput = AVCaptureAudioDataOutput()
            audioOutput?.setSampleBufferDelegate(self, queue: queue)
//                audioOutput?.audioSettings = settings
        } catch {
            print("Capture devices could not be set")
            print(error.localizedDescription)
        }
        
        if audioInput != nil && audioOutput != nil {
            captureSession.beginConfiguration()
            if (captureSession.canAddInput(audioInput!)) {
                captureSession.addInput(audioInput!)
            } else {
                print("cannot add input")
            }
            if (captureSession.canAddOutput(audioOutput!)) {
                captureSession.addOutput(audioOutput!)
            } else {
                print("cannot add output")
            }
            captureSession.commitConfiguration()
            
            print("Starting capture session")
            captureSession.startRunning()
        }
    }
}
