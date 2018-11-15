//
//  ResultViewController.swift
//  PVC
//
//  Created by iorin on 2018/10/14.
//  Copyright © 2018 iorin. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    var carNumString: String?
    
    @IBOutlet weak var resurtLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resurtLabel.text = "登録されています"
        // Do any additional setup after loading the view.
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
