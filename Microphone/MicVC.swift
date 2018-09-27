//
//  MicVC.swift
//  Microphone
//
//  Created by Neil Sood on 9/25/18.
//  Copyright © 2018 Neil Sood. All rights reserved.
//

import UIKit
import AVFoundation

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

class MicVC: UIViewController {
    
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var onButton: UIButton!
    
    let onColor = UIColor(red: 142/255, green: 17/255, blue: 7/255, alpha: 1.0)
    
    var isPlaying = false
//    var urlStr = ""
    var globalPlayer: AVAudioPlayer?
    var recorder: AVAudioRecorder?
    var session: AVAudioSession?
    var audioQueue: AQ<String>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        onButton.backgroundColor = .orange
        offButton.backgroundColor = .gray
        onButton.layer.cornerRadius = 10
        offButton.layer.cornerRadius = 10
        
//        guard let url = Bundle.main.url(forResource: urlStr, withExtension: "mp3") else {
//            print("URL not found")
//            return
//        }
//
//        session = AVAudioSession.sharedInstance()
//
//        do {
//            try session?.setCategory(AVAudioSessionCategoryPlayAndRecord)
//            try session?.setActive(true)
//
//            session?.requestRecordPermission() { [unowned self] allowed in
//                DispatchQueue.main.async {
//                    if allowed {
//                        self.loadRecordingUI()
//                    } else {
//                        self.loadFailUI()
//                    }
//                }
//            }
//
//            globalPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
        
        print("Loaded")
    }
    
    @IBAction func onPressed(_ sender: UIButton) {
        onButton.backgroundColor = .white
        offButton.backgroundColor = onColor
        print("On")
        isPlaying = true
        startRecording()
        
    }
    
    @IBAction func offPressed(_ sender: UIButton) {
        onButton.backgroundColor = .orange
        offButton.backgroundColor = .gray
        print("Off")
        finishRecording(success: true)
        isPlaying = false
        globalPlayer?.stop()
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
        //        print(getDocumentsDirectory())
        return getDocumentsDirectory().appendingPathComponent(urlStr)
    }
}


extension MicVC: AVAudioRecorderDelegate {
    func startRecording() {
        var name = 0
        
        while isPlaying {
            let audioURL = MicVC.getAudioURL(urlStr: String(name))
            print(audioURL.absoluteString)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioQueue?.enqueue(String(name))
            name += 1
            
            do {
                recorder = try AVAudioRecorder(url: audioURL, settings: settings)
                recorder?.delegate = self
                recorder?.record(forDuration: 1)
            } catch {
                isPlaying = false
                finishRecording(success: false)
            }
            
            let url = MicVC.getAudioURL(urlStr: (audioQueue?.dequeue())!)
            
            do {
                globalPlayer = try AVAudioPlayer(contentsOf: url)
                globalPlayer?.play()
                print("playing?")
            } catch {
                let ac = UIAlertController(title: "Playback failed", message: "There was a problem", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
        
    }
    
    func finishRecording(success: Bool) {
        isPlaying = false
        recorder?.stop()
        recorder = nil
        
        if success {
            print("COOL")
        } else {
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
