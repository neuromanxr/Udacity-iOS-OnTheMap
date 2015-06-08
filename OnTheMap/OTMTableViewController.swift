//
//  OTMTableViewController.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 5/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit

class OTMTableViewController: UITableViewController, OTMBarButtonDelegate, LoginViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        OTMClient.sharedInstance().delegate = self
        OTMClient.sharedInstance().setupNavigationItem(self.navigationItem)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateStudentLocations", name: OTMClient.Constants.NotificationReload, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loggedOut", name: OTMClient.Constants.NotificationLoggedOut, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loggedIn", name: OTMClient.Constants.NotificationLoggedIn, object: nil)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showInfoPost", name: OTMClient.Constants.NotificationShowInfoPost, object: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationReload, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationLoggedOut, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationLoggedIn, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationShowInfoPost, object: nil)
    }
    
    func barButtonShowLogin() {
        let loginView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView") as! OTMLoginViewController
        loginView.delegate = self
        self.presentViewController(loginView, animated: false, completion: nil)
    }
    
    func barButtonShowInfoPost() {
        println("barButton: info post presented in table view")
        let infoPostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InfoPostView") as! OTMInfoPostViewController
        infoPostViewController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        self.presentViewController(infoPostViewController, animated: true, completion: nil)
    }
    
    func didLoggedIn(status: Bool) {
        // if we are logged in, load the student locations
        if status {
            println("logged in")
        } else {
            println("not logged in, don't get student locations")
        }
    }
    
//    func barButtonLogout() {
//        println("barButton: logout in table view")
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.navigationItem.leftBarButtonItem?.enabled = false
//        })
//    }
    
    // MARK: - Student Locations
    func updateStudentLocations() {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            // update UI
            println("updated the ui")
            
            self.tableView.reloadData()
        })
    }
    
    func loggedOut() -> Void {
        println("barButton: logout in table view")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.navigationItem.leftBarButtonItem?.enabled = false
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
    
//    func showInfoPost() {
//        let infoPostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InfoPostView") as! OTMInfoPostViewController
//        infoPostViewController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
//        self.presentViewController(infoPostViewController, animated: true, completion: nil)
//    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        println("Student Locations count \(OTMClient.sharedInstance().studentLocations.count)")
        
        return OTMClient.sharedInstance().studentLocations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "StudentInfo"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! OTMTableViewCell

        // Configure the cell...
        let studentObject = OTMClient.sharedInstance().studentLocations[indexPath.row]
        
        cell.studentLabel.text = studentObject.studentName
        cell.pinImage.image = UIImage(named: "")

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
