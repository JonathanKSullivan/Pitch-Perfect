//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jonathan K Sullivan  on 1/24/16.
//  Copyright © 2016 Jonathan K Sullivan . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
    }

    @IBAction func Record(sender: UIButton) {
        recordingLabel.hidden = false
        recordButton.enabled = false
        stopButton.hidden = false
        
    }

    @IBAction func Stop(sender: UIButton) {
    }
}

