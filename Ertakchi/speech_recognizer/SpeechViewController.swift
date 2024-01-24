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

let keysozlar = ["kitob"]
let yagonaKammandla = ["boshla", "shoshma", "toxta"]
let ikkiCommandla = ["tarjima"]
let yagonaSinonim = ["boshla", "shoshma", "toxta", "toʻxtab", "toʻxta", "boshladi", "boshlanadi", "boshlab",  "shoshmay tur",  "shoshmay",  "shoshmay tur"]
let ikkiSinonimlar = ["tarjima", "tarjima qil"]

extension PlayerViewController: AudioControllerDelegate {

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
                                  let command = self?.identifyEnglishCommands(text: text)
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
                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                          self?.startAudio()
                      }
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

extension PlayerViewController {
    
    func checkMicPermission() -> Bool {
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


extension PlayerViewController {
        
    func identifyEnglishCommands(text: String) -> (command: Command, str: String){
        print("Str", text)
        var currentWord = ""
        var words: [String] = []

        words = processInput(text)
                
        for word in words {
             print(actions)
            if actions.count == 0 {
                // It should always "Book"
                if word.replacingOccurrences(of: " ", with: "").lowercased() == "book" {
                    actions.append(word)
                }
            } else if actions.count == 1 {
                if word.replacingOccurrences(of: " ", with: "").lowercased() == "fly" ||  word.replacingOccurrences(of: " ", with: "").lowercased() == "flight" ||  word.replacingOccurrences(of: " ", with: "").lowercased() == "life" {
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
                } else if currentWord == "VR" {
                    actions.append("VR")
                }
            } else if actions.count == 3 {
                let currentWord = word.replacingOccurrences(of: " ", with: "").lowercased()
                if !keywords.contains(currentWord) && !singleCommands.contains(currentWord) && !doubleCommands.contains(currentWord) {
                    // translate current word
                    let count = actions.count
                    if actions[count - 1] == "translate" {
                        actions = []
                        return (.translate, currentWord)
                    }
                }
                
                if actions[actions.count - 1] == "VR" {
                    if currentWord == "on" {
                        actions = []
                        return (.vr, "on")
                    } else if currentWord == "off" || currentWord == "of" {
                        actions = []
                        return (.vr, "off")
                    }
                }
                
                if currentWord == "are" {
                    actions.append("are")
                }
            } else if actions.count == 4 {
                let currentWord = word.replacingOccurrences(of: " ", with: "").lowercased()
                if currentWord == "on" {
                    actions = []
                    return (.vr, "on")
                } else if currentWord == "off" || currentWord == "of" {
                    actions = []
                    return (.vr, "off")
                }
            }
            
        }
        print("Actions", actions)
        return (.none, "")
    }
    
    func doAction(command: Command, str: String) {
        switch command {
        case .play:
            if !(currentState == .play) {
                playingVideo = false
                playPausePlayer()
                currentState = .play
            }
        case .pause:
            if !(currentState == .pause) {
                playingVideo = true
                playPausePlayer()
                currentState = .pause
            }
        case .stop:
            if !(currentState == .stop) {
                navigationController?.popViewController(animated: true)
                currentState = .stop
            }
        case .vr:
            if !(currentState == .vr) {
                if str == "on" {
                    if !cardboardViewOn {
                        activateCardboardView()
                    }
                } else if str == "off" {
                    if cardboardViewOn {
                        activateCardboardView()
                    }
                }
                currentState = .vr
            }
        case .translate:
            let alertController = UIAlertController(title: str.capitalized, message: "Do you want to translate \(str.capitalized)", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Translate", style: .default) { (action) in
                self.translate(word: str.lowercased())
            }
            alertController.addAction(defaultAction)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            }
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            print("4444444444", str)
        case .none:
            break
        }
    }
    
    func processInput(_ inputString: String) -> [String] {
        let words = inputString.split(separator: " ")
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
    case vr
}


extension PlayerViewController {
    
    func identifyUzbekCommands(text: String) -> (command: Command, str: String){
        var currentWord = ""
        var lastWord = ""
        var words: [String] = []

        words = processInput(text)
                
        for word in words {
             print(actions)
            if actions.count == 0 {
                // It should always "Book"
                if word.replacingOccurrences(of: " ", with: "").lowercased() == "kitob" {
                    actions.append(word)
                }
            } else if actions.count == 1 {
                let currentWord = word.replacingOccurrences(of: " ", with: "").lowercased()

                if yagonaKammandla.contains(currentWord) || yagonaSinonim.contains(currentWord) {
                    if currentWord == "boshla" || currentWord == "boshlab" || currentWord == "boshladi" || currentWord == "boshlanadi" {
                        // play video
                        actions = []
                        return (.play, "")
                    } else if currentWord == "shoshma" || currentWord == "shoshmay tur" || currentWord == "shoshmagin" || currentWord == "shoshmay"{
                        // pause video
                        actions = []
                        return (.pause, "")
                    } else if currentWord == "toʻxta" || currentWord == "toxta" || currentWord == "toʻxtab"{
                        // stop video
                        actions = []
                        return (.stop, "")
                    }
                } else if ikkiCommandla.contains(currentWord) || ikkiSinonimlar.contains(currentWord) {
                    if currentWord == "tarjima" || currentWord == "tarjima qil" {
                        actions.append("translate")
                    }
                }
            } else if actions.count == 2 {
                let currentWord = word.replacingOccurrences(of: " ", with: "").lowercased()
                if word == "qil" {
                    lastWord = "tarjima"
                    continue
                } else {
                    if !keysozlar.contains(currentWord) && !yagonaKammandla.contains(currentWord) && !ikkiCommandla.contains(currentWord) {
                        actions = []
                        return (.translate, currentWord)
                    }
                }
            } else if actions.count == 3 && word == "qil" && lastWord == "tarjima" {
                let currentWord = word.replacingOccurrences(of: " ", with: "").lowercased()
                return (.translate, currentWord)
            }
        }
        return (.none, "")
    }
    
}

extension PlayerViewController {
    func translate(word: String) {
        API.shared.translate(word: word) { result in
            switch result {
            case .success(let translation):
                if let results = translation.results {
                    if results.count != 0 {
                        if let lexicalEntries = results[0].lexicalEntries {
                            if lexicalEntries.count != 0 {
                                if let entries = lexicalEntries[0].entries {
                                    if entries.count != 0 {
                                        if let senses = entries[0].senses {
                                            if senses.count != 0 {
                                                if let desfinations = senses[0].definitions {
                                                    if desfinations.count != 0 {
                                                        self.showAlert(title: word.capitalized, message: desfinations[0])
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
