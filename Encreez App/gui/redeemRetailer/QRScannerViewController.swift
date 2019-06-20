//
//  QRScannerViewController.swift
//  Encreez App
//
//  Created by Razy Tech on 3/18/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage
import AVFoundation

class QRScannerViewController: UIViewController , AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var back: UIButton!
    
    let urlScan : String = "\(Global.baseUrl)/api/Transaction/GetCustomerRetailersPoint"
    
    let userID = UserDefaults.standard.string(forKey: "Id")
    
    let Lang = UserDefaults.standard.string(forKey: "Lang")
    
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    var captureSession: AVCaptureSession!
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var qrCodeFrameView:UIView?

    @IBOutlet weak var stopScan: UIButton!
    
    @IBAction func stopScanAct(_ sender: Any) {
        
       dismiss(animated: true, completion: nil )
    }
    override func viewDidAppear(_ animated: Bool) {
        
        view.bringSubview(toFront: stopScan)
        
    }
    override func viewDidLoad() {
    
        if self.Lang == "ar"
        {
            UIView.animate(withDuration: 2, animations: {
                self.back.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            })
        }
        super.viewDidLoad()
        
        back.semanticContentAttribute = .forceLeftToRight
        
        self.stopScan.layer.cornerRadius = 10
        
        view.bringSubview(toFront: stopScan)
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.blue.cgColor
            qrCodeFrameView.layer.borderWidth = 0.5
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
            
        }
        
        //  view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        if self.Lang == "ar"
        {
        
            
            let ac = UIAlertController(title: "المسح غير مدعوم", message: ".لا يدعم جهازك مسح رمز من عنصر. يرجى استخدام جهاز مع الكاميرا", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            captureSession = nil
         }
        else
        {
            let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            captureSession = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        captureSession.stopRunning()
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            //  messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = previewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            if metadataObj.stringValue != nil {
                view.bringSubview(toFront: qrCodeFrameView!)
                
                let character : Character = ","
                
           
                
                var fullName = metadataObj.stringValue
                
                if fullName!.characters.contains(character) {
                    
                    var fullNameArr  = fullName!.components(separatedBy: ",")
                    
                    let firstName: String = fullNameArr[0]
                    let lastName: String = fullNameArr[1]
                    
                    let params : [ String :String] = ["RetailerId" : lastName , "CustomerId" : self.userID! , "SellerId" : firstName , "Lang" : self.Lang!]
                    
                    
                    scanQRAPI(url: urlScan, parameters: params)
                    
                }
                else {
                    
                    if self.Lang == "ar"
                    {
                        let alert = UIAlertController(title: "تحذير", message: "حاول مرة اخري", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        Global.FixIpadActionsheet(alert: alert, controller: self)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                       
                        
                        let alert = UIAlertController(title: "Warning", message: "Please Try again Later", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        Global.FixIpadActionsheet(alert: alert, controller: self)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                }
             }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func exitScan()
    {
        
        dismiss(animated: true , completion: nil)
    }
    
    func  scanQRAPI(url : String , parameters : [String : String])
    {
        Alamofire.request(url , method: .post, parameters : parameters ).responseJSON {
            response in
            if response.result.isSuccess
            {
                let dataJSON = JSON(response.result.value!)
                let messageData = dataJSON["Message"].string
                let state = dataJSON["Status"].bool
            
                
                if state == true {

                  self.exitScan()
                    
                }
                
                else {
                    
                    let alert = UIAlertController(title: messageData , message: "", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    Global.FixIpadActionsheet(alert: alert, controller: self)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                
            }
            else
            {
                if self.Lang == "ar"
                {
                    let alert = UIAlertController(title: "تحذير", message: "حاول مرة اخري", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    Global.FixIpadActionsheet(alert: alert, controller: self)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    
                    
                    let alert = UIAlertController(title: "Warning", message: "Please Try again Later", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    Global.FixIpadActionsheet(alert: alert, controller: self)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    func invalidCode( alert : UIAlertAction ){
   
          captureSession.startRunning()
        
       }
    }
