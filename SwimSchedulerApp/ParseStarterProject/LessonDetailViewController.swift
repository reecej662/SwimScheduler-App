//
//  LessonDetailViewController.swift
//  SwimScheduler
//
//  Created by Reece Jackson on 6/17/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class LessonDetailViewController: UIViewController {

    @IBOutlet var clientName: UILabel!

    @IBOutlet var date: UILabel!
    @IBOutlet var studentName: UILabel!
    @IBOutlet var age: UILabel!
    @IBOutlet var instructorName: UILabel!
    
    var lessonId:String! = ""
    var client:String! = ""
    var time:String! = ""
    var student:String! = ""
    var studentAge:Int!
    var instructor:String! = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        println(lessonId)
        
        if lessonId != "" {
            println(lessonId)
            getInfo(lessonId)
            
            // Do any additional setup after loading the view.
            clientName.text = client
            date.text = time
            studentName.text = student
            //age.text = String(studentAge)
            instructorName.text = "Reece" //PFUser.currentUser()?.valueForKey("name")!
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getInfo(lessonId: String) {
        
        var query = PFQuery(className: "lessons")
        query.getObjectInBackgroundWithId(lessonId, block: { (object, error) -> Void in
            
            if object != nil && error == nil {
                
                println(object)
                var studentId = "TCvkomnaYa"//object?.valueForKey("student") as! String
                println(studentId)
                
                self.student = "TCvkomnaYa"
                
                
                var lessonDate = object!.valueForKey("date") as! NSDate
                
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                let stringDate: String = dateFormatter.stringFromDate(lessonDate)
                
                dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
                dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                let stringTime: String = dateFormatter.stringFromDate(lessonDate)
                
                self.time = stringDate + " " + stringTime
                
                if studentId != "" {
                    
                    var studentQuery = PFQuery(className: "students")
                    query.getObjectInBackgroundWithId(studentId, block: { (studentObject, error) -> Void in
                        
                        if studentObject != nil && error == nil {
                            
                            self.student = studentObject!.valueForKey("name") as! String
                            self.studentAge = studentObject!.valueForKey("age") as! Int
                            println(" We got fucking here at least")
                            
                        }
                        
                    })
                    
                }
                
                // Do any additional setup after loading the view.
                self.clientName.text = self.client
                self.date.text = self.time
                self.studentName.text = self.student
                //age.text = String(studentAge)
                self.instructorName.text = "Reece" //PFUser.currentUser()?.valueForKey("name")!
            }
            
        })
        
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
