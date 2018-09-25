//
//  MicVC.swift
//  Microphone
//
//  Created by Neil Sood on 9/25/18.
//  Copyright © 2018 Neil Sood. All rights reserved.
//

import UIKit

class MicVC: UIViewController {
    
    @IBOutlet weak var switchButton: UIButton!
    
    var isSwitched = false
    var input: InputStream?
    var output: OutputStream?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func switchPressed(_ sender: UIButton) {
        if !isSwitched {
            switchButton.setBackgroundImage(UIImage(named: "resize_green_switch"), for: .normal)
            isSwitched = true
            input?.open()
            output?.open()
            print("HI",input?.streamStatus)
        }
        else {
            // check record successful
            switchButton.setBackgroundImage(UIImage(named: "resize_red_switch"), for: .normal)
            isSwitched = false
            input?.close()
            output?.close()
            print("BYE",input?.streamStatus)
        }
        
    }

}
