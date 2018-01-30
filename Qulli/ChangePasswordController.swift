//
//  ChangePasswordController.swift
//  Qulli
//
//  Created by Kamal rastogi on 1/19/18.
//  Copyright © 2018 Kamal rastogi. All rights reserved.
//

import UIKit
import Alamofire

class ChangePasswordController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var menuButton:UIButton!
    
    @IBOutlet weak var OldPassword : UITextField!
    @IBOutlet weak var newPassword : UITextField!
    @IBOutlet weak var confPassword : UITextField!
    @IBOutlet weak var changePassword : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
        
        self.title = "Change Password"
        menuButton.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

         navigationController?.navigationBar.barTintColor = UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
        
        self.changePassword.backgroundColor = UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
        self.changePassword.layer.cornerRadius = 6.0
        
        let label1 = UILabel(frame: CGRect(x: 0 , y: -5, width: OldPassword.frame.size.width, height: 20))
        label1.text = "Old Password"
        label1.textColor = UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
        label1.font = UIFont.systemFont(ofSize: 14)
        OldPassword.addSubview(label1)
        
        
        let label2 = UILabel(frame: CGRect(x: 0 , y: OldPassword.frame.size.height - 3, width: OldPassword.frame.size.width, height: 1.5))
        label2.backgroundColor = UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
        OldPassword.addSubview(label2)
        
        let label3 = UILabel(frame: CGRect(x: 0 , y: -5, width: newPassword.frame.size.width, height: 20))
        label3.text = "New Password"
        label3.textColor = UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
        label3.font = UIFont.systemFont(ofSize: 14)
        newPassword.addSubview(label3)
        
        
        let label4 = UILabel(frame: CGRect(x: 0 , y: newPassword.frame.size.height - 3, width: newPassword.frame.size.width, height: 1.5))
        label4.backgroundColor = UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
        newPassword.addSubview(label4)
        
        
        let label5 = UILabel(frame: CGRect(x: 0 , y: -5, width: confPassword.frame.size.width, height: 20))
        label5.text = "Confirm Password"
        label5.textColor = UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
        label5.font = UIFont.systemFont(ofSize: 14)
        confPassword.addSubview(label5)
        
        
        let label6 = UILabel(frame: CGRect(x: 0 , y: confPassword.frame.size.height - 3, width: confPassword.frame.size.width, height: 1.5))
        label6.backgroundColor = UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
        confPassword.addSubview(label6)

        OldPassword.delegate =  self
        newPassword.delegate = self
        confPassword.delegate = self
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
    
        textField.resignFirstResponder()

        return true
    }
    
    @objc func dismissKeyboard()
    {
        
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeBtnAction(_ sender: AnyObject)
    {
        if ( self.OldPassword.text!.isEmpty || self.newPassword.text!.isEmpty || self.confPassword.text!.isEmpty)
        {
            self.view.endEditing(true)
        }
        else
        {
            if (self.newPassword.text!  != self.confPassword.text!)
            {
                 self.view.endEditing(true)
                let alert = UIAlertController(title:nil, message:"New Password and Confirm Password does not match", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                 self.view.endEditing(true)
        SharedManager.showHUD(viewController: self)
        let loginkey = UserDefaults.standard.object(forKey: "loginkey") as! String
        let params: [String: String] = ["driver-login-key" : loginkey ,"api-key" : "bc996d4a049d15e04d3e826426eb7b96"]
        let parameters: [String: String] = ["old_password" : OldPassword.text! ,"new_password" : newPassword.text!]
        
        Alamofire.request("http://qulli.co/api/v1.0/driver/change-password", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: params).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let json = data as! NSDictionary
                   
                    let message = json.object(forKey: "message") as! String
                    if ( message == "Password updated successfully")
                    {   let alert = UIAlertController(title:nil, message:"Password updated successfully", preferredStyle: UIAlertControllerStyle.alert)
                        self.present(alert, animated: true, completion: nil)
                        let when = DispatchTime.now() + 1.5
                        DispatchQueue.main.asyncAfter(deadline: when){
                            alert.dismiss(animated: true, completion: nil)                        }
                        SharedManager.dismissHUD(viewController: self)
                    }
                    else if ( message == "Incorrect old password")
                    {    let alert = UIAlertController(title:nil, message:"Incorrect old password", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        SharedManager.dismissHUD(viewController: self)
                    }
                    else
                    {
                        SharedManager.dismissHUD(viewController: self)
                        let alert = UIAlertController(title:nil, message:"Please try again later", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }  }
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
            }}}}}
}


