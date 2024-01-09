//
//  MainViewController.swift
//  FinalExamReview
//
//  Created by english on 2023-11-28.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InfoViewControllerDelegate {

    var login : String?
    var selectedRow : Int?
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // this context var works like the "database connection".
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let entityName = Guest.entity().name!

    override func viewDidLoad() {
        super.viewDidLoad()
        lblLogin.text = login
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataProvider.all(context: context, entityName: entityName).count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let guest = (CoreDataProvider.all(context: context, entityName: entityName) as? [Guest])![indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = guest.name
        
        cell.selectionStyle = .none
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        
        performSegue(withIdentifier: Segue.toInfoViewController, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! InfoViewController
        
        if segue.identifier == Segue.toInfoViewController {
            
            destination.guest = (CoreDataProvider.all(context: self.context, entityName: entityName) as! [Guest])[self.selectedRow!]
        }

        destination.delegate = self
    }
    
    @IBAction func btnRefreshTapped(_ sender: Any) {
        refreshTable()
    }
    
    func refreshTable() {
        tableView.reloadData()
    }

}
