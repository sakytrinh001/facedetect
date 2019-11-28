//
//  MainViewController.swift
//  FaceDetect
//
//  Created by Nguyen Le Minh on 9/26/19.
//  Copyright © 2019 Nguyen Le Minh. All rights reserved.
//

import UIKit
import Photos
import Alamofire
import Crashlytics

class MainViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var viewRegister: UIView!
    @IBOutlet weak var imgFace: UIImageView!
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var lbStep: UILabel!
    @IBOutlet weak var lbNickName: UILabel!
    
    var thumbnail = UIImage()
    let picker = UIImagePickerController()
    var countStep = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
    }
    @IBAction func actSettings(_ sender: Any) {
        let vc = ListNickNameViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnRegisterByImageClicked(_ sender: Any) {
        self.picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)

    }
    
    @IBAction func btnRegisterByCameraClicked(_ sender: Any) {
        self.picker.sourceType = .camera
        self.picker.cameraDevice = .front
        self.present(picker, animated: true, completion: nil)
    }

    @IBAction func btnCheckFaceClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "segueMainCheckFace", sender: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        thumbnail = image
        self.dismiss(animated: true, completion: nil)
        self.imgFace.image = thumbnail
        self.viewRegister.isHidden = false
        if countStep == 0 {
            self.lbStep.text = "First time"
        } else if countStep == 1 {
            self.lbStep.text = "Second time"
        } else {
            self.lbStep.text = "Last time"
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMainRegister" {
            let vc = segue.destination as! RegisterViewController
            vc.thumbnail = self.thumbnail
        }
    }

    @IBAction func btnBackRegisterClicked(_ sender: Any) {
        self.viewRegister.isHidden = true
        self.countStep = 0
        self.txtFullname.text = ""
    }
    
    @IBAction func btnRegisterClicked(_ sender: Any) {
        if self.txtFullname.text!.count <= 0 {
            self.notifyError("Please input full name", action: {
                self.dismiss(animated: true, completion: nil)
            })
            
            return
        }
        
        self.registerToServer()
    }
    
    func registerToServer() {
        self.viewLoading.isHidden = false
        self.view.endEditing(true)
        let url = "https://picture.vision-vietnam.com/public/aws/api?tab=reg&fullname=\(self.txtFullname.text ?? "")"
        let aspectScaledToFitImage = thumbnail.scaled(with: 0.3)
        
        let imageData : Data! = aspectScaledToFitImage!.jpegData(compressionQuality: 0.6)
        print("imageData: \(imageData!)")
        
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
                                    if self.countStep == 2 {
                                        let alert = UIAlertController(title: "", message: "Register success", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                            self.dismiss(animated: true, completion: nil)
                                            self.viewRegister.isHidden = true
                                            self.countStep = 0
                                            self.txtFullname.text = ""
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                    } else {
                                        self.present(self.picker, animated: true, completion: nil)
                                        self.countStep += 1
                                    }
                                    
                                    self.viewLoading.isHidden = true
                                } else {
                                    let alert = UIAlertController(title: "", message: "Register fail, please try again", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                        self.dismiss(animated: true, completion: nil)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension MainViewController: ListNickNameViewControllerDelegate{
    
    func passDataItemLocker(_ item: ListLockerModel) {
        self.lbNickName.text = item.nickname
    }
    
}
