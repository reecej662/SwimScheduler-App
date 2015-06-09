//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet var firstName: UITextField!
    
    @IBOutlet var lastName: UITextField!
    
    @IBAction func submit(sender: AnyObject) {
    
        if(lastName.text != "" || firstName.text != ""){
            
            var newClient = PFObject(className: "clients")
            newClient["firstName"] = firstName.text
            newClient["lastName"] = lastName.text
        
            newClient.saveInBackgroundWithBlock { (result, error) -> Void in
            
                if error != nil {
                    println(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

