//
//  DetailPictureController.swift
//  PVC
//
//  Created by iorin on 2018/10/04.
//  Copyright © 2018 iorin. All rights reserved.
//

import UIKit
import AVFoundation
import Vision


class DetailPictureController: UIViewController, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate,  UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailPic: UIImageView!
    @IBOutlet weak var carNumber: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    var selectedImg: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNumber()
        detailPic.image = selectedImg
        carNumber.delegate = self
        
        // キーボードを開く際に呼び出す通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        // キーボードを閉じる際に呼び出す通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //スクロール領域の設定
        scrollView.contentSize = CGSize(width:self.view.frame.width, height:self.view.frame.height)
        //labelをscrollViewのSubViewとして追加
        scrollView.addSubview(carNumber)
        scrollView.addSubview(detailPic)
        scrollView.addSubview(carNumber)
        scrollView.addSubview(button)
        scrollView.addSubview(label)
        //scrollViewをviewのSubViewとして追加
        self.view.addSubview(scrollView)
    }
    
    func getNumber() {
        // Load the ML model through its generated class
        guard let coreMLModel = try? VNCoreMLModel(for: ImageClassifier().model) else {
            fatalError("can't load Places ML model")
        }
        
        _ = VNCoreMLRequest(model: coreMLModel) { request, error in
            // results は confidence の高い（そのオブジェクトである可能性が高い）
            // 順番に sort された Array で返ってきます
            guard let results = request.results as? [VNClassificationObservation] else { return }
            
            if let classification = results.first {
                self.carNumber.text = classification.identifier
               // print(self.carNumber.text)
                //self.confidenceLabel.text = "\(classification.confidence)"
            }
            // captureImageはカメラのキャプチャー画像
            guard let ciImage = CIImage(image: self.selectedImg) else { return }
            // VNImageRequestHandlerを作成し、performを実行
            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            guard (try? handler.perform([request])) != nil else { return }
        }
    }
    
    // キーボード表示時
    @objc func keyboardShow() {
        // キーボードを開く際に画面を上にずらす
        self.view.bounds = CGRectMake(0, 370, self.view.frame.size.width, self.view.frame.size.height)
    }
    
    // キーボード非表示時
    @objc func keyboardHide() {
        // キーボードを閉じる際に画面を元に戻す
        self.view.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
    }
    
    // CGRectMakeをwrap
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    @IBAction func onOkButtontapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toResult", sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        carNumber.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toResult") {
            let resultVC: ResultViewController = (segue.destination as! ResultViewController)
            resultVC.carNumString = carNumber.text
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

}

