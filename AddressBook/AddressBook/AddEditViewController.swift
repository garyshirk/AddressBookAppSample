//
//  AddEditViewController.swift
//  AddressBook
//
//  Created by Gary Shirk on 2/9/17.
//  Copyright © 2017 Gary Shirk. All rights reserved.
//

import CoreData
import UIKit

protocol AddEditViewControllerDelegate {
    func didSaveContact(controller: AddEditViewController)
}

class AddEditViewController: UITableViewController, UITextFieldDelegate {
    
    var delegate: AddEditViewControllerDelegate!
    var isEditingContact: Bool!
    var contact: Contact?
    
    
    @IBOutlet weak var nameTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // Listen for keyboard show/hide notifications
        let notiCenter = NotificationCenter.default
        notiCenter.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        notiCenter.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Listen for keyboard show/hide notifications
        let notiCenter = NotificationCenter.default
        notiCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notiCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: Notification) {
        
        let userInfo = notification.userInfo
        let frame = userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let size = frame.cgRectValue.size
        
        // Get duration of keyboard's slide-in animation
        let animationTime = (userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).doubleValue!
        
        // Scroll self.tableView so selected textfield is above keyboard
        UIView.animate(withDuration: animationTime, animations: {
            var insets = self.tableView.contentInset
            insets.bottom = size.height
            self.tableView.contentInset = insets
            self.tableView.scrollIndicatorInsets = insets
        })
        
    }
    
    func keyboardWillHide(notification: Notification) {
        var insets = self.tableView.contentInset
        insets.bottom = 0
        self.tableView.contentInset = insets
        self.tableView.scrollIndicatorInsets = insets
    }
    
    

    @IBAction func saveButtonPressed(_ sender: Any) {
        print("save button pressed")
        if let del = delegate {
            del.didSaveContact(controller: self)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
