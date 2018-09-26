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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onButton.backgroundColor = .orange
        offButton.backgroundColor = .gray
        onButton.layer.cornerRadius = 10
        offButton.layer.cornerRadius = 10
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        print("Inputs",audioSession.availableInputs)
        print("input datasource",audioSession.inputDataSource)
        print("output datasource",audioSession.outputDataSource)
        
    }
    
    @IBAction func onPressed(_ sender: UIButton) {
        onButton.backgroundColor = .white
        offButton.backgroundColor = onColor
        print("On")
    }
    
    @IBAction func offPressed(_ sender: UIButton) {
        onButton.backgroundColor = .orange
        offButton.backgroundColor = .gray
        print("Off")
    }
    
}
