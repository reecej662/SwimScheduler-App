//
//  TableViewController.swift
//  SwimScheduler
//
//  Created by Reece Jackson on 6/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {
    
    var clientIds = [""]
    var firstNames = [""]
    var lastNames = [""]
    var selectedClient:String!
    
    @IBAction func newLesson(sender: AnyObject) {
        
        performSegueWithIdentifier("newLesson", sender: self)
        
    }
    
    var refresher: UIRefreshControl!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func refresh() {
        
        firstNames.removeAll(keepCapacity: true)
        lastNames.removeAll(keepCapacity: true)
        clientIds.removeAll(keepCapacity: true)

        //refresher in middle of page while loading names
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var query = PFQuery(className: "clients")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let objects = objects {
                
                for object in objects {
                    
                    if(object["firstName"]! != nil) {
                        
                        if let objectId = object.objectId {
                                self.clientIds.append(objectId! as String)
                        }
                        
                        self.firstNames.append(object["firstName"] as! String)
                        self.lastNames.append(object["lastName"] as! String)

                    }
                }
                
                self.tableView.reloadData()
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
                self.refresher.endRefreshing()
                
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        super.viewDidLoad()
        
        var currentUser = PFUser.currentUser()
        
        if currentUser?.objectId != nil {
            
            refresher = UIRefreshControl()
            
            refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
            
            refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
            
            self.tableView.addSubview(refresher)
            
            refresh()
            
        } else {
            
            self.performSegueWithIdentifier("login", sender: self)
            
            println("Nobody is logged in")
            
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
        return firstNames.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel!.text = firstNames[indexPath.row] + " " + lastNames[indexPath.row]
        return cell
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // handle delete (by removing the data from your array and updating the tableview)
            
            var deleteId = clientIds[indexPath.row]
            
            var query = PFQuery(className: "clients")
            
            query.getObjectInBackgroundWithId(deleteId, block: { (object, error) -> Void in
                if error == nil && object != nil{
                    object!.deleteInBackground()
                } else {
                    println(error)
                }
            })
            
            removeLessonsForClientId(clientIds[indexPath.row])
            clientIds.removeAtIndex(indexPath.row)
            firstNames.removeAtIndex(indexPath.row)
            lastNames.removeAtIndex(indexPath.row)
            
            self.tableView.reloadData()
        } else if editingStyle == UITableViewCellEditingStyle.Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    func removeLessonsForClientId(clientId: String) {
        
        var query = PFQuery(className: "lessons")
        query.whereKey("clientId", equalTo: clientId)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if error == nil && objects != nil{
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        object.deleteInBackground()
                    }
                }
                
            }
        }
        
    }
    
    /*
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        

        
    }
    */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedClient = clientIds[indexPath.row]
        self.performSegueWithIdentifier("clientInfo", sender: self)
    }

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "clientInfo") {
            
            var clientPage = segue.destinationViewController as! ClientInfoViewController
            
            clientPage.clientId = selectedClient
            
        }
    }


}
