//
//  ChangeNameController.swift
//  myFood
//
//  Created by Nick on 06/12/2020.
//  Copyright © 2020 Nikita Gulak. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChangeNameController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = currentName ?? ""
        navigationController?.navigationBar.tintColor = UIColor.systemGreen
    }
    
    // MARK: - Instance variables
    var currentName: String?
    @IBOutlet weak var textField: UITextField!

    
    // MARK: - Actions
    @IBAction func saveNameButton(_ sender: UIBarButtonItem) {
        if textField.text != "" {
            saveName(newName: textField!.text!)
            UserDefaults.standard.set(textField!.text! as String, forKey: "userName")
//            self.dismiss(animated: true, completion: nil)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.00)
    }
    
    //MARK: Saving to database
    func saveName(newName: String) {
        let databasePath: String = "Users/" + "\(String(describing: UserDefaults.standard.string(forKey: "userID")!))/" + "Account/Name"
        let ref = Database.database().reference().child(databasePath)
        ref.setValue(newName)
    }


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

}
