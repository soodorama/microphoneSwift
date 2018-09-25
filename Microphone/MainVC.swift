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
    var session: AVAudioSession?
    var recorder: AVAudioRecorder?
    
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
        
        session = AVAudioSession.sharedInstance()
        
        do {
//            try session?.setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            try session?.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session?.setActive(true)
            
            session?.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        self.loadFailUI()
                    }
                }
            }
            
            globalPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadRecordingUI() {
        print("LETS RECORD")
    }
    
    func loadFailUI() {
        print("FAIL")
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func getAudioURL() -> URL {
//        print(getDocumentsDirectory())
        return getDocumentsDirectory().appendingPathComponent("audio.m4a")
    }
    

    @IBAction func playPressed(_ sender: UIButton) {
        if !isPlaying {
            let url = MainVC.getAudioURL()
        
            do {
                globalPlayer = try AVAudioPlayer(contentsOf: url)
                globalPlayer?.play()
                playButton.setTitle("Pause", for: .normal)
                playButton.backgroundColor = pauseColor
                stopButton.backgroundColor = stopColor
                isPlaying = true
            } catch {
                let ac = UIAlertController(title: "Playback failed", message: "There was a problem", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
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
        performSegue(withIdentifier: "MicSegue", sender: sender)
//        if recorder == nil {
//            startRecording()
//        } else {
//            finishRecording(success: true)
//        }
    }
    
    
    
}

extension MainVC: AVAudioRecorderDelegate {
    func startRecording() {
        // 1
        recordButton.backgroundColor = UIColor(red: 153/255, green: 0/255, blue: 0/255, alpha: 1)
        
        // 2
        recordButton.backgroundColor = .red
        
        // 3
        let audioURL =  MainVC.getAudioURL()
        print(audioURL.absoluteString)
        
        // 4
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            // 5
            recorder = try AVAudioRecorder(url: audioURL, settings: settings)
            recorder?.delegate = self
            recorder?.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        recordButton.backgroundColor = UIColor(red: 0/255, green: 153/255, blue: 0/255, alpha: 1)
        
        recorder?.stop()
        recorder = nil
        
        if success {
            recordButton.backgroundColor = .green
//            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
        } else {
            recordButton.backgroundColor = .brown
            
            let ac = UIAlertController(title: "Record failed", message: "There was a problem recording your whistle; please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}


