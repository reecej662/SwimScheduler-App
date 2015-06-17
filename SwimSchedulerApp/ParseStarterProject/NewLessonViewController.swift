//
//  NewLessonViewController.swift
//  SwimScheduler
//
//  Created by Reece Jackson on 6/11/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class NewLessonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, lessonInfoDelegate {

    @IBOutlet var date: UIDatePicker!
    @IBOutlet var lessonOptionsTable: UITableView!
    @IBOutlet var lessonLength: UISegmentedControl!
    
    var lessonOptions = ["Client", "Student"]
    var lessonInfo = ""
    var clientId = ""
    var clientName = ""
    var studentId = ""
    var studentName = ""
    var length = 30
    
    var dateCorrection:NSTimeInterval = 0// -18000 //-5 hours
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lessonOptionsTable.delegate = self
        lessonOptionsTable.dataSource = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    
    }
    
    @IBAction func cancel(sender: AnyObject) {

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        
        var lesson = PFObject(className: "lessons")
        
        var lessonDate:NSDate = date.date
        lessonDate = lessonDate.dateByAddingTimeInterval(dateCorrection)
        
        if(clientId == "") {
            
            let alertController = UIAlertController(title: "Error", message: "Please select client", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                
            self.presentViewController(alertController, animated: true, completion: nil)
    
        } else {
        
            lesson["date"] = lessonDate
            lesson["clientId"] = clientId
            lesson["instructorId"] = PFUser.currentUser()?.objectId
            lesson["length"] = length
        
            lesson.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error != nil {
                    
                    let alertController = UIAlertController(title: "Error", message: "Could not save lesson", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
            })
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Functions for the table view below the date picker
    
    func numberOfSectionsInTableView(tableView:UITableView) -> Int {

        return 1
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lessonOptions.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = lessonOptionsTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel!.text = lessonOptions[indexPath.row]
        
        if indexPath.row == 0 {
            cell.detailTextLabel!.text = clientName
        } else if indexPath.row == 1 {
            cell.detailTextLabel!.text = studentName
        }

        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
        
    }

    @IBAction func selectedLength(sender: AnyObject) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            length = 15
            break
        case 1:
            length = 30
            break
        case 2:
            length = 45
            break
        case 3:
            length = 60
            break
        default:
            break
        }  //Switch
        
    }
    
    // Override to support conditional editing of the table view.
   func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lessonOptionsTable.deselectRowAtIndexPath(indexPath, animated: true)
    
        if indexPath.row == 0 {
            performSegueWithIdentifier("chooseClient", sender: self)
            
        } else if indexPath.row == 1 {
           
            if(clientId == "") {
                
                let alertController = UIAlertController(title: "Error", message: "First please select client", preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            } else {
            
                performSegueWithIdentifier("chooseStudent", sender: self)
            
            }
            
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "chooseClient" {
            
            var client = segue.destinationViewController as! selectClientView
            client.delegate = self
            
        } else if segue.identifier == "chooseStudent" {
            
            var student = segue.destinationViewController as! selectStudentView
            student.clientId = clientId
            student.delegate = self
            
        }
    }
    
    func backFromStudentSelect(message: String, name: String) {
        self.studentId = message
        self.studentName = name
        lessonOptionsTable.reloadData()

    }
    
    func backFromClientSelect(message: String, name: String) {
        //self.clientName.removeAll(keepCapacity: true)
        self.clientId = message
        self.clientName = name
        lessonOptionsTable.reloadData()
    }
    
}
