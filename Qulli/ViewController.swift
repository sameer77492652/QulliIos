//
//  ViewController.swift
//  Qulli
//
//  Created by Kamal rastogi on 1/17/18.
//  Copyright © 2018 Kamal rastogi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var chosenImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          imagePicker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickFromGallery(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        chosenImage.image = image
        
    /*    let image = UIImage.init(named: "myImage")
        let imgData = UIImageJPEGRepresentation(image!, 0.2)!
        
        let parameters = ["name": rname]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to:"mysite/upload.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }*/
        
        print("Image picked")
        picker.dismiss(animated: true, completion: nil)
        dismiss(animated: true) {
            print("dismissed")
           // self.delegate?.presentEditor(img: (info[UIImagePickerControllerOriginalImage] as? UIImage)!, id: self.id!)
        }
        
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: { () -> Void in
            print("sud")
        })
        
    }
    
    @IBAction func openCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }else{
            print("Camera not awailable")
        }
        
    }

}

