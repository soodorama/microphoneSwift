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
    
    var isPlaying = false
    var isOn = false
    var url_counter = 0
    var globalPlayer: AVAudioPlayer?
    var recorder: AVAudioRecorder?
    var session: AVAudioSession?
    var audioQueue: AQ<String> = AQ<String>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        onButton.backgroundColor = .orange
        offButton.backgroundColor = .gray
        onButton.layer.cornerRadius = 10
        offButton.layer.cornerRadius = 10
        
        print("Loaded")
    }
    
    @IBAction func onPressed(_ sender: UIButton) {
        if !isOn {
            onButton.backgroundColor = .white
            offButton.backgroundColor = onColor
            print("On")
            isPlaying = true
            isOn = true
            
            let queue = DispatchQueue(label: "RecordAndPlay", qos: .default, attributes: .concurrent)
            queue.async {
                self.startRecording()
            }
            queue.async {
                self.startPlaying()
            }
        }
    }
    
    @IBAction func offPressed(_ sender: UIButton) {
        onButton.backgroundColor = .orange
        offButton.backgroundColor = .gray
        print("Off")
        finishRecording(success: true)
        isPlaying = false
        globalPlayer?.stop()
        isOn = false
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
    func startPlaying() {
        while isOn {
            if let str = audioQueue.dequeue() {
                audioQueue.show()
                let url = MicVC.getAudioURL(urlStr: str)
                let urlStr = str
                
                do {
                    guard let first_url = Bundle.main.url(forResource: urlStr, withExtension: "m4a") else {
                        print("URL not found")
                        return
                    }
                    globalPlayer = try AVAudioPlayer(contentsOf: first_url, fileTypeHint: AVFileType.m4a.rawValue)
                    
                    globalPlayer = try AVAudioPlayer(contentsOf: url)
                    globalPlayer?.play()
                    print("playing?")
                    do {
                        try FileManager.default.removeItem(atPath: urlStr)
                    } catch {
                        print("error deleting file")
                    }
                    

                } catch {
                    let ac = UIAlertController(title: "Playback failed", message: "There was a problem", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
        
    }
    
    func startRecording() {
        while self.isOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("loop")
                let urlStr = String(self.url_counter)
                let audioURL = MicVC.getAudioURL(urlStr: urlStr+".m4a")
                print(audioURL.absoluteString)
                
                self.session = AVAudioSession.sharedInstance()
                
                do {
                    try self.session?.setCategory(AVAudioSessionCategoryPlayAndRecord)
                    try self.session?.setActive(true)
                    
                    self.session?.requestRecordPermission() { [unowned self] allowed in
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
                
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                
                self.audioQueue.enqueue(urlStr)
                self.url_counter += 1
                
                do {
                    self.recorder = try AVAudioRecorder(url: audioURL, settings: settings)
                    self.recorder?.delegate = self
                    self.recorder?.record(forDuration: 1)
                } catch {
                    self.isPlaying = false
                    self.finishRecording(success: false)
                }
                
            }
        }
    }
    
    func finishRecording(success: Bool) {
        isPlaying = false
        recorder?.stop()
        recorder = nil
        
        if success {
            print("switch off")
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
