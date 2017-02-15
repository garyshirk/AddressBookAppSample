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
    
    @IBOutlet var textFields: [UITextField]!
    
    
    var delegate: AddEditViewControllerDelegate!
    var isEditingContact: Bool!
    var contact: Contact?
    
    private let fieldNames = ["firstname", "lastname", "email", "phone", "address", "city", "state", "zip"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for textField in textFields {
            textField.delegate = self
        }
        
        if isEditingContact == true {
            for i in 0..<textFields.count {
                if let value: Any =
                    contact?.value(forKeyPath: fieldNames[i]) {
                    textFields[i].text = (value as AnyObject).description
                }
            }
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: Notification) {
        
        // Didn't implement what the sample said because textfield seem to scroll perfectly without 
        // trying to animate them with the keyboard as is done below
        
//        let userInfo = notification.userInfo
//        let frame = userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
//        let size = frame.cgRectValue.size
//        
//        // Get duration of keyboard's slide-in animation
//        //let animationTime = (userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).doubleValue!
//        let animationTime = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
//        let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
//        
//        UIView.animate(withDuration: TimeInterval(animationTime), delay: 0, options: [UIViewAnimationOptions(rawValue: UInt(curve))], animations: {
//            var insets = self.tableView.contentInset
//            insets.bottom = size.height
//            self.tableView.contentInset = insets
//            self.tableView.scrollIndicatorInsets = insets
//        }, completion: nil)
        
    }
    
    func keyboardWillHide(notification: Notification) {
        var insets = self.tableView.contentInset
        insets.bottom = 0
        self.tableView.contentInset = insets
        self.tableView.scrollIndicatorInsets = insets
    }
    

    @IBAction func saveButtonPressed(_ sender: Any) {
        if (textFields[0].text?.isEmpty)! || (textFields[1].text?.isEmpty)! {
            // Alert dialog
            let alert = UIAlertController(title: "Error", message: "First and last names are required", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(okAction)
            present(alert, animated: true)
        } else {
            for i in 0..<fieldNames.count {
                let fieldName = (!(textFields[i].text?.isEmpty)! ? textFields[i].text : nil)
                self.contact?.setValue(fieldName, forKey: fieldNames[i])
            }
        }
        
        self.delegate.didSaveContact(controller: self)
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
