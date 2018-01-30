//
//  ScanDetailController.swift
//  Qulli
//
//  Created by Kamal rastogi on 1/18/18.
//  Copyright © 2018 Kamal rastogi. All rights reserved.
//

import UIKit
import Alamofire

class ScanDetailController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var barcodevalue:String = ""
    var assestID:String = ""
    var attributeID:String = ""
    var BookingID:String = ""

    
    @IBOutlet  var MainScrollView: UIScrollView!
    @IBOutlet  var assestBtn: UIButton!
    @IBOutlet  var submitBtn: UIButton!
    @IBOutlet  var bookingID: UILabel!
    @IBOutlet  var currentStatus: UILabel!
    @IBOutlet  var Name: UILabel!
    @IBOutlet  var Email: UILabel!
    @IBOutlet  var Phone: UILabel!
    @IBOutlet  var Pickup: UILabel!
    @IBOutlet  var PickupAddress: UILabel!
    @IBOutlet  var PickupDate: UILabel!
    @IBOutlet  var PickupTime: UILabel!
    @IBOutlet  var DropOff: UILabel!
    @IBOutlet  var DropAddress: UILabel!
    @IBOutlet  var DropDate: UILabel!
    @IBOutlet  var DropTime: UILabel!
    @IBOutlet  var NumberofItems: UILabel!
   
    var assestArray : NSArray = []
  
    @IBOutlet var showTableView: UIView!
    @IBOutlet var myTableView: UITableView!
    var statusArray : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Scan Detail"
        self.navigationItem.hidesBackButton = true
        var newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ScanDetailController.back(sender:)))
        let img = UIImage(named: "leftarrow")!
        newBackButton = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ScanDetailController.back(sender:)))

        self.navigationItem.leftBarButtonItem = newBackButton
      
        navigationController?.navigationBar.tintColor = .white
        
        MainScrollView.autoresizesSubviews = true
        
        self.showTableView.isHidden = true
        self.submitBtn.isHidden = true
       
        submitBtn.backgroundColor =  UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
        submitBtn.layer.cornerRadius = 6.0
        
        assestBtn.layer.borderWidth = 1.0
        assestBtn.layer.borderColor =  UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1).cgColor
        assestBtn.layer.cornerRadius = 6.0
        
        myTableView.layer.borderWidth = 1.0
        myTableView.layer.borderColor =  UIColor.lightGray.cgColor
        myTableView.layer.cornerRadius = 3.0
        
        let loginkey = UserDefaults.standard.object(forKey: "loginkey") as! String
        let params: [String: String] = ["driver-login-key" : loginkey ,"api-key" : "bc996d4a049d15e04d3e826426eb7b96"]
        
        let parameter: [String : String] = ["barcode_value": barcodevalue]
        
        Alamofire.request("https://project-qulli-cammy92.c9users.io/api/v1.0/driver/scan", method: .post, parameters: parameter, encoding: URLEncoding.default, headers: params).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    let json = data as! NSDictionary
                    
                    let message = json.object(forKey: "message") as! String
                   
                    if (message == "Barcode details fetched successfully")
                        
                    {
                        self.bookingID.text = String(format: "Booking ID : %@ ",  json.object(forKey: "booking_id") as! String)
                      
                        self.currentStatus.text = String(format: "Current Status : %@ ", json.object(forKey: "booking_status") as! String )
                        
                        self.Name.text = String(format: "Name : %@ ",  json.object(forKey: "client_name") as! String )
                        
                        self.Email.text = String(format: "Email : %@ ", json.object(forKey: "client_email") as! String )
                        self.Phone.text = String(format: "Phone : %@ ", json.object(forKey: "client_phone") as! String )
                       
                        self.PickupAddress.text = json.object(forKey: "pickup_location") as? String
                        self.PickupAddress.frame.size.height = self.PickupAddress.optimalHeight
                        self.PickupDate.text = json.object(forKey: "pickup_date") as? String
                        self.PickupTime.text = String(format: "%@ - %@", json.object(forKey: "pickup_time_start") as! String,json.object(forKey: "pickup_time_end") as! String)
                      
                        self.DropAddress.text = json.object(forKey: "drop_location") as? String
                        self.DropAddress.frame.size.height = self.DropAddress.optimalHeight
                        self.DropDate.text = json.object(forKey: "drop_date") as? String
                        self.DropTime.text = String(format: "%@ - %@", json.object(forKey: "drop_time_start") as! String,json.object(forKey: "drop_time_end") as! String)
                        
                        self.NumberofItems.text = String(format: "Number of Items : %@ ", String( json.object(forKey: "no_of_items") as! Int))
                        self.attributeID = String ( json.object(forKey: "attribute_id") as! Int )
                        self.BookingID =  json.object(forKey: "booking_id") as! String 
                        self.statusArray = json.object(forKey: "available_status") as! NSArray
                        self.myTableView.reloadData()
                        self.updateframes()
                           SharedManager.dismissHUD(viewController: self)
                    }
                    else
                    {
                           SharedManager.dismissHUD(viewController: self)
                           self.performSegue(withIdentifier: "home", sender: self)
                        let alert = UIAlertController(title:nil, message:"Barcode not found", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                       
                    }
                }
                break
                
            case .failure(_):
                   self.performSegue(withIdentifier: "home", sender: self)
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
  
    @objc func back(sender: UIBarButtonItem) {
   
          self.performSegue(withIdentifier: "home", sender: self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func updateframes() {
        
        self.myTableView.frame = CGRect(x: self.myTableView.frame.origin.x, y: self.myTableView.frame.origin.y , width: self.myTableView.frame.width, height: CGFloat(50 * (statusArray.count)))
        
        self.bookingID.frame = CGRect(x: self.bookingID.frame.origin.x, y: self.bookingID.frame.origin.y , width: self.bookingID.frame.width, height: bookingID.frame.size.height)
        
        self.currentStatus.frame = CGRect(x: self.currentStatus.frame.origin.x, y: self.bookingID.frame.origin.y + bookingID.frame.size.height, width: self.currentStatus.frame.width, height: currentStatus.frame.size.height)
        
        self.Name.frame = CGRect(x: self.Name.frame.origin.x, y: self.currentStatus.frame.origin.y + currentStatus.frame.size.height  , width: self.Name.frame.width, height: self.Name.frame.size.height)
        
        self.Email.frame = CGRect(x: self.Email.frame.origin.x, y: self.Name.frame.origin.y + Name.frame.size.height  , width: self.Email.frame.width, height: self.Email.frame.size.height)
        
        self.Phone.frame = CGRect(x: self.Phone.frame.origin.x, y: self.Email.frame.origin.y + Email.frame.size.height  , width: self.Phone.frame.width, height: self.Phone.frame.size.height)
        
        self.Pickup.frame = CGRect(x: self.Pickup.frame.origin.x, y: self.Phone.frame.origin.y + Phone.frame.size.height + 10 , width: self.Pickup.frame.width, height: self.Pickup.frame.size.height)
        
        self.PickupAddress.frame = CGRect(x: self.PickupAddress.frame.origin.x, y: self.Pickup.frame.origin.y + Pickup.frame.size.height  , width: self.PickupAddress.frame.width, height: self.PickupAddress.optimalHeight)
        
        self.PickupDate.frame = CGRect(x: self.PickupDate.frame.origin.x, y: self.PickupAddress.frame.origin.y + PickupAddress.frame.size.height  , width: self.PickupDate.frame.width, height: self.PickupDate.frame.size.height)
        
        self.PickupTime.frame = CGRect(x: self.PickupTime.frame.origin.x, y: self.PickupDate.frame.origin.y + PickupDate.frame.size.height  , width: self.PickupTime.frame.width, height: self.PickupTime.frame.size.height)
        
        self.DropOff.frame = CGRect(x: self.DropOff.frame.origin.x, y: self.PickupTime.frame.origin.y + PickupTime.frame.size.height + 10 , width: self.DropOff.frame.width, height: self.DropOff.frame.size.height)
        
        self.DropAddress.frame = CGRect(x: self.DropAddress.frame.origin.x, y: self.DropOff.frame.origin.y + DropOff.frame.size.height  , width: self.DropAddress.frame.width, height: self.DropAddress.optimalHeight)
        
        self.DropDate.frame = CGRect(x: self.DropDate.frame.origin.x, y: self.DropAddress.frame.origin.y + DropAddress.frame.size.height  , width: self.DropDate.frame.width, height: self.DropDate.frame.size.height)
        
        self.DropTime.frame = CGRect(x: self.DropTime.frame.origin.x, y: self.DropDate.frame.origin.y + DropDate.frame.size.height  , width: self.DropTime.frame.width, height: self.DropTime.frame.size.height)
        
        self.NumberofItems.frame = CGRect(x: self.NumberofItems.frame.origin.x, y: self.DropTime.frame.origin.y + DropTime.frame.size.height + 10 , width: self.NumberofItems.frame.width, height: self.NumberofItems.frame.size.height)
       
         self.assestBtn.frame = CGRect(x: self.assestBtn.frame.origin.x, y: self.NumberofItems.frame.origin.y + NumberofItems.frame.size.height + 5  , width: self.assestBtn.frame.width, height: self.assestBtn.frame.size.height)
        
         self.MainScrollView.contentSize = CGSize(width: self.view.frame.size.width,height: self.bookingID.frame.size.height  + self.currentStatus.frame.size.height  + self.Name.frame.size.height  + self.Email.frame.size.height  + self.Phone.frame.size.height  + self.Pickup.frame.size.height  + self.PickupAddress.frame.size.height   + self.PickupDate.frame.size.height   + self.PickupTime.frame.size.height    + self.DropOff.frame.size.height  + self.DropAddress.frame.size.height   + self.DropDate.frame.size.height   + self.DropTime.frame.size.height  + self.NumberofItems.frame.size.height   + self.assestBtn.frame.size.height)
            
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statusArray.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = ( self.statusArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "status_text") as? String
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.textLabel?.textAlignment = .left
        
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        assestBtn.setTitle(( self.statusArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "status_text") as? String, for: .normal)
        assestID = String(format: "%@", String(( self.statusArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "status_id") as! Int))
       
       self.showTableView.isHidden = true
         self.submitBtn.isHidden = false
    }
    
    @IBAction func assetBtnAction(_ sender: AnyObject)
    {
        self.showTableView.isHidden = false
    }
    @IBAction func closeBtnAction(_ sender: AnyObject)
    {
        self.showTableView.isHidden = true
    }
    
     @IBAction func updatebookingstatus(_ sender: AnyObject)
    {
        let loginkey = UserDefaults.standard.object(forKey: "loginkey") as! String
        let params: [String: String] = ["driver-login-key" : loginkey ,"api-key" : "bc996d4a049d15e04d3e826426eb7b96"]
        
        let parameter: [String : String] = ["status_id": assestID , "booking_id": BookingID , "attribute_id": attributeID]
   
        Alamofire.request("https://project-qulli-cammy92.c9users.io/api/v1.0/driver/booking/update", method: .post, parameters: parameter, encoding: URLEncoding.default, headers: params).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    let json = data as! NSDictionary
                
                    let message = json.object(forKey: "message") as! String
                    
                    if (message == "Attribute status updated successfully")
                        
                    {
                    
                          self.performSegue(withIdentifier: "home", sender: self)
                    }
                    else
                    {
                        
                        let alert = UIAlertController(title:nil, message:"Please try again later", preferredStyle: UIAlertControllerStyle.alert)
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

extension UILabel
{
    var optimalHeight : CGFloat
    {
        get
        {
            let label = UILabel(frame: CGRect( x : 0, y : 0, width : self.frame.width, height : CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = self.lineBreakMode
            label.font = self.font
            label.text = self.text
            
            label.sizeToFit()
            
            return label.frame.height
        }
    }
}
