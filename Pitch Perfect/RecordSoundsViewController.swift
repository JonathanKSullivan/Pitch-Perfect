//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jonathan K Sullivan  on 1/24/16.
//  Copyright © 2016 Jonathan K Sullivan . All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var startedRecording: Bool!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
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
        pauseButton.hidden = true
        startedRecording = false

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag){
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = audioRecorder.url
            recordedAudio.title = audioRecorder.url.lastPathComponent
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    @IBAction func PauseRecording(sender: UIButton) {
        recordButton.enabled = true
        //TODO 2 write pause functionallity
        recordingLabel.text = "Paused"
        audioRecorder.pause()
    }
    @IBAction func Record(sender: UIButton) {
        if(!startedRecording){
            recordingLabel.hidden = false
            recordButton.enabled = false
            stopButton.hidden = false
            pauseButton.hidden = false
            startedRecording = true
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let recordingName = "pitch_perfect_audio.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            print(filePath)
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
        }
        recordingLabel.text = "Recording..."
        audioRecorder.record()
    }

    @IBAction func Stop(sender: UIButton) {
        recordingLabel.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
   }

