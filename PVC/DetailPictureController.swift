//
//  DetailPictureController.swift
//  PVC
//
//  Created by iorin on 2018/10/04.
//  Copyright © 2018 iorin. All rights reserved.
//

import UIKit
import AVFoundation

class DetailPictureController: UIViewController, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {

    
    @IBOutlet weak var detailPic: UIImageView!
    @IBOutlet weak var carNumber: UITextField!
    
    var selectedImg: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailPic.image = selectedImg
    }
    
    @IBAction func onOkButtontapped(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
