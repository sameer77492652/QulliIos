//
//  NewScanController.swift
//  Qulli
//
//  Created by Kamal rastogi on 1/17/18.
//  Copyright © 2018 Kamal rastogi. All rights reserved.
//

import UIKit
import AVFoundation

protocol BarcodeDelegate: class {
    func barcodeRead(barcode: String)
}

class NewScanController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    weak var delegate: BarcodeDelegate?
       var valuebarcode:String = ""
    var output = AVCaptureMetadataOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!

    var captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     navigationController?.navigationBar.tintColor = .white
        
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession.isRunning {
            captureSession.stopRunning()
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
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        
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
               
                delegate?.barcodeRead(barcode: code)
                print(code)
                if code != ""
                {
                    captureSession.stopRunning()
                    previewLayer.removeFromSuperlayer()
                valuebarcode = code
                self.performSegue(withIdentifier: "detail", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let obj:ScanDetailController = segue.destination as! ScanDetailController
        obj.barcodevalue = self.valuebarcode
       
        
        
    }
}
