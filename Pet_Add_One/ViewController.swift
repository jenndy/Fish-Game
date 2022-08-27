//
//  ViewController.swift
//  Pet_Add_One
//
//  Created by Jennifer Dong  on 11/26/19.
//  Copyright © 2019 Jennifer Dong . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var about: UIButton!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var startImage: UIImageView!
    
    @IBAction func playButton(_ sender: Any) {
        let player = UIAlertController(title: NSLocalizedString("Choose Player", comment: ""), message: "", preferredStyle: .alert)
        
        player.addAction(UIAlertAction(title: NSLocalizedString("Existing player", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Players") as! Players
            self.present(newViewController, animated: true, completion: nil)
           
        }))
        
        player.addAction(UIAlertAction(title: NSLocalizedString("Create new player", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Settings") 
            self.present(newViewController, animated: true, completion: nil)
        
        }))
        
        player.addAction(UIAlertAction(title: NSLocalizedString(NSLocalizedString("Cancel", comment: ""), comment: ""),  style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(player, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        about.layer.cornerRadius = 8
        play.layer.cornerRadius = 8
        about.setTitle(NSLocalizedString("About", comment: ""), for: .normal)
        play.setTitle(NSLocalizedString("Play", comment: ""), for: .normal)
        
        UserDefaults.standard.set("Start", forKey: "start-image")
        startImage.image = UIImage(named: UserDefaults.standard.string(forKey: "start-image")!)
    }
}

