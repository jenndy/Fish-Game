//
//  About.swift
//  Pet_Add_One
//
//  Created by Jennifer Dong  on 11/26/19.
//  Copyright © 2019 Jennifer Dong . All rights reserved.
//

import UIKit

class About: UIViewController {

    @IBOutlet weak var fishCurlUp: UIImageView!
    @IBOutlet weak var fishCurlDown: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var paragraph: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setTitle(NSLocalizedString("Back", comment: ""), for: .normal)
        UserDefaults.standard.set("Fish", forKey: "fish-image")
        fishCurlUp.image = UIImage(named: UserDefaults.standard.string(forKey: "fish-image")!)
        UserDefaults.standard.set("Fish-flip", forKey: "fish-flip-image")
        fishCurlDown.image = UIImage(named: UserDefaults.standard.string(forKey: "fish-flip-image")!)
        paragraph.text = NSLocalizedString("Paragraph", comment: "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.transition(with: fishCurlUp, duration: 3.0, options: .transitionCurlUp, animations: nil, completion: nil)
        
         UIView.transition(with: fishCurlDown, duration: 3.0, options: .transitionCurlDown, animations: nil, completion: nil)
    }
}
