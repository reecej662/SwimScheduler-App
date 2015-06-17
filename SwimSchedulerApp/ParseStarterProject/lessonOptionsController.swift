//
//  lessonOptions.swift
//  SwimScheduler
//
//  Created by Reece Jackson on 6/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

protocol lessonInfoDelegate {
    func backFromStudentSelect(message:String, name:String)
    func backFromClientSelect(message:String, name:String)
}

class selectStudentView: UITableViewController, UITextFieldDelegate /*,UIPickerViewDelegate, UIPickerViewDataSource*/ {

    // This is going to be the table where the person chooses the kid
    
    var studentIds = [""]
    var studentNames = [""]
    var clientId:String!
    
    @IBOutlet var studentTable: UITableView!
    
    var refresher: UIRefreshControl!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func refresh() {
        
        studentNames.removeAll(keepCapacity: true)
        studentIds.removeAll(keepCapacity: true)
        
        //refresher in middle of page while loading names
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var query = PFQuery(className: "students")
        query.whereKey("parent", equalTo: clientId)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let objects = objects {
                
                for object in objects {
                    
                    if(object["name"]! != nil) {
                        
                        if let objectId = object.objectId {
                            self.studentIds.append(objectId! as String)
                        }
                        
                        self.studentNames.append(object["name"] as! String)
                        
                    }
                }
                
                self.studentTable.reloadData()
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                //self.refresher.endRefreshing()
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentNames.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel!.text = studentNames[indexPath.row]
        return cell
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    var delegate:lessonInfoDelegate? = nil
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let name = studentNames[indexPath.row] as String
        
        self.delegate?.backFromStudentSelect(studentIds[indexPath.row], name: name)
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // handle delete (by removing the data from your array and updating the tableview)
            
            var deleteId = studentIds[indexPath.row]
            
            var query = PFQuery(className: "students")
            
            query.getObjectInBackgroundWithId(deleteId, block: { (object, error) -> Void in
                if error == nil && object != nil{
                    object!.deleteInBackground()
                } else {
                    println(error)
                }
            })
            
            removeLessonsForClientId(studentIds[indexPath.row])
            studentIds.removeAtIndex(indexPath.row)
            
            self.tableView.reloadData()
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
    
}


class selectClientView: TableViewController {
    
    var delegate:lessonInfoDelegate? = nil
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let name = firstNames[indexPath.row] as String + " " + lastNames[indexPath.row] as String
        
        self.delegate?.backFromClientSelect(clientIds[indexPath.row], name: name)
        navigationController?.popViewControllerAnimated(true)
    }
    
}
