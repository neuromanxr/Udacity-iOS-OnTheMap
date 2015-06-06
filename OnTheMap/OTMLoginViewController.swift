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
        
        // set up the delegates
        facebookLoginButton.delegate = facebookDelegate
        emailTextField.delegate = loginTextFieldDelegate
        passwordTextField.delegate = loginTextFieldDelegate
        
        // assign tags to text fields
        emailTextField.tag = textFieldType.email.rawValue
        passwordTextField.tag = textFieldType.password.rawValue
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            println("There's a current access token \(FBSDKAccessToken.currentAccessToken().tokenString)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: UIButton) {
        
        if !emailTextField.text.isEmpty || !passwordTextField.text.isEmpty {
            OTMClient.sharedInstance().authenticateWithViewController(self, completionHandler: { (success, errorString) -> Void in
                if success {
                    println("login success")
                    // tell map view we are logged in, so load the student locations
                    self.delegate?.didLoggedIn(true)
                    
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
