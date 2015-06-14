//
//  lessonOptions.swift
//  SwimScheduler
//
//  Created by Reece Jackson on 6/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

protocol lessonInfoDelegate {
    func backFromLength(message:Int)
    func backFromClientSelect(message:String, name:String)
}

class lessonOptionsController: UIViewController, UITextFieldDelegate /*,UIPickerViewDelegate, UIPickerViewDataSource*/ {

    @IBOutlet var length: UITextField!
    
    var delegate:lessonInfoDelegate? = nil

    override func viewDidLoad() {

        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        length.delegate = self
        length.becomeFirstResponder()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        length.resignFirstResponder()
        
        var text = length.text
        let lengthNum:Int? = text.toInt()
        
        if lengthNum != nil {
        
            self.delegate?.backFromLength(lengthNum!)
            navigationController?.popViewControllerAnimated(true)
            
        } else {
            
            let alertController = UIAlertController(title: "Error", message: "Enter a valid number", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }

        return true
    }

}

class selectClientView: TableViewController {
    
    var delegate:lessonInfoDelegate? = nil
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let name = firstNames[indexPath.row] as String + " " + lastNames[indexPath.row] as String
        println(name)
        
        self.delegate?.backFromClientSelect(clientIds[indexPath.row], name: name)
        navigationController?.popViewControllerAnimated(true)
    }
    
}

