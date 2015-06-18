//
//  MyLessonTableViewController.swift
//  SwimScheduler
//
//  Created by Reece Jackson on 6/17/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class MyLessonTableViewController: UITableViewController {

    var userId = "" //PFUser.currentUser()?.objectId
    var lessonIds = [""]
    var lessonDates = [""]
    var lessonTimes = [""]
    
    /*@IBAction func newLesson(sender: AnyObject) {
        
        performSegueWithIdentifier("newLesson", sender: self)
        
    }*/
    
    var refresher: UIRefreshControl!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func logout(sender: AnyObject) {
        
        PFUser.logOut()
        performSegueWithIdentifier("logout", sender: self)
        
    }
    
    func refresh() {
        
        //refresher in middle of page while loading names
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

        self.lessonDates.removeAll(keepCapacity: true)
        self.lessonTimes.removeAll(keepCapacity: true)
        self.lessonIds.removeAll(keepCapacity: true)
        
        self.getLessonsWithId(userId)
        
        //self.tableView.reloadData()

        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        self.refresher.endRefreshing()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(userId)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if PFUser.currentUser() != nil {
            
            userId = PFUser.currentUser()!.objectId!
            
            refresher = UIRefreshControl()
            
            refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
            
            refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
            
            self.tableView.addSubview(refresher)
            
            refresh()

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section
        return lessonDates.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        if indexPath.row <= lessonDates.count && indexPath.row <= lessonTimes.count {
            cell.textLabel!.text = String(lessonDates[indexPath.row])
            cell.detailTextLabel!.text = String(lessonTimes[indexPath.row])
        }
        
        return cell
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            var deleteId = lessonIds[indexPath.row]
            
            var query = PFQuery(className: "lessons")
            
            query.getObjectInBackgroundWithId(deleteId, block: { (object, error) -> Void in
                if error == nil && object != nil{
                    object!.deleteInBackground()
                } else {
                    //println(error)
                }
            })
            
            lessonIds.removeAtIndex(indexPath.row)
            lessonDates.removeAtIndex(indexPath.row)
            lessonTimes.removeAtIndex(indexPath.row)
            
            self.tableView.reloadData()
            
            
        }
    }
    
    /*
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    
    
    
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation

    
    func getLessonsWithId(client: String) {
        
        activityIndicator.startAnimating()

        var query = PFQuery(className: "lessons")
        query.whereKey("instructorId", equalTo: client)
        query.orderByAscending("date")
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if error == nil && objects != nil{
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        var lessonDate = object.valueForKey("date") as! NSDate
                        
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                        let stringDate: String = dateFormatter.stringFromDate(lessonDate)
                        
                        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
                        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                        let stringTime: String = dateFormatter.stringFromDate(lessonDate)
                        
                        self.lessonIds.append(object.objectId!)
                        self.lessonTimes.append(stringTime)
                        self.lessonDates.append(stringDate)
                    }
                    
                    self.tableView.reloadData()
                    
                    self.activityIndicator.stopAnimating()
                    
                }
            }
        }
    }
}
