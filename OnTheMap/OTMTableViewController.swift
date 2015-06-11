//
//  OTMTableViewController.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 5/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

class OTMTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        OTMClient.sharedInstance().setupNavigationItem(self.navigationItem)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateStudentLocations", name: OTMClient.Constants.NotificationReload, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loggedOut", name: OTMClient.Constants.NotificationLoggedOut, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loggedIn", name: OTMClient.Constants.NotificationLoggedIn, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationReload, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationLoggedOut, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationLoggedIn, object: nil)

    }
    
    // MARK: - Student Locations
    func updateStudentLocations() {
        
        println("loading student data")
        OTMClient.sharedInstance().getStudentLocations { (result, error) -> Void in
            
            if let result = result {
                // got the student locations
                println("got student locations")
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // update UI
                    println("updated the ui")
                    
                    self.tableView.reloadData()
                })
                
            } else {
                // couldn't get the student locations
                println("didn't get student locations \(error)")
                let alertController = OTMClient.sharedInstance().alertControllerWithTitle("Student Information", message: "Didn't get the student info", actionTitle: "OK")
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func loggedOut() -> Void {
        println("barButton: logout in table view")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in

            OTMClient.sharedInstance().swapLeftBarButton(barButtonType.login, item: self.navigationItem)
        })
    }
    
    func loggedIn() -> Void {
        // logged in, change the button to logout
        println("barButton: logged out in map view")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            OTMClient.sharedInstance().swapLeftBarButton(barButtonType.logout, item: self.navigationItem)
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var studentCount: Int?
        if let studentArray = OTMStudentData.sharedInstance().studentObjects {
            studentCount = studentArray.count
        } else {
            studentCount = 0
        }
        
        println("Student Locations count \(OTMStudentData.sharedInstance().studentObjects!.count)")
        
        return studentCount!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "StudentInfo"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! OTMTableViewCell

        var studentObject: OTMStudentInformation?
        if let studentArray = OTMStudentData.sharedInstance().studentObjects {
            studentObject = studentArray[indexPath.row]
            // Configure the cell...
            cell.studentLabel.text = studentObject!.studentName
            cell.pinImage.image = UIImage(named: "pin")
            
        } else {
            studentObject = nil
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var studentObject: OTMStudentInformation?
        if let studentArray = OTMStudentData.sharedInstance().studentObjects {
            studentObject = studentArray[indexPath.row]
            
            let studentLink = studentObject!.studentLink
            let studentURL = NSURL(string: studentLink)
            UIApplication.sharedApplication().openURL(studentURL!)
        } else {
            studentObject = nil
        }
    }

}
