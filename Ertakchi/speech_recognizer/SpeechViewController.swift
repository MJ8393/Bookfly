//
//  SpeechViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 12/01/24.
//

import UIKit
import googleapis
import AVFoundation

let keywords = ["book", "fly"]
let singleCommands = ["play", "pause", "stop"]
let doubleCommands = ["translate"]

let singleSynonims = ["pause", "stop", "play", "pose", "pals"]
let doubleSynonims = ["translates", "translate"]


class SpeechViewController: UIViewController {
    
    var actions = [String]()
    
    var audioData: NSMutableData!
    
    let SAMPLE_RATE = 16000
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        AudioController.sharedInstance.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkMicPermission()
        startAudio()
    }
}

extension SpeechViewController: AudioControllerDelegate {

    func processSampleData(_ data: Data) -> Void {
      audioData.append(data)
      // We recommend sending samples in 100ms chunks
      let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
                                                  * Double(SAMPLE_RATE) / 2.0 /* samples/second */ /* bytes/sample */);

      if (audioData.length > chunkSize) {
          
        SpeechRecognitionService.sharedInstance.streamAudioData(audioData,
                                                                completion:
          { [weak self] (response, error) in
              guard let strongSelf = self else {
                  return
              }
              if let error = error {
              } else if let response = response {
                  var finished = false
                  for result in response.resultsArray! {
                      if let result = result as? StreamingRecognitionResult {
                          if let alternativesArray = result.alternativesArray as? [SpeechRecognitionAlternative] {
                              if let text = alternativesArray[0].transcript {
                                  let command = self?.identifyCommands(text: text)
                                  if let action = command?.command, let str = command?.str {
                                      self?.doAction(command: action, str: str)
                                  }
                              }
                          }
                          if result.isFinal {
                              finished = true
                          }
                      }
                  }
                  if finished {
//                      self?.actions = []
                      self?.stopAudio()
                      self?.startAudio()
                  }
              }
        })
        self.audioData = NSMutableData()
      }
    }
    
    func startAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
        } catch {

        }
        audioData = NSMutableData()
        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE)
        SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
        _ = AudioController.sharedInstance.start()
    }
    
    func stopAudio() {
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
    }
}

extension SpeechViewController {
    
    private func checkMicPermission() -> Bool {
        var permissionCheck: Bool = false
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            permissionCheck = true
        case AVAudioSession.RecordPermission.denied:
            permissionCheck = false
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if granted {
                    permissionCheck = true
                } else {
                    permissionCheck = false
                }
            })
        default:
            break
        }
        
        return permissionCheck
    }
    
    
}


extension SpeechViewController {
        
    func identifyCommands(text: String) -> (command: Command, str: String){
        print("Str", text)
        var currentWord = ""
        var words: [String] = []

        words = processInput(text)
                
        for word in words {
             print(actions)
            if actions.count == 0 {
                // It should always "Book"
                if word.replacingOccurrences(of: " ", with: "").lowercased() == "book" {
                    print("I am going to append", word)
                    actions.append(word)
                }
            } else if actions.count == 1 {
                if word.replacingOccurrences(of: " ", with: "").lowercased() == "fly" ||  word.replacingOccurrences(of: " ", with: "").lowercased() == "flight" ||  word.replacingOccurrences(of: " ", with: "").lowercased() == "life" {
                    print("I am going to append", word)
                    actions.append(word)
                }
            } else if actions.count == 2 {
                let currentWord = word.replacingOccurrences(of: " ", with: "").lowercased()

                if singleCommands.contains(currentWord) || singleSynonims.contains(currentWord) {
                    if currentWord == "play" {
                        // play video
                        actions = []
                        return (.play, "")
                    } else if currentWord == "pause" || currentWord == "pose" || currentWord == "pals" {
                        // pause video
                        actions = []
                        return (.pause, "")
                    } else if currentWord == "stop" {
                        // stop video
                        actions = []
                        return (.stop, "")
                    }
                } else if doubleCommands.contains(currentWord) || doubleSynonims.contains(currentWord) {
                    if currentWord == "translate" || currentWord == "translates" {
                        actions.append("translate")
                    }
                }
            } else if actions.count == 3 {
                let currentWord = word.replacingOccurrences(of: " ", with: "").lowercased()
                if !keywords.contains(currentWord) && !singleCommands.contains(currentWord) && !doubleCommands.contains(currentWord) {
                    // translate current word
                    actions = []
                    return (.translate, currentWord)
                }
            }
            
        }
        print("Actions", actions)
        return (.none, "")
    }
    
    func doAction(command: Command, str: String) {
        switch command {
        case .play:
            print("111111111111")
        case .pause:
            print("222222222222")
        case .stop:
            print("333333333333")
        case .translate:
            print("4444444444", str)
        case .none:
            break
        }
    }
    
    func processInput(_ inputString: String) -> [String] {
        // Split the input string into words
        let words = inputString.split(separator: " ")
        
        // Convert each word to lowercase
        let lowercaseWords = words.map { String($0).lowercased() }
        
        return lowercaseWords
    }
}

enum Command {
    case play
    case pause
    case stop
    case translate
    case none
}
