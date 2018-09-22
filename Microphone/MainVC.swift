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
    
    
    @IBOutlet weak var mainButton: UIButton!
    
    var isPlaying = false
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        mainButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        if mainButton.titleLabel?.text == "Play" {
            self.playSound()
        }
        else {
            self.stopSound()
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Toto_Africa", withExtension: "mp3") else {
            print("URL not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            let player = try AVAudioPlayer(contentsOf: url)
            
            print("before play",player.isPlaying)
            
            player.play()
            
            print("play pressed")
            print("after play",player.isPlaying)
            mainButton.setTitle("Stop", for: .normal)
            mainButton.backgroundColor = UIColor(red: 154/255, green: 2/255, blue: 7/255, alpha: 1.0)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        print("before stop",player?.isPlaying)
        player?.stop()
        print("stop pressed")
        print("after stop", player?.isPlaying)
        mainButton.setTitle("Play", for: .normal)
        mainButton.backgroundColor = UIColor(red: 0/255, green: 143/255, blue: 36/255, alpha: 1.0)
    }
    
}

