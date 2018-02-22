//
//  ViewController.swift
//  pinkPageV2
//
//  Created by HG on 1/12/18.
//  Copyright © 2018 GGTECH. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import MessageUI
import Foundation

class WelcomeVC: UIViewController, UIAlertViewDelegate, MFMailComposeViewControllerDelegate {

    

    
    
    
    @IBAction func anonLogin(_ sender: Any) {
        
        
        Auth.auth().signInAnonymously(completion: { (user, error) in
            if error != nil {
                print(error as Any)
                return
            }
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
            // Alternative way to present the new view controller
            self.navigationController?.present(vc, animated: true, completion: nil)
            
        })
        
    }
    
    var authService = AuthService()
    
    
    
    @IBAction func signInAction(_ sender: Any) {
        signIn()
    }
    
    
    
   func signIn() {
        
        self.view.endEditing(true)
        let email = emailTextField.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!
        
        if finalEmail.isEmpty || password.isEmpty {
            
            let alertController = UIAlertController(title: "Error!", message: "Please fill in all the fields.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            
        }else {
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                if error == nil {
                    if let user = user {
                        print("\(user.displayName!) has been signed in")
                        
                        SVProgressHUD.dismiss()
                        
                        
                        self.loadTabBarController(atIndex: 2)
                        
                    }else{
                        SVProgressHUD.dismiss()
                        print("error")
                        
                        
                        
                        print(error?.localizedDescription as Any)
                    }
                }
                else {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "So Sorry.", message: "Incorrect Credentials", preferredStyle: .alert)
                    
                    
                    let action1 = UIAlertAction(title: "Contact Support", style: .default, handler: { (action) -> Void in
                        
                        let mailComposeViewController = self.configuredMailComposeViewController()
                        if MFMailComposeViewController.canSendMail() {
                            self.present(mailComposeViewController, animated: true, completion: nil)
                        } else {
                            self.showSendMailErrorAlert()
                        }
                        
                        print("ACTION 1 selected!")
                    })
                    
                    
                    
                    // Cancel button
                    let cancel = UIAlertAction(title: "Try Again", style: .default , handler: { (action) -> Void in })
                    
                    
                    // Add action buttons and present the Alert
                    alert.addAction(action1)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
            }
        }
        
    }
    
    var tabBarIndex: Int?
    
    //function that will trigger the **MODAL** segue
    private func loadTabBarController(atIndex: Int){
        self.tabBarIndex = atIndex
        self.performSegue(withIdentifier: "showTabBarTwo", sender: self)
    }
    
    //in here you set the index of the destination tab and you are done
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showTabBarTwo" {
            let tabbarController = segue.destination as! UITabBarController
            tabbarController.selectedIndex = self.tabBarIndex!
        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["pinkPageApp@outlook.com"])
        mailComposerVC.setSubject("CONTACT")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    

    
 

    @IBOutlet weak var passwordTextField: DesignableUITextField!
    
    @IBOutlet weak var emailTextField: DesignableUITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBottomBorderTextField()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBottomBorderTextField(){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: emailTextField.frame.size.height - width, width:  emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        
        border.borderWidth = width
        emailTextField.layer.addSublayer(border)
        emailTextField.layer.masksToBounds = true
        
        let borderTwo = CALayer()
        let widthTwo = CGFloat(2.0)
        borderTwo.borderColor = UIColor.lightGray.cgColor
        borderTwo.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - widthTwo, width:  passwordTextField.frame.size.width, height: passwordTextField.frame.size.height)
        
        borderTwo.borderWidth = width
        passwordTextField.layer.addSublayer(borderTwo)
        passwordTextField.layer.masksToBounds = true
    }

}

