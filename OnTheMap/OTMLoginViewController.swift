//
//  OTMLoginViewController.swift
//  OnTheMap
//
//  Created by Kelvin Lee on 5/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

protocol LoginViewControllerDelegate {
    func didLoggedIn(status: Bool)
}

class OTMLoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    let facebookDelegate = OTMFacebookDelegate()
    let loginTextFieldDelegate = OTMLoginTextFieldDelegate()
    
    var delegate: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        
        // set up the delegates
        facebookLoginButton.delegate = facebookDelegate
        emailTextField.delegate = loginTextFieldDelegate
        passwordTextField.delegate = loginTextFieldDelegate
        
        // assign tags to text fields
        emailTextField.tag = textFieldType.email.rawValue
        passwordTextField.tag = textFieldType.password.rawValue
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dismiss", name: OTMClient.Constants.NotificationFacebookLoggedIn, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            println("There's a current access token \(FBSDKAccessToken.currentAccessToken().tokenString)")
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: OTMClient.Constants.NotificationFacebookLoggedIn, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupUI() {
        // set the email field background to semi-transparent and the placeholder text opaque
        self.emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 1.0)])
        
        self.passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 1.0)])
        
        // round out the login button
        self.loginButton.layer.cornerRadius = 5
        
        // get rid of rectangle corners
        self.facebookLoginButton.backgroundColor = UIColor.clearColor()
    }
    
    @IBAction func loginAction(sender: UIButton) {
        
        if !emailTextField.text.isEmpty && !passwordTextField.text.isEmpty {
            OTMClient.sharedInstance().email = self.emailTextField.text!
            OTMClient.sharedInstance().pass = self.passwordTextField.text!
            
            OTMClient.sharedInstance().authenticateWithViewController(self, completionHandler: { (success, errorString) -> Void in
                if success {
                    println("login success")
                    // tell map view we are logged in, so load the student locations
                    self.delegate?.didLoggedIn(true)
                    // logged in, change the left bar button to logout
                    NSNotificationCenter.defaultCenter().postNotificationName(OTMClient.Constants.NotificationLoggedIn, object: nil)
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    println("login error \(errorString)")
                    let alertController = OTMClient.sharedInstance().alertControllerWithTitle("Login", message: "Invalid Login!", actionTitle: "OK")
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
        } else {
            let alertController = OTMClient.sharedInstance().alertControllerWithTitle("Login", message: "Enter login and password!", actionTitle: "OK")
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    @IBAction func signUpAction(sender: UIButton) {
        let signUpURL = NSURL(string: "https://www.google.com/url?q=https%3A%2F%2Fwww.udacity.com%2Faccount%2Fauth%23!%2Fsignin&sa=D&sntz=1&usg=AFQjCNERmggdSkRb9MFkqAW_5FgChiCxAQ")
        UIApplication.sharedApplication().openURL(signUpURL!)
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
