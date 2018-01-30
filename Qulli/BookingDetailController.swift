//
//  BookingDetailController.swift
//  Qulli
//
//  Created by Kamal rastogi on 1/18/18.
//  Copyright © 2018 Kamal rastogi. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation


class BookingDetailController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
    
    var height : CGFloat!
    
    var barcodevalue:String = ""
    var assestID:String = ""
    var attributeID:String = ""
    var BookingID:String = ""
    
    @IBOutlet  var MainScrollView: UIScrollView!
    @IBOutlet  var addnewBtn: UIButton!
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
    @IBOutlet  var ItemsScanned: UILabel!
    @IBOutlet  var Camera: UIButton!
    @IBOutlet  var Gallery: UIButton!
    @IBOutlet  var scannewBtn: UIView!
    
    var assestArray : NSArray = []
    var imageArray : NSArray = []
    
    @IBOutlet var showcollectionView: UICollectionView!
    
    @IBOutlet var imagecollectionView: UICollectionView!
    
    var imagePicker = UIImagePickerController()
    
    var statusArray : NSArray = []
    
    var output = AVCaptureMetadataOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var captureSession = AVCaptureSession()
    weak var delegate: BarcodeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
      //   self.PickupAddress.frame.size.height = self.PickupAddress.optimalHeight
       //   self.DropAddress.frame.size.height = self.DropAddress.optimalHeight
        
 //  PickupAddress.numberOfLines = 0
        
     //   PickupAddress.preferredMaxLayoutWidth = self.PickupAddress.frame.size.width
        
   //  PickupAddress.lineBreakMode = NSLineBreakMode.byWordWrapping
        
   //     PickupAddress.sizeToFit()
        
        
   //     DropAddress.numberOfLines = 0
        
   //     DropAddress.preferredMaxLayoutWidth = 50
        
   //     DropAddress.lineBreakMode = NSLineBreakMode.byWordWrapping
        
    //    DropAddress.sizeToFit()
        
        self.title = "Booking Detail"

        self.scannewBtn.isHidden = false
        MainScrollView.autoresizesSubviews = true
        
         self.bookingID.text = String(format: "Booking ID : %@ ", self.bookingIDvalue )
         self.currentStatus.text = String(format: "Current Status : %@ ", self.currentStatusvalue )
         self.Name.text = String(format: "Name : %@ ",self.Namevalue )
         self.Email.text = String(format: "Email : %@ ",self.Emailvalue )
         self.Phone.text = String(format: "Phone : %@ ",self.Phonevalue )
         self.PickupAddress.text = self.PickupAddressvalue
        
         self.PickupDate.text = self.PickupDatevalue
         self.PickupTime.text = self.PickupTimevalue
         self.DropAddress.text = self.DropAddressvalue
       
         self.DropDate.text = self.DropDatevalue
         self.DropTime.text = self.DropTimevalue
         self.NumberofItems.text =  String(format: "Number of Items : %@ ",  self.NumberofItemsvalue )
         self.ItemsScanned.text =  String(format: "Items Scanned: %@ ", self.ItemsScannedvalue )
        
        navigationController?.navigationBar.tintColor = .white
        
        
        addnewBtn.backgroundColor =  UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
        addnewBtn.layer.cornerRadius = 6.0
        
        Camera.backgroundColor =  UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
        Camera.layer.cornerRadius = 6.0
        
        Gallery.backgroundColor =  UIColor(red: 101 / 255 , green: 205 / 255, blue: 198 / 255, alpha:1)
        Gallery.layer.cornerRadius = 6.0
        
    //    self.updateframe()
     
    
    }
    
    @IBAction func takePhoto(_ sender: Any){
        openCamera()
    }
    
    @IBAction func takePhotoFromGallery(_ sender: Any){
        openGallery()
    }
    
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(imagePicker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        print("ImageData", strBase64)
        addImage(image: strBase64, bookingId: bookingIDvalue)
       // let image = UIImage.init(named: "myImage")
       // let imgData = UIImageJPEGRepresentation(image!, 0.2)!
        
        //let parameters = ["name": rname]
        //imageView.image = image1
        print("Image picked")
        picker.dismiss(animated: true, completion: nil)
        dismiss(animated: true) {
            print("dismissed")
            // self.delegate?.presentEditor(img: (info[UIImagePickerControllerOriginalImage] as? UIImage)!, id: self.id!)
        }
        
    }
    
    func addImage(image : String, bookingId : String){
        
        SharedManager.showHUD(viewController: self)
        
        let loginkey = UserDefaults.standard.object(forKey: "loginkey") as! String
        
        let params: [String: String] = ["driver-login-key" : loginkey ,"api-key" : "bc996d4a049d15e04d3e826426eb7b96"]
        
        let parameter: [String : String] = ["image": image, "booking_id": bookingId]
        print("Parameters", parameter)
        Alamofire.request("https://project-qulli-cammy92.c9users.io/api/v1.0/driver/add/image", method: .post, parameters: parameter, encoding: URLEncoding.default, headers: params).responseJSON { (response:DataResponse<Any>) in
            print("response %@: ",response.result)
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    
                    let json = data as! NSDictionary
                    print(json)
                    let message = json.object(forKey: "message") as! String
                    
                    if (message == "Image inserted succesfully")
                        
                    {
                        
                        //    self.updateframe()
                        SharedManager.dismissHUD(viewController: self)
                    }
                    else
                    {
                        SharedManager.dismissHUD(viewController: self)
                        
                        let alert = UIAlertController(title:nil, message:"No Image Exist", preferredStyle: UIAlertControllerStyle.alert)
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
  //  func updateframe()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.showcollectionView.addObserver(self , forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)
        
        self.imagecollectionView.addObserver(self , forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)
        
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
        
        self.ItemsScanned.frame = CGRect(x: self.ItemsScanned.frame.origin.x, y: self.NumberofItems.frame.origin.y + NumberofItems.frame.size.height + 10 , width: self.NumberofItems.frame.width, height: self.ItemsScanned.frame.size.height)
        
        self.showcollectionView.frame = CGRect(x: self.showcollectionView.frame.origin.x, y: self.ItemsScanned.frame.origin.y + ItemsScanned.frame.size.height + 10
            , width: self.showcollectionView.frame.width, height: self.showcollectionView.collectionViewLayout.collectionViewContentSize.height)
        
        self.Camera.frame = CGRect(x: self.Camera.frame.origin.x, y: self.showcollectionView.frame.origin.y + showcollectionView.frame.size.height + 10 , width: self.Camera.frame.width, height: self.Camera.frame.size.height)
        
        self.Gallery.frame = CGRect(x: self.Gallery.frame.origin.x, y: self.showcollectionView.frame.origin.y + showcollectionView.frame.size.height + 10 , width: self.Gallery.frame.width, height: self.Gallery.frame.size.height)
        
        
        self.imagecollectionView.frame = CGRect(x: self.imagecollectionView.frame.origin.x, y: self.showcollectionView.frame.origin.y + showcollectionView.frame.size.height + 100
            , width: self.imagecollectionView.frame.width, height: self.imagecollectionView.collectionViewLayout.collectionViewContentSize.height)
        
        
        self.addnewBtn.frame = CGRect(x: self.addnewBtn.frame.origin.x, y: self.imagecollectionView.frame.origin.y + imagecollectionView.frame.size.height + 10 , width: self.addnewBtn.frame.width, height: self.addnewBtn.frame.size.height)
        
        self.MainScrollView.contentSize = CGSize(width: self.view.frame.size.width,height: self.bookingID.frame.size.height  + self.currentStatus.frame.size.height  + self.Name.frame.size.height  + self.Email.frame.size.height  + self.Phone.frame.size.height  + self.Pickup.frame.size.height  + self.PickupAddress.optimalHeight   + self.PickupDate.frame.size.height   + self.PickupTime.frame.size.height    + self.DropOff.frame.size.height  + self.DropAddress.optimalHeight   + self.DropDate.frame.size.height   + self.DropTime.frame.size.height  + self.NumberofItems.frame.size.height  + self.ItemsScanned.frame.size.height +
            self.showcollectionView.frame.size.height  +
            self.Camera.frame.size.height +
            self.imagecollectionView.frame.size.height +
            self.addnewBtn.frame.size.height + 150 )
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        height = self.showcollectionView.collectionViewLayout.collectionViewContentSize.height
        
        height = self.imagecollectionView.collectionViewLayout.collectionViewContentSize.height
        
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let newHeight : CGFloat = self.showcollectionView.collectionViewLayout.collectionViewContentSize.height
        
        var frame : CGRect! = self.showcollectionView.frame
        frame.size.height = newHeight
        
        self.showcollectionView.frame = frame
        
        let newHeightCollection : CGFloat = self.imagecollectionView.collectionViewLayout.collectionViewContentSize.height
        
        var frame2 : CGRect! = self.imagecollectionView.frame
        frame2.size.height = newHeightCollection
        
        self.showcollectionView.frame = frame2
       
       self.MainScrollView.contentSize = CGSize(width: self.view.frame.size.width,height: self.bookingID.frame.size.height  + self.currentStatus.frame.size.height  + self.Name.frame.size.height  + self.Email.frame.size.height  + self.Phone.frame.size.height  + self.Pickup.frame.size.height  + self.PickupAddress.frame.size.height   + self.PickupDate.frame.size.height   + self.PickupTime.frame.size.height    + self.DropOff.frame.size.height  + self.DropAddress.frame.size.height   + self.DropDate.frame.size.height   + self.DropTime.frame.size.height  + self.NumberofItems.frame.size.height  + self.ItemsScanned.frame.size.height + self.showcollectionView.frame.size.height + self.addnewBtn.frame.size.height + 10)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.showcollectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == imagecollectionView){
            return self.imageArray.count
        }else{
            return self.assestArray.count
        }
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if(collectionView == imagecollectionView){
            let cell = imagecollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! ImageCell
            
            let imageURL = ( self.imageArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "image_url") as? String
            
           
            let trimmedUrl = imageURL?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!.trimmingCharacters(in: CharacterSet(charactersIn: "")).replacingOccurrences(of: " ", with: "%20") as! String
            
            print("URL is : %@", trimmedUrl)
            
            
            if let url = NSURL(string: trimmedUrl) {
                if let imageData = NSData(contentsOf: url as URL) {
                    let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
                    let data: NSData = NSData(base64Encoded: str64 , options: .ignoreUnknownCharacters)!
                    let dataImage = UIImage(data: data as Data)
                    cell.Imageview.image = dataImage
                    
                }
            }
           return cell
        }else{
            let cell = showcollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! BookingDetailCell
            
            cell.BarValue.text = ( self.assestArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "asset_barcode") as? String
            
            cell.StatusTitle.text = ( self.assestArray.object(at: (indexPath as NSIndexPath).row) as AnyObject).value(forKey: "asset_status") as? String
            
            cell.Container.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: false)
            
            return cell
        }
        
        
    }
    
    
   
    
    func flowLayout()
    {
        let flowlayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowlayout.minimumInteritemSpacing = 5.0
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumLineSpacing = 5.0
        flowlayout.sectionInset.left = 0.0;
        flowlayout.sectionInset.right = 0.0;
        flowlayout.itemSize.width =  self.showcollectionView.frame.width / 2 - 10
        flowlayout.itemSize.height = self.showcollectionView.frame.height / 2 - 10
        self.showcollectionView.collectionViewLayout = flowlayout
        
    }
    
    @IBAction func newscanBtnAction(_ sender: AnyObject)
    {
        if ItemsScannedvalue < NumberofItemsvalue {
        
        self.scannewBtn.isHidden = false
        
         setupCamera()
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
        }
        else
        {
            let alert = UIAlertController(title:nil, message:"Maximum number of item already scanned.", preferredStyle: UIAlertControllerStyle.alert)
            
            self.present(alert, animated: true, completion: nil)
            
            let when = DispatchTime.now() + 1.5
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    private func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: device) else {
                return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = scannewBtn.bounds
        scannewBtn.layer.addSublayer(previewLayer)
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = metadataOutput.availableMetadataObjectTypes
        } else {
            print("Could not add metadata output")
        }
        
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        
        for metadata in metadataObjects {
            if let readableObject = metadata as? AVMetadataMachineReadableCodeObject,
                let code = readableObject.stringValue {
                dismiss(animated: true)
                delegate?.barcodeRead(barcode: code)
                print(code)
                if code != ""
                {
                    captureSession.stopRunning()
                    previewLayer.removeFromSuperlayer()
                   barcodevalue = code
                    self.scannewBtn.isHidden = false
                    self.addnewitem()
                    
                }
            }
        }
    }
 func addnewitem ()
 {
    
    SharedManager.showHUD(viewController: self)
    
    let loginkey = UserDefaults.standard.object(forKey: "loginkey") as! String
    let params: [String: String] = ["driver-login-key" : loginkey ,"api-key" : "bc996d4a049d15e04d3e826426eb7b96"]
    
    let parameter: [String : String] = ["barcode_value": barcodevalue, "booking_id": bookingIDvalue]
    
    Alamofire.request("http://actipatient.com/qulli/api/v1.0/driver/add/asset", method: .post, parameters: parameter, encoding: URLEncoding.default, headers: params).responseJSON { (response:DataResponse<Any>) in
        
        switch(response.result) {
        case .success(_):
            if let data = response.result.value{
                
                let json = data as! NSDictionary
                print(json)
                let message = json.object(forKey: "message") as! String
                
                if (message == "Asset inserted succesfully")
                    
                {
                    self.assestArray = json.object(forKey: "assets") as! NSArray
                   let countnow = String(self.assestArray.count)
                    self.ItemsScanned.text = String(format: "Items Scanned: %@ ", countnow )

                    self.showcollectionView.reloadData()
                //    self.updateframe()
                    SharedManager.dismissHUD(viewController: self)
                }
                else
                {
                    SharedManager.dismissHUD(viewController: self)
                    
                    let alert = UIAlertController(title:nil, message:"Asset with same barcode value already exist", preferredStyle: UIAlertControllerStyle.alert)
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

