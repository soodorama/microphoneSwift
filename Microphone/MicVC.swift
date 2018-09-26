//
//  MicVC.swift
//  Microphone
//
//  Created by Neil Sood on 9/25/18.
//  Copyright © 2018 Neil Sood. All rights reserved.
//

import UIKit
import AVFoundation

class MicVC: UIViewController {
    
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var onButton: UIButton!
    
    let onColor = UIColor(red: 142/255, green: 17/255, blue: 7/255, alpha: 1.0)
    
    var audioSession: AVAudioSession?
    var iphoneInput: AVAudioSessionPortDescription = AVAudioSession.sharedInstance().availableInputs?[0] as! AVAudioSessionPortDescription

    
    override func viewDidLoad() {
        super.viewDidLoad()
        onButton.backgroundColor = .orange
        offButton.backgroundColor = .gray
        onButton.layer.cornerRadius = 10
        offButton.layer.cornerRadius = 10
        
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try audioSession?.setActive(true)
            
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    @IBAction func onPressed(_ sender: UIButton) {
        onButton.backgroundColor = .white
        offButton.backgroundColor = onColor
        print("On")
        
        do {
//            try audioSession?.overrideOutputAudioPort(.speaker)
            try audioSession?.setPreferredIOBufferDuration(0.005)
            try audioSession?.setPreferredInput(iphoneInput)
            print(audioSession?.preferredInput)
        } catch {
            print("Error overriding speaker")
        }
        
    }
    
    @IBAction func offPressed(_ sender: UIButton) {
        onButton.backgroundColor = .orange
        offButton.backgroundColor = .gray
        print("Off")
    }
    
}
