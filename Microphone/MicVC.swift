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
    
    var audioSession: AVAudioSession?
    var iphoneInput: AVAudioSessionPortDescription = AVAudioSession.sharedInstance().availableInputs![0]

    
    var audioQueue: AQ<String>?
//    
//    var isPlaying = false
//    var urlStr = ""
//    var globalPlayer: AVAudioPlayer?
//    var recorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onButton.backgroundColor = .orange
        offButton.backgroundColor = .gray
        onButton.layer.cornerRadius = 10
        offButton.layer.cornerRadius = 10
        
        print("Loaded")
    }
    
    @IBAction func onPressed(_ sender: UIButton) {
        onButton.backgroundColor = .white
        offButton.backgroundColor = onColor
        print("On")
        
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try audioSession?.setActive(true)
            
            try audioSession?.setPreferredIOBufferDuration(0.005)
            try audioSession?.setPreferredInput(iphoneInput)
            try audioSession?.setPreferredSampleRate(44100)
            
            
        } catch {
            print("ERROR")
        }
        
    }
    
    @IBAction func offPressed(_ sender: UIButton) {
        onButton.backgroundColor = .orange
        offButton.backgroundColor = .gray
        print("Off")
        do {
            try audioSession?.setActive(false)
        } catch {
            print("Error turning off audio session")
        }
    }
}
