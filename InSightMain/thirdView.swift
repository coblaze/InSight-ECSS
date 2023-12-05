//
//  thirdView.swift
//  InSight
//
//  
//

import UIKit
import Speech
import AVFoundation

class thirdView: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var voiceLabel: UILabel!
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var rightNext: UIButton!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var recognizedText: String = ""
    
    var roomNum: String?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        askForRoomNumber()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
            let location = sender.location(in: self.view)
            
            // Check if the tap is in the bottom right of the screen
            if location.x > self.view.frame.width / 2 {
                if self.roomNum != nil {
                    let nextView = self.storyboard?.instantiateViewController(identifier: "thirdVC") as! detectorView
                    self.present(nextView, animated: true)
                }
            } else {
                askForRoomNumber()
            }
        }
    
    
    @IBAction func pressRoom(_ sender: Any) {
        startRecording()
    }
    
    @IBAction func releaseRoom(_ sender: Any) {
        stopRecording()
        
        roomNum = self.recognizedText.replacingOccurrences(of: "Room ", with: "")
        
        if !roomNum!.isEmpty {
            self.voiceLabel.text = "Navigating to room \(roomNum!)"
            speak(text: "Navigating to room \(roomNum!). Tap the bottom left to confirm.")
        } else {
            speak(text: "Didn't catch that please try again")
            roomNum = nil
            askForRoomNumber()
        }
    }
    
    @IBAction func rnConfirm(_ sender: Any) {
        if self.roomNum != nil {
               let nextView = self.storyboard?.instantiateViewController(identifier: "thirdVC") as! detectorView
               self.present(nextView, animated: true)
           } else {
               self.voiceLabel.text = "Tap the bottom right of the screen to confirm"
               speak(text: "Tap the bottom right of the screen to confirm.")
               
           }
    }
        


    func startRecording() {
        // Configure audio session
        speak(text: "Recording started. Speak now.")
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try! audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        // Configure recognition request
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, time) in
            self.request.append(buffer)
        }
        
        // Start audio engine
        audioEngine.prepare()
        try! audioEngine.start()

        // Start recognition task
        recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
            if let result = result {
                self.recognizedText = result.bestTranscription.formattedString
                print(self.recognizedText)
            }
        }
        /*
        recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
            if let error = error {
                print("Recognition error: \(error)")
            } else if let result = result {
                self.recognizedText = result.bestTranscription.formattedString
                print(self.recognizedText)
            }
        }*/
    }

    func stopRecording() {
        speak(text: "Recording stopped.")
        audioEngine.stop()
        request.endAudio()
        recognitionTask?.cancel()
    }

    func speak(text: String) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: text)
        synthesizer.speak(utterance)
    }

    func askForRoomNumber() {
        // Ask the user for a room number
        speak(text: "Hold the bottom left of the screen and say room number")
    }
    
    
}


