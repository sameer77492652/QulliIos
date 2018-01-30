//
//  BookingListController.swift
//  Qulli
//
//  Created by Kamal rastogi on 1/17/18.
//  Copyright © 2018 Kamal rastogi. All rights reserved.
//

import UIKit
import Alamofire

class BookingListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuButton:UIButton!
    @IBOutlet weak var scanBtn : UIButton!
    @IBOutlet weak var BookingTable : UITableView!
    var BookingArray : NSArray = []
    var refreshControl: UIRefreshControl!
    
    var bookingIDvalue:String = ""
    var currentStatusvalue:String = ""
    var Namevalue:String = ""
    var Emailvalue:String = ""
    var Phonevalue:String = ""
    var Pickupvalue:String = ""
    var PickupAddressvalue:String = ""
    var PickupDatevalue:String = ""
    var PickupTimevalue:String = ""
    var DropOffvalue:String = ""
    var DropAddressvalue:String = ""
    var DropDatevalue:String = ""
    var DropTimevalue:String = ""
    var NumberofItemsvalue:String = ""
    var ItemsScannedvalue:String = ""
    var assestArray : NSArray = []
    var imageArray : NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
    
      menuButton.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
       self.title = "Qulli"
        
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        navigationController?.navigationBar.barTintColor = UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
        
         self.scanBtn.backgroundColor = UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
         self.scanBtn.layer.cornerRadius = 6.0
        SharedManager.showHUD(viewController: self)
        
        let loginkey = UserDefaults.standard.object(forKey: "loginkey") as! String
        let params: [String: String] = ["driver-login-key" : loginkey ,"api-key" : "bc996d4a049d15e04d3e826426eb7b96"]
        
        Alamofire.request("https://project-qulli-cammy92.c9users.io/api/v1.0/driver/bookings", method: .get, parameters: nil, encoding: URLEncoding.default, headers: params).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let json = data as! NSDictionary
                    
                    self.BookingArray = json.object(forKey: "bookings") as! NSArray
                    self.BookingTable.reloadData()
                       SharedManager.dismissHUD(viewController: self)
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
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        BookingTable.refreshControl = refreshControl
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {

         let loginkey = UserDefaults.standard.object(forKey: "loginkey") as! String
        let params: [String: String] = ["driver-login-key" : loginkey ,"api-key" : "bc996d4a049d15e04d3e826426eb7b96"]
        
        Alamofire.request("https://project-qulli-cammy92.c9users.io/api/v1.0/driver/bookings", method: .get, parameters: nil, encoding: URLEncoding.default, headers: params).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let json = data as! NSDictionary
                    print(json)
                    self.BookingArray = json.object(forKey: "bookings") as! NSArray
                    self.BookingTable.reloadData()
                 
                      refreshControl.endRefreshing()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.BookingArray.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BookingCell = BookingTable.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell! as! BookingCell
        
       
       cell.Container.layer.borderWidth = 0.5
       cell.Container.layer.borderColor = UIColor.gray.cgColor
        
        
        cell.BookingID.text = "Booking Id : "+String(describing:  (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "booking_id") as! String)
        
        cell.Date.text = String(format: "Date :%@",(self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "pickup_date") as! String)
        
       
        cell.Time.text = String(format: "Time :%@ - %@", (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "pickup_time_start") as! String,(self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "pickup_time_end") as! String)
        
        
        cell.NoOfItems.text = "Number of Item : "+String(describing:  (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "no_of_items") as! Int)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
      
       self.bookingIDvalue = String(describing:  (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "booking_id") as! String)
       self.currentStatusvalue = (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "booking_status") as! String
        self.Namevalue = (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "client_name") as! String
        self.Emailvalue = (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "client_email") as! String
        self.Phonevalue = (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "client_phone") as! String
        
        self.PickupAddressvalue = (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "pickup_location") as! String
        self.PickupDatevalue = (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "pickup_date") as! String
        self.PickupTimevalue = String(format: "%@ - %@", (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "pickup_time_start") as! String,( self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "pickup_time_end") as! String)
        
        self.DropAddressvalue =  (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "drop_location") as! String
        self.DropDatevalue =  (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "drop_date") as! String
        self.DropTimevalue = String(format: "%@ - %@",( self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "drop_time_start") as! String, (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "drop_time_end") as! String)
        
        
        self.NumberofItemsvalue = String(describing:  (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "no_of_items") as! Int)
        assestArray = (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "assets") as! NSArray
        imageArray = (self.BookingArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "images") as! NSArray
        self.ItemsScannedvalue = String(describing:  assestArray.count)
  
        self.performSegue(withIdentifier: "celldetail", sender: self)
    }
    @IBAction func scanBtnAction(_ sender: AnyObject)
    {
         self.performSegue(withIdentifier: "scan", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if ( segue.identifier == "scan")
        {
        let backItem = UIBarButtonItem()
        backItem.title = "Scan"
        navigationItem.backBarButtonItem = backItem
    }
        else
        {
         
            
            let obj:BookingDetailController = segue.destination as! BookingDetailController
          
            obj.bookingIDvalue = self.bookingIDvalue
            obj.currentStatusvalue = self.currentStatusvalue
            obj.Namevalue = self.Namevalue
            obj.Emailvalue = self.Emailvalue
            obj.Phonevalue = self.Phonevalue
            obj.Pickupvalue = self.Pickupvalue
            obj.PickupAddressvalue = self.PickupAddressvalue
            obj.PickupDatevalue = self.PickupDatevalue
            obj.PickupTimevalue = self.PickupTimevalue
            obj.DropAddressvalue = self.DropAddressvalue
            obj.DropDatevalue = self.DropDatevalue
            obj.DropTimevalue = self.DropTimevalue
            obj.NumberofItemsvalue = self.NumberofItemsvalue
            obj.ItemsScannedvalue = self.ItemsScannedvalue
            obj.assestArray = self.assestArray
            obj.imageArray = self.imageArray
            
        }
    }
}
    extension UIView {
        func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = false) {
            self.layer.masksToBounds = false
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOpacity = opacity
            self.layer.shadowOffset = offSet
            self.layer.shadowRadius = radius
            self.clipsToBounds = false
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            self.layer.shouldRasterize = false
            self.layer.rasterizationScale = UIScreen.main.scale
        }
    }



