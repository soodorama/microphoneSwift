//
//  MainVC.swift
//  Microphone
//
//  Created by Neil Sood on 9/21/18.
//  Copyright © 2018 Neil Sood. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController {
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    
    var isPlaying = false
    var name = "TakeMeHome_JD"
    var globalPlayer: AVAudioPlayer?
    
    let playColor = UIColor(red: 0/255, green: 143/255, blue: 36/255, alpha: 1.0)
    let pauseColor = UIColor(red: 248/255, green: 149/255, blue: 18/255, alpha: 1.0)
    let stopColor = UIColor(red: 142/255, green: 17/255, blue: 7/255, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.layer.cornerRadius = 10
        stopButton.layer.cornerRadius = 10
        recordButton.layer.cornerRadius = 10
        
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("URL not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            globalPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func playPressed(_ sender: UIButton) {
        if !isPlaying {
            globalPlayer?.play()
            playButton.setTitle("Pause", for: .normal)
            playButton.backgroundColor = pauseColor
            stopButton.backgroundColor = stopColor
            isPlaying = true
        }
        else {
            globalPlayer?.pause()
            playButton.setTitle("Resume", for: .normal)
            playButton.backgroundColor = playColor
            isPlaying = false
        }
    }
    
    @IBAction func stopPressed(_ sender: UIButton) {
        stopButton.backgroundColor = .gray
        globalPlayer?.stop()
        globalPlayer?.currentTime = 0
        playButton.setTitle("Play", for: .normal)
        playButton.backgroundColor = playColor
        isPlaying = false
    }
    
    @IBAction func recordPressed(_ sender: UIButton) {
        print("country roadssss take me homeeee")
    }
    
    
    
}

