//
//  MicVC.swift
//  Microphone
//
//  Created by Neil Sood on 9/25/18.
//  Copyright © 2018 Neil Sood. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class MicVC: UIViewController {
    
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var onButton: UIButton!
    
    let onColor = UIColor(red: 142/255, green: 17/255, blue: 7/255, alpha: 1.0)
    
    var isOn = false
    var url_counter = 0
    var globalPlayer: AVAudioPlayer?
    var recorder: AVAudioRecorder?
    var session: AVAudioSession?
    var audioQueue: AQ<String> = AQ<String>()
    var recordTimer = Timer()
    var playTimer = Timer()
    let delay = 1.0
    
    let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        onButton.backgroundColor = .orange
        offButton.backgroundColor = .gray
        onButton.layer.cornerRadius = 10
        offButton.layer.cornerRadius = 10
        
        session = AVAudioSession.sharedInstance()

        do {
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
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        print("View Did Load")
    }
    
    @IBAction func onPressed(_ sender: UIButton) {
        if !isOn {
            print("On")
            isOn = true
            onButton.backgroundColor = .white
            offButton.backgroundColor = onColor
            recordTimer = Timer.scheduledTimer(timeInterval: self.delay, target: self, selector: #selector(self.recordAudio), userInfo: nil, repeats: true)
            playTimer = Timer.scheduledTimer(timeInterval: self.delay, target: self, selector: #selector(self.playAudio), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func offPressed(_ sender: UIButton) {
        if isOn {
            print("Off")
            isOn = false
            
            onButton.backgroundColor = .orange
            offButton.backgroundColor = .gray
            
            recordTimer.invalidate()
            playTimer.invalidate()
            
            finishRecording(success: true)
//            globalPlayer?.stop()
        }
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
    
    class func getAudioURL(urlStr: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(urlStr)
    }
}


extension MicVC: AVAudioRecorderDelegate {
    @objc func playAudio() {
        print("Play")
        
        
    }
    
    @objc func recordAudio() {
        print("Record")
        
        if let rec = recorder {
            recorder!.stop()
        }
        
        let urlStr = String(self.url_counter)
        let audioURL = MicVC.getAudioURL(urlStr: urlStr+".m4a")
//        print(audioURL.absoluteString)
        
        
        self.audioQueue.enqueue(urlStr)
        self.url_counter += 1
        audioQueue.show()
        do {
            print(urlStr)
            self.recorder = try AVAudioRecorder(url: audioURL, settings: settings)
            self.recorder?.delegate = self
            self.recorder?.prepareToRecord()
            self.recorder?.record()
        } catch {
            self.isOn = false
            self.finishRecording(success: false)
        }
        
    }
    
    func finishRecording(success: Bool) {
        recorder?.stop()
        recorder = nil
        url_counter = 0
        
        if success {
            print("Finished Recording")
        } else {
            let ac = UIAlertController(title: "Record failed", message: "There was a problem recording your audio; please try again.", preferredStyle: .alert)
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



class AQNode<T> {
    var val : T
    var next : AQNode? = nil
    init(_ val: T) {
        self.val = val
    }
}

class AQ<T> {
    var head: AQNode<T>? = nil
    var tail: AQNode<T>? = nil
    
    func enqueue(_ val: T) -> Self {
        let node = AQNode<T>(val)
        if head == nil {
            head = node
            tail = node
        }
        else {
            tail?.next = node
            tail = tail?.next
        }
        return self
    }
    
    func dequeue() -> T? {
        if head == nil {
            return nil
        }
        else if head === tail {
            let val = head?.val
            head = nil
            tail = nil
            return val
        }
        else {
            let val = head?.val
            head = head?.next
            return val
        }
    }
    
    func show() -> Self {
        var str = "Head -> "
        var cur = head
        while (cur != nil) {
            if cur === tail {
                str += "tail:\(cur?.val) -> "
            }
            else {
                str += "\(cur?.val) -> "
            }
            cur = cur?.next
        }
        str += "nil"
        print(str)
        return self
    }
}
