//
//  TableViewController.swift
//  Pet_Add_One
//
//  Created by Jennifer Dong  on 11/26/19.
//  Copyright © 2019 Jennifer Dong . All rights reserved.
//

import UIKit
import CoreData

class Players: UITableViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playersBar: UINavigationItem!
    @IBOutlet weak var deleteButton: UIButton!
    var fish: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Fish"
        playersBar.title = NSLocalizedString("Players", comment: "")
        backButton.setTitle(NSLocalizedString("Back", comment: ""), for: .normal)
        deleteButton.setTitle(NSLocalizedString("Delete", comment: ""), for: .normal)
        CoreDataStack.shared.update()
        tableView.reloadData()
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        setEditing(!isEditing, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "GameSegue":
            if let vc = segue.destination as? Game {
                if let indexPath = tableView.indexPathForSelectedRow {
                    vc.fish = CoreDataStack.shared.fish[indexPath.row] as? Fish
                }
            }
        default:
            print("pass")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("P: \(CoreDataStack.shared.fish.count)")
        return CoreDataStack.shared.fish.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FishCell", for: indexPath) as! FishCell
        let item = CoreDataStack.shared.fish[indexPath.row]
        cell.fishName?.text = item.value(forKeyPath: "name") as? String
        cell.fishType?.text = item.value(forKeyPath: "type") as? String
        let score = item.value(forKeyPath: "score") as! Int16
        cell.Score?.text = String(score)
        let image = item.value(forKeyPath: "image") as? String
        cell.fishImage.image = UIImage(named: image ?? "Fish")
        cell.nameLabel.text = NSLocalizedString("Name", comment: "")
        cell.typeLabel.text = NSLocalizedString("Type", comment: "")
        cell.scoreLabel.text = NSLocalizedString("Score", comment: "")
        return cell
    }
    
    // disallow swipe deletion when not in edit mode
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return tableView.isEditing ? .delete : .none
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let fish = CoreDataStack.shared.fish[indexPath.row] as? Fish {
                deletionAlert(title: fish.name!) { _ in
                    CoreDataStack.shared.deleteItem(item: fish)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func deleteEntry(entry: Fish) {
        let context = getObjectContext()
        if let _ = CoreDataStack.shared.fish.firstIndex(of: entry)  {
            context.delete(entry)
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not delete the item. \(error), \(error.userInfo)")
            }
        }
        CoreDataStack.shared.update()
        self.tableView.reloadData()
    }
    
    func getObjectContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Deletion Alert
    
    func deletionAlert(title: String, completion: @escaping (UIAlertAction) -> Void) {
        print(title)
        let alertMsg = String(format: NSLocalizedString("Are you sure you want to delete %@? This cannot be undone!", comment: ""), title)
        
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: alertMsg, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: completion)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler:nil)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        /*
         **  In this case we need a source for the popover as well, but don't have a handy UIBarButtonItem.
         **  As alternative we therefore use the sourceView/sourceRect combination and specify a rectangel
         **  centered in the view of our viewController.
         */
        alert.popoverPresentationController?.permittedArrowDirections = []
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: 0, height: 0)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Core Data
    
    func updateFromModel() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Fish")
        
        do {
            fish = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch requested media. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onToggleEditing(_ sender: UIBarButtonItem) {
        setEditing(!isEditing, animated: true)
    }
    
//    func addAgain(entry: Fish, name: String){
//        // 1 make the alert that houses the alert actions
//        let alert = UIAlertController(title: "New Media", message: "Add a entry", preferredStyle: .alert)
//
//        // 2
//        // if we had a cancel action we would define it like so:
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//
//        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
//            // if we had a second text field we add it here and use subscript notation like so
//            guard let titleTextField = alert.textFields?[0],
//                let title = titleTextField.text else { return }
//
//            // if we had a second text field we add it here and use subscript notation like so
//            guard let passwordTextField = alert.textFields?[1],
//                let password = passwordTextField.text else { return }
//            // secure here?
//
//            self.saveEntry(title: name, password: password)
//            //self.saveSong(title: title)
//            self.updateFromModel()
//            self.tableView.reloadData()
//        }
//
//        alert.addTextField(configurationHandler: { textField in
//            textField.text = name
//            textField.isUserInteractionEnabled = false
//        })
//        // if we wanted a 2nd text field we would add it here like so:
//        alert.addTextField(configurationHandler: { textField in
//            textField.placeholder = "Password"
//            textField.isSecureTextEntry = true
//        })
//
//        alert.addAction(saveAction)
//
//        // if we had a cancel action we would add it here:
//        alert.addAction(cancelAction)
//
//        // 4 There is no step 4 for this simple alert : )
//
//        // 5 present the dialog
//        present(alert, animated: true)
//
//    }
    
//    @IBAction func onAddBtn(_ sender: UIBarButtonItem?) {
        
//        // 1 make the alert that houses the alert actions
//        let alert = UIAlertController(title: "New Media", message: "Add a entry", preferredStyle: .alert)
//
//        // 2
//        // if we had a cancel action we would define it like so:
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//
//        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
//            guard let titleTextField = alert.textFields?[0],
//                let title = titleTextField.text else { return }
//
//            // if we had a second text field we add it here and use subscript notation like so
//            guard let passwordTextField = alert.textFields?[1],
//                let password = passwordTextField.text else { return }
//            // secure here?
//
//            // if we were processing artist as well we would write saveSong like so instead:
//            self.saveEntry(title: title, password: password)
//            //self.saveSong(title: title)
//            self.updateFromModel()
//            self.tableView.reloadData()
//
//            // Displaying the pop up for low strength
//            let item = self.fish[self.fish.count - 1]
//            //print(item)
//
//            let strength = item.value(forKeyPath: "strength") as! Int
//
//            if strength <= 2 {
//                let update = UIAlertController(title: "Update Password", message: "Password strength is low", preferredStyle: .alert)
//                //self.present(update, animated: true)
//
//                update.addAction(UIAlertAction(title: "Auto-generate Password", style: UIAlertAction.Style.default, handler: { action in
//
//                    // generate password
//                    let str = self.autoGenerate()
//                    // delete entry
//                    self.deleteEntry(entry: item as! Entry)
//
//                    // save entry
//                    self.saveEntry(title: title, password: str)
//                    //let name = Entry.value(forKey: "title")
//
//                    // add to table view ...
//                    self.updateFromModel()
//                    self.tableView.reloadData()
//                }))
//
//                update.addAction(UIAlertAction(title: "Re-enter Password", style: UIAlertAction.Style.default, handler: { action in
//
//                    // delete entry
//                    self.deleteEntry(entry: item as! Entry)
//
//                    // re-enter -> save new entry
//                    //titleTextField.isUserInteractionEnabled = false
//                    //self.onAddBtn(nil)
//                    self.addAgain(entry: item as! Entry, name: title)
//
//                    // add to table view ...
//                    self.updateFromModel()
//                    self.tableView.reloadData()
//
//                }))
//
//                update.addAction(UIAlertAction(title: "Keep Password", style: UIAlertAction.Style.default, handler: nil))
//
//                self.present(update, animated: true, completion: nil)
//            }
//        }
        
        // 3 adding ui elements AND actions to the alert. Adding UI elements is not that common.
//        alert.addTextField(configurationHandler: { textField in
//            textField.placeholder = "Title"
//        })
//
//        // if we wanted a 2nd text field we would add it here like so:
//        alert.addTextField(configurationHandler: { textField in
//            textField.placeholder = "Password"
//            textField.isSecureTextEntry = true
//        })
//
//        alert.addAction(saveAction)
//
//        // if we had a cancel action we would add it here:
//        alert.addAction(cancelAction)
//
//        // 4 There is no step 4 for this simple alert : )
//
//        // 5 present the dialog
//        present(alert, animated: true)
    
    //}
    
    /*

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */*/

}
