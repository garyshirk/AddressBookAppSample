//
//  MasterViewController.swift
//  AddressBook
//
//  Created by Gary Shirk on 2/9/17.
//  Copyright © 2017 Gary Shirk. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, AddEditViewControllerDelegate, DetailViewControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    // configure pop over for UITableView on ipad
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem

//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        self.navigationItem.rightBarButtonItem = addButton
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            
            // Debug
            print("controllers at count-1: \((controllers[controllers.count-1] as! UINavigationController).topViewController)")
            
            
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            
            // Debug - detailViewController is nil here because above top controller is the InstructionViewController.
            // Because this sample tutorial wires both the MasterVC to both the DetailVC and the InstructionsVC,
            // I'm not sure how iOS deteremines which one is the top VC at this point of the app start
            if self.detailViewController == nil {
                print("vc is nil")
            } else {
                print("vc not nil")
            }
        }
        
        // For debug
        //makeAContact()
    }
    
    // For debug - make a fake contact
    func makeAContact() {
        let newEntity = self.fetchedResultsController.fetchRequest.entity!
        let newContact = Contact(entity: newEntity, insertInto: nil)
        newContact.firstname = "Harry"
        newContact.lastname = "Fakecontact"
        newContact.email = "myemail@nowhere.com"
        newContact.phone = "+1 555-555-5555"
        newContact.address = "123 Main St"
        newContact.city = "Anywhere"
        newContact.state = "PA"
        let context = self.fetchedResultsController.managedObjectContext
        context.insert(newContact)
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        displayFirstContactOrInstructions()
        
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        // Debug
//        let isSplitViewControllerCollapsed = self.splitViewController!.isCollapsed
//        
//        if isSplitViewControllerCollapsed {
//            self.clearsSelectionOnViewWillAppear = true
//        } else {
//            self.clearsSelectionOnViewWillAppear = false
//        }
        
        
        
    }
    
    func didSaveContact(controller: AddEditViewController) {
        
        
        let context = self.fetchedResultsController.managedObjectContext
        context.insert(controller.contact!)
        //_ = self.navigationController?.popToRootViewController(animated: true)
        
        // save context to store the new contact
        do {
            try context.save()
            
            // after saving, get row of new contact in section info from fetchedResultController,
            // select that row programmatically, and segue to contact DetailViewController
            let sectionInfo = (self.fetchedResultsController.sections![0]) as NSFetchedResultsSectionInfo
            let arrayOfContactObjects = sectionInfo.objects as! Array<Contact>
            if let row = arrayOfContactObjects.index(of: controller.contact!) {
                let path = IndexPath(row: row, section: 0)
                tableView.selectRow(at: path, animated: true, scrollPosition: .middle)
                //performSegue(withIdentifier: "showContactDetail", sender: nil)
            }
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func didEditContact(controller: DetailViewController) {
        // user edited an existing contact, need to save here
        let context = self.fetchedResultsController.managedObjectContext
        
        // save context to store the new contact
        do {
            try context.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

    }
    
    // if the UISplitViewController is not collapsed, 
    // select first contact or display InstructionsViewController
    func displayFirstContactOrInstructions() {
        if let splitViewController = self.splitViewController {
            if !(splitViewController.isCollapsed) {
                // select and display first contact if is one
                if self.tableView.numberOfRows(inSection: 0) > 0 {
                    let indexPath = NSIndexPath(row: 0, section: 0)
                    self.tableView.selectRow(at: indexPath as IndexPath, animated: false, scrollPosition: UITableViewScrollPosition.top)
                    self.performSegue(withIdentifier: "showContactDetail", sender: self)
                } else {
                    self.performSegue(withIdentifier: "showInstructions", sender: self)
                }
            } else {
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        let context = self.fetchedResultsController.managedObjectContext
        let newContact = Contact(context: context)
             
        // If appropriate, configure the new managed object.
        newContact.firstname = "test"

        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    
    @IBAction func editButtonPressed(_ sender: Any) {
        // create new contact item that is not yet managed
        let newEntity = self.fetchedResultsController.fetchRequest.entity!
        let newContact = Contact(entity: newEntity, insertInto: nil)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "AddEditVC") as! AddEditViewController
        
        controller.navigationItem.title = "Add Contact"
        controller.delegate = self
        controller.isEditingContact = false
        controller.contact = newContact
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showContactDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // get contact for selected cell
                let selectedContact = self.fetchedResultsController.object(at: indexPath) as Contact
                
                print("selected contact firstname: \(selectedContact.firstname)")
                
                // configure DetailViewController
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.delegate = self
                controller.detailItem = selectedContact
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        
        } else {
            if segue.identifier == "showAddContact" {
                // create new contact item that is not yet managed
                let newEntity = self.fetchedResultsController.fetchRequest.entity!
                let newContact = Contact(entity: newEntity, insertInto: nil)
                
                // configure the AddEditViewController
                let controller = (segue.destination as! UINavigationController).topViewController as! AddEditViewController
                
                //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                //let controller = storyBoard.instantiateViewController(withIdentifier: "AddEditVC") as! AddEditViewController
                
                controller.navigationItem.title = "Add Contact"
                controller.delegate = self
                controller.isEditingContact = false
                controller.contact = newContact
                
                self.navigationController?.pushViewController(controller, animated: true)
                
               // self.present(controller, animated:true, completion:nil)
                
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contact = self.fetchedResultsController.object(at: indexPath)
        self.configureCell(cell, withContact: contact)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.delete(self.fetchedResultsController.object(at: indexPath))
                
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
            displayFirstContactOrInstructions()
        }
    }

    func configureCell(_ cell: UITableViewCell, withContact contact: Contact) {
        
        cell.textLabel!.text = contact.lastname ?? "lastname"
        cell.detailTextLabel!.text = contact.firstname ?? "firstname"
        
        print("contact firstname: \(contact.firstname)")
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<Contact> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let lastNameSortDescriptor = NSSortDescriptor(key: "lastname", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        let firstNameSortDescriptor = NSSortDescriptor(key: "firstname", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        
        fetchRequest.sortDescriptors = [lastNameSortDescriptor, firstNameSortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController<Contact>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                self.configureCell(tableView.cellForRow(at: indexPath!)!, withContact: anObject as! Contact)
            case .move:
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */

}

