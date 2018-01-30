//
//  MenuViewController.swift
//  Qulli
//
//  Created by Kamal rastogi on 1/18/18.
//  Copyright © 2018 Kamal rastogi. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    
    var TableArray  = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
              TableArray = ["1", "2", "3" ]
         navigationController?.navigationBar.barTintColor = UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableArray[indexPath.row], for: indexPath) as UITableViewCell
    
        return cell
    }
   
  override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if indexPath.row == 2 {
       
        let alertController = UIAlertController(title: "Do you wish to Sign out ?", message: "", preferredStyle: UIAlertControllerStyle.alert)
       
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            
        }
        let okAction = UIAlertAction(title: "Sign out", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(viewController, animated:false, completion:nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    }
    
}


