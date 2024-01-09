//
//  ViewController.swift
//  FinalExamReview
//
//  Created by english on 2023-11-28.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtLogin: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnLoginTouchUpInside(_ sender: Any) {
        let username = txtLogin.text
        let password = txtPassword.text
        
        if (username!.count < 2){
            Toast.ok(view: self, title: "Error", message: "The Login must be at least two chars length!")
        }
        else if (password != "2234126"){
            Toast.ok(view: self, title: "Error", message: "The Password must be my student number. Hint: 2234126")
        }
        else {
            performSegue(withIdentifier: Segue.toListViewController, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.toListViewController{
            (segue.destination as! ListViewController).login = txtLogin.text!
        }
    }
    
}

