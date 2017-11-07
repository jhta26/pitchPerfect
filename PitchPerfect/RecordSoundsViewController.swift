//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jason Hsu on 1/24/17.
//  Copyright © 2017 Jason Hsu. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
       super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }
    
    func setUIState(isRecording: Bool, recordingText: String){
        
        if isRecording{
            
            recordingLabel.text = recordingText
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
            
        } else {
            
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordingLabel.text = recordingText
        }
            
        
        }
    @IBAction func recordAudio(_ sender: Any) {
        setUIState(isRecording: true, recordingText: "Recording in Progress")
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    
    }
  
        
        
    
          
    
    
    
    @IBAction func stopRecording(_ sender: Any) {
        
        setUIState(isRecording: false, recordingText: "Tap to Record")
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }

    
}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}
