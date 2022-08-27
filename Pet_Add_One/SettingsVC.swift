//
//  Settings.swift
//  Pet_Add_One
//
//  Created by Jennifer Dong  on 11/26/19.
//  Copyright © 2019 Jennifer Dong . All rights reserved.
//

import UIKit
import CoreData
//var passImage = "Fish"

class Settings: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var fishName: String!
    var fishType: String!
    var fishImage: String!
    // var fish: [NSManagedObject] = []
    
    @IBOutlet weak var fishNameOutlet: UITextField!
    @IBOutlet weak var fishTypeOutlet: UIPickerView!
    @IBOutlet weak var fishImageOutlet: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var fishNameLabel: UILabel!
    @IBOutlet weak var fishTypeLabel: UILabel!
    
    var fishArray: [String] = [String]()
    
    @IBAction func updateTitle(_ sender: UITextField) {
        if let newValue = sender.text {
            fishName = newValue
        }
    }
    
    // TODO: create new player to game or to table view 
    func playButtonAction() {
        let index  = fishTypeOutlet.selectedRow(inComponent: 0)
        fishType = fishArray[index]
        fishImage = fishArray[index]
        //CoreDataStack.shared.saveEntry(name: fishName, type: fishType, score: 0, image: fishImage)
        saveEntry(name: fishName, type: fishType, score: 0, image: fishImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fishTypeOutlet.delegate = self
        self.fishTypeOutlet.dataSource = self
        fishNameLabel.text = NSLocalizedString("Fish Name", comment: "")
        fishTypeLabel.text = NSLocalizedString("Fish Type", comment: "")
        fishArray = ["Fish", "Whale", "Blowfish"]
        playButton.layer.cornerRadius = 8
        playButton.setTitle(NSLocalizedString("Play", comment: ""), for: .normal)
        backButton.setTitle(NSLocalizedString("Back", comment: ""), for: .normal)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func saveEntry(name: String, type: String, score: Int, image: String) {
      
        //print("trying to save \(name)")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Fish", in: managedContext)!
        
        let entry = NSManagedObject(entity: entity, insertInto: managedContext)
        
        entry.setValue(name, forKeyPath: "name")
        entry.setValue(type, forKeyPath: "type")
        entry.setValue(score, forKeyPath: "score")
        entry.setValue(image, forKeyPath: "image")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save the entry. \(error), \(error.userInfo)")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return fishArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NSLocalizedString(fishArray[row], comment: "") 
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fishImageOutlet.image = UIImage(named: fishArray[row])
    }
    
    // TODO: reload shared
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "NewChar":
            playButtonAction()
           
            if let vc = segue.destination as? Game {
                CoreDataStack.shared.update()
                let row = CoreDataStack.shared.fish.count-1
                    vc.fish = CoreDataStack.shared.fish[row] as? Fish
            }
        default:
            print("pass")
        }
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
