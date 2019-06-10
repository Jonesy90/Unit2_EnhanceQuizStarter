//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Pasan Premaratne on 3/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    let triviaQuestions = TriviaQuestions()
    let soundEffects = SoundEffects()
    
    //Stores the index value of all the questions used to prevent the same question being asked more than once.
    var reptitionStopper: [Int] = []
    
    //countdown timer properties
    var seconds = 15
    var timer = Timer()
    var isTimerRunning = false
    
    //UIButtons
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var buttonFour: UIButton!
    
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var nextQuestion: UIButton!
    
    //UILabel
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answerField: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    
    var gameSound: SystemSoundID = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        runTimer()
        
        soundEffects.loadGameStartSound()
        soundEffects.playGameStartSound()
        displayQuestion()
    }
    
    // MARK: - RandomNumberGenerator
    func randomNumberGenerator() {
        //Generates a random number, which is then assigned to the the [Int] 'repitionStopper'.
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: triviaQuestions.questions.count)
    }
    
    
    // MARK: - Helpers
    
    func displayQuestion() {
        randomNumberGenerator()
        resetTimer()
        runTimer()
        
        //If the random number that is selected has already been used (which is recorded in the 'reptitionChecker') it will generate another random number.
        while reptitionStopper.contains(indexOfSelectedQuestion) {
            randomNumberGenerator()
        }
        
        let questionDictionary = triviaQuestions.questions[indexOfSelectedQuestion]
        
        reptitionStopper.append(indexOfSelectedQuestion)
        
        questionField.text = questionDictionary["Question"]
        buttonOne.setTitle(questionDictionary["OptionOne"], for: .normal)
        buttonTwo.setTitle(questionDictionary["OptionTwo"], for: .normal)
        buttonThree.setTitle(questionDictionary["OptionThree"], for: .normal)
        buttonFour.setTitle(questionDictionary["OptionFour"], for: .normal)

        playAgainButton.isHidden = true
        nextQuestion.isHidden = true
        
    }
    
    func displayScore() {
        // Hide the answer buttons
        buttonOne.isHidden = true
        buttonTwo.isHidden = true
        buttonThree.isHidden = true
        buttonFour.isHidden = true
        timerLabel.isHidden = true
        disableAnswerButtons()
        
        // Display play again button
        playAgainButton.isHidden = false
        
        nextQuestion.isHidden = true
        nextQuestion.isEnabled = false
        
        if correctQuestions <= 0 {
            questionField.text = "Not Great!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
            answerField.isHidden = true
        } else {
            questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
            answerField.isHidden = true
        }
        
        
        questionField.textColor = UIColor.white
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
            correctQuestions = 0
        } else {
            // Continue game
            timerLabel.isHidden = false
            enableAnswerButtons()
            buttonAlphaReset()
            displayQuestion()
        }
    }
    
    func loadNextRound(delay seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        let selectedQuestionsDict = triviaQuestions.questions[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionsDict["Answer"]

        questionsAsked += 1
        timer.invalidate()
        
        
        
        
        if (sender === buttonOne && correctAnswer == buttonOne.currentTitle) || (sender === buttonTwo && correctAnswer == buttonTwo.currentTitle) || (sender === buttonThree && correctAnswer == buttonThree.currentTitle) || (sender === buttonFour && correctAnswer == buttonFour.currentTitle) {
            
            soundEffects.loadCorrectSound()
            soundEffects.playCorrectAnswerSound()
            disableAnswerButtons()
            
            //updating the text field.
            answerField.isHidden = false
            answerField.text = "Correct!"
            answerField.textColor = UIColor(red: 0/225.0, green: 147/225.0, blue: 135/225.0, alpha: 1.0)
            
            correctQuestions += 1
            
            if (buttonOne.currentTitle == correctAnswer) {
                buttonOne.alpha = 1.0
                buttonTwo.alpha = 0.5
                buttonThree.alpha = 0.5
                buttonFour.alpha = 0.5
            } else if (buttonTwo.currentTitle == correctAnswer) {
                buttonOne.alpha = 0.5
                buttonTwo.alpha = 1.0
                buttonThree.alpha = 0.5
                buttonFour.alpha = 0.5
            } else if (buttonThree.currentTitle == correctAnswer) {
                buttonOne.alpha = 0.5
                buttonTwo.alpha = 0.5
                buttonThree.alpha = 1.0
                buttonFour.alpha = 0.5
            } else if (buttonFour.currentTitle == correctAnswer) {
                buttonOne.alpha = 0.5
                buttonTwo.alpha = 0.5
                buttonThree.alpha = 0.5
                buttonFour.alpha = 1.0
            }
        
        } else {
            
            soundEffects.loadWrongSound()
            soundEffects.playIncorrectAnswerSound()
            disableAnswerButtons()
            
            answerField.isHidden = false
            answerField.text = "Sorry, Wrong Answer"
            answerField.textColor = UIColor.orange
            
            
            if (buttonOne.currentTitle == correctAnswer) {
                buttonOne.alpha = 1.0
                buttonTwo.alpha = 0.5
                buttonThree.alpha = 0.5
                buttonFour.alpha = 0.5
            } else if (buttonTwo.currentTitle == correctAnswer) {
                buttonOne.alpha = 0.5
                buttonTwo.alpha = 1.0
                buttonThree.alpha = 0.5
                buttonFour.alpha = 0.5
            } else if (buttonThree.currentTitle == correctAnswer) {
                buttonOne.alpha = 0.5
                buttonTwo.alpha = 0.5
                buttonThree.alpha = 1.0
                buttonFour.alpha = 0.5
            } else if (buttonFour.currentTitle == correctAnswer) {
                buttonOne.alpha = 0.5
                buttonTwo.alpha = 0.5
                buttonThree.alpha = 0.5
                buttonFour.alpha = 1.0
            }
        }
            
            nextQuestion.isHidden = false
//            loadNextRound(delay: 2)
    
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        // Show the answer buttons
        buttonOne.isHidden = false
        buttonTwo.isHidden = false
        buttonThree.isHidden = false
        buttonFour.isHidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    
    @IBAction func nextQuestionButton(_ sender: Any) {
        answerField.isHidden = true
        nextRound()
        enableAnswerButtons()
    }
    
    

    
    
    
    //MARK: - Helper Functions
    
    func disableAnswerButtons() {
        buttonOne.isEnabled = false
        buttonTwo.isEnabled = false
        buttonThree.isEnabled = false
        buttonFour.isEnabled = false
    }
    
    func enableAnswerButtons() {
        buttonOne.isEnabled = true
        buttonTwo.isEnabled = true
        buttonThree.isEnabled = true
        buttonFour.isEnabled = true
        nextQuestion.isEnabled = true
    }
    
    func buttonAlphaReset() {
        questionField.textColor = .white
        buttonOne.alpha = 1.0
        buttonTwo.alpha = 1.0
        buttonThree.alpha = 1.0
        buttonFour.alpha = 1.0
    }
    
    
    //timer stuff
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            timerLabel.text = "Time's Up!"
            disableAnswerButtons()
            nextQuestion.isHidden = false
            nextQuestion.isEnabled = true
            questionsAsked += 1
            
        } else {
            seconds -= 1
            timerLabel.text = "\(seconds)"
        }
        
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func resetTimer() {
        timer.invalidate()
        seconds = 15
        timerLabel.text = "\(seconds)"
    }


}
