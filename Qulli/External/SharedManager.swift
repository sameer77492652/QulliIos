//
//  SharedManager.swift
//  Zabrabox
//
//  Created by Adyas on 17/11/16.
//  Copyright © 2016 adyas. All rights reserved.
//

import UIKit

class SharedManager: NSObject {
    
   class func showHUD(viewController: UIViewController)
    {
        let hud = MBProgressHUD.showAdded(to: viewController.view, animated: true)
        hud.label.text = "Loading"
        hud.contentColor = UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
    }
    
    class func ViewshowHUD(viewController: UIView)
    {
        let hud = MBProgressHUD.showAdded(to: viewController, animated: true)
        hud.label.text = "Loading"
        hud.contentColor = UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
    }
   class func dismissHUD(viewController: UIViewController)
    {
        MBProgressHUD.hide(for: viewController.view, animated: true)
    }
    
    class func viewdismissHUD(viewController: UIView)
    {
        MBProgressHUD.hide(for: viewController, animated: true)
    }
    
    class func checkForInternetConnection() -> Bool {
        
        let reachabilityObj = Reachability.forInternetConnection()
        let status = reachabilityObj?.currentReachabilityStatus()
        if (status == .NotReachable){
            return false
        }
        else {
            return true
        }
    }
    
    class func showErrorConnectionViewController(viewController: UIViewController)
    {
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "NoConnectionVC") as! ErrorVC
//        let navController = UINavigationController.init(rootViewController: viewController)
//        viewController.present(viewController, animated: true, completion: nil)
    }
    
    
    class func showAlertWithMessage(alertMessage: String, viewController: UIViewController)
    {
        let alert = UIAlertController(title: "Message", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
       // self.present(alert, animated: true, completion: nil)
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
    
    
}
