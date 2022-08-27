//
//  Game.swift
//  Pet_Add_One
//
//  Created by Jennifer Dong  on 11/26/19.
//  Copyright © 2019 Jennifer Dong . All rights reserved.
//

import UIKit
import CoreData

class Game: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scoreLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var numberLabel: UILabel?
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var fishWindow: UIImageView!
    @IBOutlet weak var quit: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var pointsText: UILabel!
    @IBOutlet weak var timerText: UILabel!
    
    // TODO: weather API  - water alpha adjusts
    
    var fish: Fish?
    var score = 0
    var timer: Timer?
    var seconds = 30
    var flipped = false
    var swam = false
    var jumped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputField.delegate = self
        inputField.becomeFirstResponder()
        quit.layer.cornerRadius = 8
        quit.setTitle(NSLocalizedString("Quit", comment: ""), for: .normal)
        startButton.layer.cornerRadius = 8
        startButton.setTitle(NSLocalizedString("Start", comment: ""), for: .normal) 
        pointsText?.text = NSLocalizedString("Points", comment: "")
        timerText?.text = NSLocalizedString("Timer", comment: "")
        updateScoreLabel()
        updateNumberLabel()
        updateTimeLabel()
        
        //fishWindow.image = UIImage(named: passImage)
        fishWindow.image = UIImage(named: "Fish")
        if let i = fish {
            if let s = i.image {
                fishWindow.image = UIImage(named: s as String)
            }
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let forecastHelper = ForecastHelper()
        forecastHelper.fetchForecasts() { result in
            switch result {
            case let .Success(forecasts):
                self.switchOnCondition(s: forecasts.daily.icon)
            case .Failure:
                break
            }
        }
    }
    
    func switchOnCondition(s: String){
 
        switch s {
            case "clear-day":
                bgImage.image = UIImage(named: "Background-2")
            case "clear-night":
                bgImage.image = UIImage(named: "Background-3")
            case "partly-cloudy-day":
                bgImage.image = UIImage(named: "Background")
            case "partly-cloudy-night":
                bgImage.image = UIImage(named: "Background-3")
            case "cloudy":
                bgImage.image = UIImage(named: "Background")
            case "rain":
                bgImage.image = UIImage(named: "Background")
            case "sleet":
                bgImage.image = UIImage(named: "Background")
            case "snow":
                bgImage.image = UIImage(named: "Background")
            case "wind":
                bgImage.image = UIImage(named: "Background")
            case "fog":
                bgImage.image = UIImage(named: "Background")
            default:
                bgImage.image = UIImage(named: "Background")
            
        }
    }
    
    // Start button fade animation
    @IBAction func startFade(_ sender: Any) {
//        self.startButton.backgroundColor = UIColor.clear
//        self.startButton.setTitleColor(UIColor.clear, for: .normal)
//        UIView.transition(with: startButton, duration: 1.0, options: .transitionCrossDissolve, animations: nil, completion: nil)
        UIView.animate(withDuration: 1.0, animations:{
            self.startButton?.alpha = 0
            self.view.layoutIfNeeded()
        })
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if self.seconds == 0 {
                    self.finishGame()
                } else if self.seconds <= 60 {
                    self.seconds -= 1
                    self.updateTimeLabel()
                }
            }
        }
    }
    
    @IBAction func fishSwipe(_ sender: Any) {
        // enable user interaciton to flip fish
        // check if flipped before - use boolean
        // check type of fish to flip
        if let i = fish {
            if let s = i.image {
                if s == "Fish" || s == "Fish-flip"{
                    if flipped {
                        flipped = false
                        fishWindow.image = UIImage(named: "Fish")
                    }else{
                        flipped = true
                        fishWindow.image = UIImage(named: "Fish-flip")
                    }
                } else if s == "Whale" || s == "Whale-flip"{
                    if flipped {
                        flipped = false
                        fishWindow.image = UIImage(named: "Whale")
                    }else{
                        flipped = true
                        fishWindow.image = UIImage(named: "Whale-flip")
                    }
                    
                } else if s == "Blowfish" || s == "Blowfish-flip" {
                    if flipped {
                        flipped = false
                        fishWindow.image = UIImage(named: "Blowfish")
                    }else{
                        flipped = true
                        fishWindow.image = UIImage(named: "Blowfish-flip")
                    }
                }
            }
        }
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func inputFieldDidChange(){
        guard let numberText = numberLabel?.text, let inputText = inputField?.text else {
            return
        }
        guard inputText.count == 4 else {
            return
        }
        var isCorrect = true
        for n in 0..<4 {
            var input = inputText.intConvert(at: n)
            let number = numberText.intConvert(at: n)
            if input == 0 {
                input = 10
            }
            if input != number + 1 {
                isCorrect = false
                break
            }
        }
        if isCorrect {
            score += 1
        } else {
            score -= 1
        }
        
        updateNumberLabel()
        updateScoreLabel()
        inputField?.text = ""
        
        // Check to swim or jump
        if score >= 3 && !swam {
            swim()
            swam = true
        }
        if score >= 5 && !jumped{
            jump()
            jumped = true
        }
    }
    
    func swim(){
        UIView.animate(withDuration: 2.0, animations: {
            // left view has x = 0
            //+self.fishWindow.frame.width : image width from the left
            self.fishWindow.frame.origin.x = +self.fishWindow.frame.width
        })
    }
    
    func jump(){
        UIView.animate(withDuration: 0.5, animations: {
            self.fishWindow?.rotate(by: Double.pi / 2, with: CGPoint(x: 0.4, y: -0.4))
        },completion: { _ in
            UIView.animate(withDuration: 1.0, animations: {
                self.fishWindow?.rotate(by: Double.pi / 2, with: CGPoint(x: 0.4, y: -0.4))
            },completion: { _ in
                UIView.animate(withDuration: 1.0, animations: {
                    self.fishWindow.transform = CGAffineTransform.identity
                })
            })
        })
        
    }
    
    func updateScoreLabel() {
        scoreLabel?.text = String(score)
    }
    
    func updateNumberLabel() {
        numberLabel?.text = String.randomNum(length: 4)
    }
    
    func updateTimeLabel() {
        
        let min = (seconds / 60) % 60
        let sec = seconds % 60
        
        timeLabel?.text = String(format: "%02d", min) + ":" + String(format: "%02d", sec)
    }
    
    func restart(){
        flipped = false
        swam = false
        jumped = false
        seconds = 30
        UIView.animate(withDuration: 1.0, animations:{
            self.startButton?.alpha = 1.0
            self.view.layoutIfNeeded()
        })
        UIView.animate(withDuration: 2.0, animations: {
            //self.fishWindow.frame.origin.x = +self.fishWindow.frame.width*4.0
            self.fishWindow.frame.origin.x = self.view.frame.width - self.fishWindow.frame.width
        })
        // clear input field
        inputField?.text = ""
    }
    
    func finishGame() {
        timer?.invalidate()
        timer = nil
    
        let alert = UIAlertController(title: NSLocalizedString("Time's up!", comment: ""), message: "Score: \(score)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Play again", comment: ""), style: .default, handler: { action in
            self.restart()
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Start page", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Start")
            self.present(newViewController, animated: true, completion: nil)
            
        }))
        
        // Updates score in core data and table view
        self.present(alert, animated: true, completion: nil)
        if (score > fish!.score){
            fish!.score = Int16(score)
            CoreDataStack.shared.saveContext()
        }
        score = 0
        
        updateTimeLabel()
        updateScoreLabel()
        updateNumberLabel()
        
    }

    @IBAction func Quit(_ sender: Any) {
        
        let player = UIAlertController(title: NSLocalizedString("Are you sure you want to quit?", comment: ""), message: "", preferredStyle: .alert)
        
        player.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Start")
            self.present(newViewController, animated: true, completion: nil)
            
        }))
        
        player.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(player, animated: true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
