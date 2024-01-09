//
//  InfoViewController.swift
//  FinalExamReview
//
//  Created by english on 2023-12-18.
//

import UIKit

protocol InfoViewControllerDelegate {
    func refreshTable()
}

class InfoViewController: UIViewController {

    var guest : Guest?
    var delegate: InfoViewControllerDelegate?
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtRoomNumber: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblNavBar: UINavigationItem!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let entityName = Guest.entity().name!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if guest != nil {
            txtName.text = guest!.name
            txtRoomNumber.text = String(guest!.room)
            lblNavBar.title = "Showing"
            
        } else {
            btnDelete.isHidden = true
            lblNavBar.title = "Adding"
        }

    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        if txtName.text!.count < 5 || txtName.text!.count > 25 {
            Toast.ok(view: self, title: "Ooops", message: "The name must have between 5 to 25 characters.")
            return
        }
        
        if !txtRoomNumber.hasText{
            Toast.ok(view: self, title: "Ooops", message: "The room number can not be empty")
            return
        }

        if Int(txtRoomNumber.text!) ?? 0 < 1000 || Int(txtRoomNumber.text!) ?? 0 > 1999{
            Toast.ok(view: self, title: "Ooops", message: "The room number must be between 1000 and 1999.")
            return
        }
        
        if guest == nil {
            
            if let existingGuest = (CoreDataProvider.findOne(context: self.context, entityName: entityName, key: "name", value: txtName.text!) as? Guest) {
                Toast.ok(view: self, title: "Ooops", message: "\(existingGuest.name!) is already inserted")
                return
            }
            
            guest = Guest(context: self.context)
        }

        guest!.name = txtName.text!
        guest!.room = Int32(txtRoomNumber.text!)!

        do{
            try CoreDataProvider.save(context: self.context)
        } catch {
            Toast.ok(view: self, title: "Oops", message: error.localizedDescription)
        }
        
        if delegate != nil {
            delegate!.refreshTable()
        }
        
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnDeleteTouchUpInside(_ sender: Any) {
        do {
            try CoreDataProvider.delete(context: self.context, objectToDelete: self.guest!)
        } catch {
            Toast.ok(view: self, title: "Ooops", message: error.localizedDescription)
        }
        
        if delegate != nil {
            delegate!.refreshTable()
        }
        
        navigationController?.popViewController(animated: true)
    }
}
