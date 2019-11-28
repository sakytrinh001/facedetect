//
//  RegisterViewController.swift
//  FaceDetect
//
//  Created by Nguyen Le Minh on 9/26/19.
//  Copyright © 2019 Nguyen Le Minh. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var imgFace: UIImageView!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var viewLoading: UIView!
    
    var thumbnail = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()

        imgFace.image = thumbnail
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRegisterClicked(_ sender: Any) {
        if self.txtFullName.text!.count <= 0 {
            let alert = UIAlertController(title: "", message: "Please input full name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.registerToServer()
    }
    
    func registerToServer() {
        self.viewLoading.isHidden = false
        self.view.endEditing(true)
        let url = "https://picture.vision-vietnam.com/public/aws/api?tab=reg&fullname=\(txtFullName.text ?? "")"
        let aspectScaledToFitImage = thumbnail.scaled(with: 1.0)
        let imageData : Data! = aspectScaledToFitImage!.jpegData(compressionQuality: 1.0)

        Alamofire.upload(multipartFormData: { (multipartFormData) in
                        multipartFormData.append(imageData, withName: "webcam", fileName: "image.png", mimeType: "image/png")
        }, to: NSURL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)! as URL)
                    { (result) in
                        switch result {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                print(response.result.value ?? "")
                                let dic = response.result.value as! Dictionary<String, Any>
                                if (dic["status"] as! String == "registerface_done") {
                                    let alert = UIAlertController(title: "", message: "Register success", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                        self.dismiss(animated: true, completion: nil)
                                        self.navigationController?.popViewController(animated: true)
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                    self.viewLoading.isHidden = true
                                } else {
                                    let alert = UIAlertController(title: "", message: "Register fail", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                        self.dismiss(animated: true, completion: nil)
                                        self.navigationController?.popViewController(animated: true)
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                    self.viewLoading.isHidden = true
                                }
                                
                            }
                            break
                           //Success
                        case .failure(let encodingError):
                            print(encodingError)
                            let alert = UIAlertController(title: "", message: encodingError as! String, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                self.dismiss(animated: true, completion: nil)
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            self.viewLoading.isHidden = true
                            break
                            //Failure
                        }
                    }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
