//
//  ViewController.swift
//  SoundSample
//
//  Created by 渡邉康太 on 2019/11/05.
//  Copyright © 2019 渡邉康太. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var soundPickerView: UIPickerView!
    
    var audioPlayer: AVAudioPlayer!
    var audioPlayers: [AVAudioPlayer] = []
    
    var isMultiMode: Bool = false
    
    var soundFiles: [[String]] = [
        ["効果音ラボ 戦闘[1] 剣で斬る1", "sword-slash1"],
        ["効果音ラボ 戦闘[1] 剣で斬る2", "sword-slash2"],
        ["効果音ラボ 戦闘[1] 剣で斬る3", "sword-slash3"]
    ]
    
    var selectedSound: String!
    var volumeBySlider: Float = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        soundPickerView.delegate = self
        soundPickerView.dataSource = self
        
        setup(soundFiles: soundFiles)
        selectedSound = soundFiles[0][1]
    }

    @IBAction func playSoundByButton(_ sender: Any) {
        playSound(name: selectedSound)
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        isMultiMode = sender.isOn
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        volumeBySlider = sender.value
        if isMultiMode {
            for player in audioPlayers {
                player.volume = volumeBySlider
            }
        } else {
            audioPlayer.volume = volumeBySlider
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return soundFiles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        label.textAlignment = .center
        label.text = soundFiles[row][0]
        label.font = UIFont(name: "HiraginoSans-W3", size: 20)
        label.textColor = .white
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSound = soundFiles[row][1]
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func setup(soundFiles: [[String]]) {
        for name in soundFiles {
            guard let path = Bundle.main.path(forResource: name[1], ofType: "mp3") else {
                print("音源ファイルが見つかりません")
                return
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer.delegate = self
                // mp3の事前読み込み
                audioPlayer.prepareToPlay()
            } catch {
                
            }
        }
    }
    
    func playSound(name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("音源ファイルが見つかりません")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer.delegate = self
            audioPlayer.volume = volumeBySlider
            audioPlayer.play()

            if isMultiMode {
                audioPlayers.append(audioPlayer)
            }
        } catch {

        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            for (index, player) in audioPlayers.enumerated() {
                if !player.isPlaying {
                    audioPlayers.remove(at: index)
                }
            }
        }
    }
}



