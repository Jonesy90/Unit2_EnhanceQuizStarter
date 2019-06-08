//
//  SoundEffects.swift
//  EnhanceQuizStarter
//
//  Created by Michael Jones on 05/06/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation
import AudioToolbox

var gameSound: SystemSoundID = 0
var correctSound: SystemSoundID = 0
var wrongSound :SystemSoundID = 0


struct SoundEffects {
    
    func loadGameStartSound () {
        let pathToSoundStartSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let startSoundURL = URL(fileURLWithPath: pathToSoundStartSoundFile!)
        AudioServicesCreateSystemSoundID(startSoundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound () {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func loadCorrectSound() {
        let pathToCorrectSoundFile = Bundle.main.path(forResource: "correctSound", ofType: "m4a")
        let startSoundURL = URL(fileURLWithPath: pathToCorrectSoundFile!)
        AudioServicesCreateSystemSoundID(startSoundURL as CFURL, &correctSound)
    }
    
    func playCorrectAnswerSound() {
        AudioServicesPlaySystemSound(correctSound)
    }
    
    func loadWrongSound() {
        let pathToWrongSoundFile = Bundle.main.path(forResource: "wrongSound", ofType: "m4a")
        let wrongSoundURL = URL(fileURLWithPath: pathToWrongSoundFile!)
        AudioServicesCreateSystemSoundID(wrongSoundURL as CFURL, &wrongSound)
    }
    
    func playIncorrectAnswerSound() {
        AudioServicesPlaySystemSound(wrongSound)
    }
}




