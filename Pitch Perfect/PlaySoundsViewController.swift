//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jonathan K Sullivan  on 1/24/16.
//  Copyright © 2016 Jonathan K Sullivan . All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var audioPlayer: AVAudioPlayer!
    var recievedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            let filePathUrl = NSURL.fileURLWithPath(filePath)
//                   }else{
//            print("the filepath is empty")
//        }
        let filePathUrl = recievedAudio.filePathUrl
        audioPlayer = try!
            AVAudioPlayer(contentsOfURL: filePathUrl)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try!
            AVAudioFile(forReading: recievedAudio.filePathUrl)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
    }
    
    
    func playSound(speed: Float){
        stopAllAudio()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioFX(audioPlayerNode: AVAudioPlayerNode){
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()

    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAllAudio()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        playAudioFX(audioPlayerNode)
    }
    
    
    func playAudioWithSoundEffect(echo: Bool){
        stopAllAudio()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        if(!echo){
            let reverbNode = AVAudioUnitReverb()
            reverbNode.loadFactoryPreset( AVAudioUnitReverbPreset.Cathedral)
            reverbNode.wetDryMix = 60
            audioEngine.attachNode(reverbNode)
            audioEngine.connect(audioPlayerNode, to: reverbNode, format: nil)
            audioEngine.connect(reverbNode, to: audioEngine.outputNode, format: nil)
            
        }
        if(echo){
            let echoNode = AVAudioUnitDelay()
            echoNode.delayTime = NSTimeInterval(0.3)
            audioEngine.attachNode(echoNode)
            audioEngine.connect(audioPlayerNode, to: echoNode, format: audioFile.processingFormat)
            audioEngine.connect(echoNode, to: audioEngine.outputNode, format: nil)
        }
        playAudioFX(audioPlayerNode)
    }
    
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    @IBAction func playSoundSlow(sender: UIButton) {
        playSound(0.5)
    }

    @IBAction func playSoundFast(sender: UIButton) {
        playSound(1.5)
    }
    
    @IBAction func playSoundWithEcho(sender: UIButton) {
        playAudioWithSoundEffect(true)
    }
    
    @IBAction func playSoundWithReverb(sender: UIButton) {
        playAudioWithSoundEffect(false)
    }
    @IBAction func stopSound(sender: UIButton) {
            stopAllAudio()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
