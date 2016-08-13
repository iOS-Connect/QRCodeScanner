//
//  ViewController.swift
//  Bar code Scanner
//
//  Created by John Regner on 7/31/16.
//  Copyright © 2016 WigglingScholars. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    lazy var session: AVCaptureSession? = {
        let session = AVCaptureSession()
        let device = AVCaptureDevice
            .defaultDeviceWithMediaType(AVMediaTypeVideo)
        guard let input = try? AVCaptureDeviceInput(device: device)
            else { print("No input"); return nil }
        guard session.canAddInput(input) else { return nil }
        session.addInput(input)

        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        return session
    }()

    lazy var captureLayer:AVCaptureVideoPreviewLayer = {
        AVCaptureVideoPreviewLayer(session: self.session)
    }()

    override func viewDidLoad() {
        captureLayer.frame = view.frame
        self.view.layer.addSublayer(captureLayer)
    }

    override func viewWillAppear(animated: Bool) {
        let alert = UIAlertController(title: "No Camera Session",
                                      message: "Camera could not be initized. Sorry",
                                      preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        let settings = UIAlertAction(title: "Settings", style: .Default) { (_) in
            UIApplication.sharedApplication().canOpenURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
        super.viewWillAppear(animated)
        session?.startRunning()
    }

    func captureOutput(captureOutput: AVCaptureOutput!,
                     didOutputMetadataObjects metadataObjects: [AnyObject]!,
                     fromConnection connection: AVCaptureConnection!) {
        session?.stopRunning()
        let code = metadataObjects.first as? AVMetadataMachineReadableCodeObject
        guard let urlString = code?.stringValue,
            let url = NSURL(string: urlString) else {
                session?.startRunning()
                return
        }
        UIApplication.sharedApplication().openURL(url)
    }

}














