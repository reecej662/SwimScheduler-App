//
//  ClientInfoViewController.swift
//  SwimScheduler
//
//  Created by Reece Jackson on 6/9/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ClientInfoViewController: UIViewController {

    var clientId:String!

    @IBOutlet var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(clientId)
        
        var query = PFQuery(className: "clients")
        
        //put this into a refresh function to load once the data has been loaded
        if clientId != nil{
            
            query.getObjectInBackgroundWithId(clientId, block: { (object, error) -> Void in
            
                if let client = object {
                
                    let firstName = client["firstName"] as! String
                    let lastName = client["lastName"] as! String
                
                    self.name.text = firstName + " " + lastName
                
                } else {
                
                    println(error)
                
                }
            
            })
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
