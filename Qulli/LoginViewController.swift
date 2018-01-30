//
//  LoginViewController.swift
//  Qulli
//
//  Created by Kamal rastogi on 1/17/18.
//  Copyright © 2018 Kamal rastogi. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var Username : UITextField!
    @IBOutlet weak var Password : UITextField!
    @IBOutlet weak var loginBtn : UIButton!
    @IBOutlet weak var loginview : UIView!
    @IBOutlet weak var loginlbl : UILabel!
    @IBOutlet weak var forgotBtn : UIButton!
    @IBOutlet weak var Containerview : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Username.delegate = self
        Password.delegate = self
         loginlbl.textColor = UIColor(red: 39 / 255 , green: 43 / 255, blue: 61 / 255, alpha:1)
        
         self.view.backgroundColor = UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
   
        let label1 = UILabel(frame: CGRect(x: 0 , y: -5, width: Username.frame.size.width, height: 20))
        label1.text = "Username"
        label1.textColor = UIColor.black
        label1.font = UIFont.systemFont(ofSize: 14)
        Username.addSubview(label1)
        
        
        let label2 = UILabel(frame: CGRect(x: 0 , y: Username.frame.size.height - 3, width: Username.frame.size.width, height: 1.5))
        label2.backgroundColor = UIColor.darkGray
        Username.addSubview(label2)
     
        let label3 = UILabel(frame: CGRect(x: 0 , y: -5, width: Password.frame.size.width, height: 20))
        label3.text = "Password"
        label3.textColor = UIColor.black
        label3.font = UIFont.systemFont(ofSize: 14)
        Password.addSubview(label3)
        
        
        let label4 = UILabel(frame: CGRect(x: 0 , y: Password.frame.size.height - 3, width: Password.frame.size.width, height: 1.5))
        label4.backgroundColor = UIColor.darkGray
        Password.addSubview(label4)
        
       loginBtn.layer.cornerRadius = 0.5 * loginBtn.frame.size.width
       loginBtn.layer.borderWidth = 2.0
       loginBtn.layer.borderColor = UIColor.white.cgColor;
       self.loginBtn.clipsToBounds = true
       self.loginBtn.backgroundColor = UIColor(red: 39 / 255 , green: 43 / 255, blue: 61 / 255, alpha:1)
        
        forgotBtn.setTitleColor(UIColor(red: 39 / 255 , green: 43 / 255, blue: 61 / 255, alpha:1), for: .normal)
        
        self.loginview.layer.cornerRadius = 6.0
        self.loginview.layer.borderWidth = 2.0
        self.loginview.layer.borderColor = UIColor(red: 39 / 255 , green: 43 / 255, blue: 61 / 255, alpha:1).cgColor
        self.loginview.clipsToBounds = true
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150
       
        
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
     
    }
    
    @objc func dismissKeyboard()
    {
        
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        textField.resignFirstResponder()
        
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    @IBAction func loginBtnAction(_ sender: AnyObject)
    {
        if ( self.Username.text!.isEmpty || self.Password.text!.isEmpty   )
        {
            view.endEditing(true)
        }
        else
        {
            SharedManager.showHUD(viewController: self)
        let params: [String: String] = ["api-key" : "bc996d4a049d15e04d3e826426eb7b96"]
        
        let parameter: [String : String] = ["username": Username.text!, "password": Password.text!]
        
        Alamofire.request("https://project-qulli-cammy92.c9users.io/api/v1.0/driver/login", method: .post, parameters: parameter, encoding: URLEncoding.default, headers: params).responseJSON { (response:DataResponse<Any>) in
           
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    let json = data as! NSDictionary
 
                    let message = json.object(forKey: "message") as! String
                    
                    if (message == "Driver exist and details fetched successfully")
                        
                    {
                        let loginkey = json.object(forKey: "driver_login_key") as? String
                        UserDefaults.standard.set(loginkey, forKey: "loginkey")
                        SharedManager.dismissHUD(viewController: self)
                       self.performSegue(withIdentifier: "login", sender: self)
                    }
                    else
                    {
                        SharedManager.dismissHUD(viewController: self)
                        let alert = UIAlertController(title:nil, message:"User not registered", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                break
                
            case .failure(_):
                SharedManager.dismissHUD(viewController: self)
                let alert = UIAlertController(title:nil, message:"No internet connection", preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
                let when = DispatchTime.now() + 1.5
                DispatchQueue.main.asyncAfter(deadline: when){
                    alert.dismiss(animated: true, completion: nil)
                }
                break
            }
        }
        }
    }
    @IBAction func ForgotBtnAction(_ sender: AnyObject)
    {
        let alertController = UIAlertController(title: "Forgot Password ?", message: "Please enter your username", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField) -> Void in
            
            textField.placeholder = "Enter Username"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            if ( alertController.textFields!.first!.text!.isEmpty )
            {}
            else
            {
                SharedManager.showHUD(viewController: self)
                let parameter: [String : String] = ["username": alertController.textFields!.first!.text! ]
                
                let params: [String: String] = ["api-key" : "bc996d4a049d15e04d3e826426eb7b96"]
                
                Alamofire.request("http://qulli.co/api/v1.0/driver/forgot-password", method: .post, parameters: parameter, encoding: URLEncoding.default, headers: params).responseJSON { (response:DataResponse<Any>) in
                    
                    switch(response.result) {
                    case .success(_):
                        if let data = response.result.value{
                            let json = data as! NSDictionary
                            
                            let message = json.object(forKey: "message") as! String
                            
                            if ( message == "Password reset successfully. Please check your email")
                                
                            {    let alert = UIAlertController(title:nil, message:"Password reset successfully. Please check your email", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                                SharedManager.dismissHUD(viewController: self)
                            }
                            else if ( message == "Driver does not exist")
                                
                            {    let alert = UIAlertController(title:nil, message:"Driver does not exist", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                                SharedManager.dismissHUD(viewController: self)
                            }
                                
                            else
                            {
                                SharedManager.dismissHUD(viewController: self)
                                let alert = UIAlertController(title:nil, message:"Please enter registered username", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                        }
                        break
                        
                    case .failure(_):
                        SharedManager.dismissHUD(viewController: self)
                        let alert = UIAlertController(title:nil, message:"No internet connection", preferredStyle: UIAlertControllerStyle.alert)
                        self.present(alert, animated: true, completion: nil)
                        let when = DispatchTime.now() + 1.5
                        DispatchQueue.main.asyncAfter(deadline: when){
                            alert.dismiss(animated: true, completion: nil)
                        }
                        break
                        
                    }
                }}
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }}

