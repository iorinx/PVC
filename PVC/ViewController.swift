//
//  ViewController.swift
//  PVC
//
//  Created by iorin on 2018/08/31.
//  Copyright © 2018年 iorin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate, AVCapturePhotoCaptureDelegate{

    @IBOutlet weak var cameraButton: UIButton!
    
    var input:AVCaptureDeviceInput!
    var output:AVCapturePhotoOutput!
    var session:AVCaptureSession!
    var carNumPic: UIImage!
    var thumbnailData:Data!
    
    var preView:UIView!
    var camera:AVCaptureDevice!
     private var photoData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable UI. The UI is enabled if and only if the session starts running.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // スクリーン設定
        setupDisplay()
        // カメラの設定
        setupCamera()
        //ボタンの設定
        setupButton()
    }
    
    // camera initialize
    func setupCamera(){
        // セッション
        session = AVCaptureSession()
        
        // 背面・前面カメラの選択
        camera = AVCaptureDevice.default(
            AVCaptureDevice.DeviceType.builtInWideAngleCamera,
            for: AVMediaType.video,
            position: .back) // position: .front
        
        // カメラからの入力データ
        do {
            input = try AVCaptureDeviceInput(device: camera)
            
        } catch let error as NSError {
            print(error)
        }
        
        // 入力をセッションに追加
        if(session.canAddInput(input)) {
            session.addInput(input)
        }
        
        // 静止画出力のインスタンス生成
        output = AVCapturePhotoOutput()
        
        // 出力をセッションに追加
        if(session.canAddOutput(output)) {
            session.addOutput(output)
        }
        
        // セッションからプレビューを表示を
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        previewLayer.frame = preView.bounds
        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        // レイヤーをViewに設定
        // これを外すとプレビューが無くなる、けれど撮影はできる
        self.view.layer.addSublayer(previewLayer)
        self.view.bringSubviewToFront(cameraButton)
        session.startRunning()
    }
    
    func setupDisplay(){
        //スクリーンの幅
        let screenWidth = UIScreen.main.bounds.size.width;
        //スクリーンの高さ
        let screenHeight = UIScreen.main.bounds.size.height;
        
        // プレビュー用のビューを生成
        preView = UIView(frame: CGRect(x: 0.0, y: 0.0,
                                       width: screenWidth, height: screenHeight))
    }
    
    func setupButton(){
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 7
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = 40
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // camera stop メモリ解放
        session.stopRunning()
        
        for output in session.outputs {
            session.removeOutput((output as AVCaptureOutput))
            //session.removeOutput(output)
        }
        
        for input in session.inputs {
            session.removeInput((input as AVCaptureInput))
            //session.removeInput(input)
        }
        session = nil
        camera = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCameraButtonTapped(_ sender: Any) {
        takePicture()
//        let storyboard: UIStoryboard = self.storyboard!
//        let  toDetailPic = storyboard.instantiateViewController(withIdentifier: "toDetailPic")
//        self.present(toDetailPic, animated: true, completion: nil)
    }
    
    func takePicture(){
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = .off
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = false
        output?.capturePhoto(with: photoSettings, delegate: self)
        
    }
    
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
//        if let error = error {
//            print("Error capturing photo: \(error)")
//            return
//        }
//
//        guard photoData != nil else {
//            print("No photo data resource")
//            return
//        }
//
//        //DetailPictureControllerに写真を渡す
//        let photo = UIImage(data: thumbnailData!)
//        let image = UIImage(cgImage: photo!.cgImage!, scale: photo!.scale, orientation: .up)
//        carNumPic = image
//    }
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                    didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            photoData = photo.fileDataRepresentation()
            print("OK")
        }
        
        // Check if UIImage could be initialized with image data
        guard let capturedImage = UIImage.init(data: photoData! , scale: 1.0) else {
            print("Fail to convert image data to UIImage")
            return
        }
        
        // Get original image width/height
        let imgWidth = capturedImage.size.width
        let imgHeight = capturedImage.size.height
        // Get origin of cropped image
        let imgOrigin = CGPoint(x: (imgWidth - imgHeight)/2, y: (imgHeight - imgHeight)/2)
        // Get size of cropped iamge
        let imgSize = CGSize(width: imgHeight, height: imgHeight)
        
        // Check if image could be cropped successfully
        guard let imageRef = capturedImage.cgImage?.cropping(to: CGRect(origin: imgOrigin, size: imgSize)) else {
            print("Fail to crop image")
            return
        }
        
        // Convert cropped image ref to UIImage
        let imageToSave = UIImage(cgImage: imageRef, scale: 1.0, orientation: .up)
        // 後ほど保存するためのData変数
        thumbnailData = imageToSave.pngData()
        carNumPic = imageToSave
        //画像を保存してから画面遷移
        performSegue(withIdentifier: "toDetailPic", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toDetailPic") {
            let detpicVC: DetailPictureController = (segue.destination as! DetailPictureController)
            detpicVC.selectedImg = carNumPic
        }
    }
}
