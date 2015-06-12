//
//  NewLessonViewController.swift
//  SwimScheduler
//
//  Created by Reece Jackson on 6/11/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class NewLessonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //yo make this only choose between availiable lengths like 30 mins or whatever

    @IBOutlet var date: UIDatePicker!
    @IBOutlet var lessonOptionsTable: UITableView!
    
    var lessonOptions = ["Client", "Length"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lessonOptionsTable.delegate = self
        lessonOptionsTable.dataSource = self
        
    }
    
    @IBAction func submit(sender: AnyObject) {
        
        //when the submit button is pressed set the values and save the new lesson
        var lesson = PFObject(className: "lessons")
        lesson["date"] = date.date
        lesson["clientId"] = "Implement later"
        lesson["instructorId"] = PFUser.currentUser()?.objectId
        
        lesson.saveInBackground()
        
        performSegueWithIdentifier("doDopeShit", sender: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Functions for the table view below the date picker
    
    func numberOfSectionsInTableView(tableView:UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section
        return lessonOptions.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = lessonOptionsTable.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        cell.textLabel!.text = lessonOptions[indexPath.row]
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
        
    }

    // Override to support conditional editing of the table view.
   func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
    }
    
    func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lessonOptionsTable.deselectRowAtIndexPath(indexPath, animated: true)
        
        //selectedClient = clientIds[indexPath.row]
        //self.performSegueWithIdentifier("clientInfo", sender: self)
    
        if indexPath.row == 0 {
            performSegueWithIdentifier("chooseClient", sender: self)
            
        } else if indexPath.row == 1 {
            performSegueWithIdentifier("chooseTime", sender: self)
            
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "clientInfo") {
            
            var clientPage = segue.destinationViewController as! ClientInfoViewController
            
            //clientPage.clientId = selectedClient
            
        } else if segue.identifier == "chooseClient" {
            
            
            
        }
    }
    


}
