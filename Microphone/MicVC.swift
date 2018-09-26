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
    
    @IBOutlet weak var switchButton: UIButton!
    
    var isSwitched = false
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        print("Audio data recieved")
    }
    
    @IBAction func stopPressed(_ sender: UIButton) {
        print("stop?")
        captureSession.stopRunning()
    }
    
    @IBAction func switchPressed(_ sender: UIButton) {
        if !isSwitched {
            switchButton.setBackgroundImage(UIImage(named: "resize_green_switch"), for: .normal)
            isSwitched = true
            
            do {
                try captureDevice?.lockForConfiguration()
                audioInput = try AVCaptureDeviceInput(device: captureDevice!)
                captureDevice?.unlockForConfiguration()
                audioOutput = AVCaptureAudioDataOutput()
                audioOutput?.setSampleBufferDelegate(self, queue: queue)
                //            audioOutput?.audioSettings = settings
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
            else {
                switchButton.setBackgroundImage(UIImage(named: "resize_red_switch"), for: .normal)
                isSwitched = false
                
                print("stop")
            }
        }
    }
}
