//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by callum brennan on 15/04/2017.
//  Copyright © 2017 callum brennan Mementcode. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var audioRecorder : AVAudioRecorder?  // swift assumes it is set to "= nil"
    
    var audioPlayer : AVAudioPlayer?
    
    var audioURL : URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setupRecorder() {
        
        do{
            
            //Create an Audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            
            // Create URL for the audio file
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            let pathComponents = [basePath, "Audio.M4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            
            // Create settings for the Audiorecorder
            
            var settings : [String:Any] = [:]
            
            settings [AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings [AVSampleRateKey] = 44100.0
            settings [AVNumberOfChannelsKey] = 2
            
            
            
            // Create audio recorder object
            
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        } catch let error as NSError {
            print (error)
            
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording {
    // Stop the recording
            audioRecorder?.stop()
            
    // change button title 
            recordButton.setTitle("Record", for: .normal)
            
            playButton.isEnabled = true
            addButton.isEnabled = true
            
        } else {
            // Start Recording
            audioRecorder?.record()
            
            // Change button title to Stop
            recordButton.setTitle("Stop", for: .normal)
        
        }
    
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do {
        try audioPlayer = AVAudioPlayer (contentsOf: audioURL!)
            audioPlayer!.play()
            
        } catch {}
        
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context : context)
        
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)
        
        
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    navigationController!.popViewController(animated: true)
        
        
    
    }
}
