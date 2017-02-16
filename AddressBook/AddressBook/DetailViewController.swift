//
//  DetailViewController.swift
//  AddressBook
//
//  Created by Gary Shirk on 2/9/17.
//  Copyright © 2017 Gary Shirk. All rights reserved.
//

import CoreData
import UIKit

protocol DetailViewControllerDelegate {
    func didEditContact(controller: DetailViewController)
}

class DetailViewController: UIViewController, AddEditViewControllerDelegate {
    
    var delegate:DetailViewControllerDelegate!
    var detailItem:Contact!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if detailItem != nil {
           displayContact()
        }
    }
    
    func displayContact() {
        
        if let first = detailItem.firstname, let last = detailItem.lastname {
            self.navigationItem.title = first + " " + last
        }
        
        //self.navigationItem.title = detailItem.firstname! +  " " + detailItem.lastname!
        
        emailTextField.text = detailItem.email
        phoneTextField.text = detailItem.phone
        streetTextField.text = detailItem.address
        cityTextField.text = detailItem.city
        stateTextField.text = detailItem.state
        zipTextField.text = detailItem.zip
        
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let controller = storyBoard.instantiateViewController(withIdentifier: "AddEditVC") as! AddEditViewController
        
        controller.navigationItem.title = "Edit Contact"
        controller.delegate = self
        controller.isEditingContact = true
        controller.contact = detailItem
        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func didSaveContact(controller: AddEditViewController) {
        displayContact()
        
        //_ = self.navigationController?.popViewController(animated: true)
        //_ = self.navigationController?.popToRootViewController(animated: true)
//        if let navController = self.navigationController {
//            navController.popViewController(animated: true)
//        }
        
        
        delegate.didEditContact(controller: self)
        
//        self.navigationController?.popToViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
//        
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count -2] animated:YES];

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "showEditContact" {
            let controller = (segue.destination as! UINavigationController).topViewController as! AddEditViewController
            controller.navigationItem.title = "Edit Contact"
            controller.delegate = self
            controller.isEditingContact = true
            controller.contact = detailItem
            controller.navigationItem.title = "Edit Contact"
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        
        }
    }
}

