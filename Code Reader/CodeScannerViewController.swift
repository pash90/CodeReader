//
//  CodeScannerViewController.swift
//  Code Reader
//
//  Created by Parth on 17/5/17.
//  Copyright © 2017 Parth. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class CodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    //MARK: - Properties
    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    // Initialise Realm
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startScanning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func startScanning() {
        // Create a session object
        session = AVCaptureSession()
        
        // Set the capture device
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // Create input object
        let videoInput: AVCaptureDeviceInput?
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        // Add input to session
        if(session.canAddInput(videoInput)) {
            session.addInput(videoInput)
        } else {
            scanningNotPossible()
        }
        
        // Create output object
        let metadataOutput = AVCaptureMetadataOutput()
        
        // Add output to session
        if(session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            
            // Send captured data to delegate object via a serial queue
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Set barcode type for which to scan
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code]
        } else {
            scanningNotPossible()
        }
        
        // Add previewLayer and have it show the video data
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // Begin capturing
        session.startRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Get the first object from the metadataObjects array
        if let barcodeData = metadataObjects.first {
            
            // Turn it into machine readable code
            let readableBarcode = barcodeData as? AVMetadataMachineReadableCodeObject
            if let readableCode = readableBarcode {
                // Send the barcode as a string to the barcodeDetected()
                barcodeDetected(code: readableCode)
            }
            
            // Vibrate the device to give the user some feedback
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            // Avoid a very buzzy device
            session.stopRunning()
        }
    }
    
    func barcodeDetected(code: AVMetadataMachineReadableCodeObject) {
        // Make the code to be stored
        let codeValue = [code.type, code.stringValue, Date(timeIntervalSince1970: code.time.seconds)] as [Any]
        
        // Add the code to storage
        realm.beginWrite()
        realm.create(Code.self, value: codeValue)
        try! realm.commitWrite()
        
        print(codeValue)
        
        // Close the camera view
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func scanningNotPossible() {
        // Let user know scanning is not possible with the current device
        let alert = UIAlertController(title: "Can't Scan.", message: "Let's try a device equipped with a camera.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        session = nil
    }
}
