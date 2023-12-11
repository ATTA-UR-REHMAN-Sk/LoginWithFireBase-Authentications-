//
//  FirebaseDataBase.swift
//  LoginWithFireBase
//
//  Created by apple on 28/07/2023.
//
import UIKit
import FirebaseDatabase
import FirebaseStorage

class FirebaseDataBase: UIViewController {
    
    private let database = Database.database().reference()
    var Data = Variables()
 
    
   
    var ImgPicker = UIImagePickerController()
    
    // Outlets for Textfields
    var DBEntityName: UITextField!
    var TitleName: UITextField!
    var GmailId: UITextField!
    var Password: UITextField!
    var AddButton: UIButton!
    var btnImgPick: UIButton!
    var pickedImg: UIImage?
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: 200, height: 80))
        imageView.image = pickedImg ?? UIImage(named: "bird")
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 20
        view.addSubview(imageView)
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(FirebaseDataBase.openGsallery(tapGesture:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)

        
        DBEntityName = UITextField(frame: CGRect(x: 30, y: 200, width: 300, height: 30))
        //TitleName.placeholder = "Enter Title"
        DBEntityName.textColor = .orange
        DBEntityName.backgroundColor = .white
        view.addSubview(DBEntityName)
        
        TitleName = UITextField(frame: CGRect(x: 30, y: 240, width: 300, height: 30))
        //TitleName.placeholder = "Enter Title"
        TitleName.textColor = .orange
        TitleName.backgroundColor = .white
        view.addSubview(TitleName)
        
        GmailId = UITextField(frame: CGRect(x: 30, y: 280, width: 300, height: 30))
        //GmailId.placeholder = "Enter GmailId"
        GmailId.textColor = .blue
        GmailId.backgroundColor = .white
        view.addSubview(GmailId)
        
        Password = UITextField(frame: CGRect(x: 30, y: 320, width: 300, height: 30))
        //Password.placeholder = "Enter Password"
        Password.textColor = .black
        Password.backgroundColor = .white
        view.addSubview(Password)
  
        AddButton = UIButton(frame: CGRect(x: 50, y: 360, width: 200, height: 30))
        AddButton.setTitle("Add Entry", for: .normal)
        AddButton.setTitleColor(.white, for: .normal)
        AddButton.backgroundColor = .link
        view.addSubview(AddButton)
        AddButton.addTarget(self, action: #selector(addNewEntry), for: .touchUpInside)
        
        
       let ShowDataButton = UIButton(frame: CGRect(x: 300, y: 360, width: 100, height: 30))
        ShowDataButton.setTitle("Show Data", for: .normal)
        ShowDataButton.setTitleColor(.systemGray4, for: .normal)
        ShowDataButton.backgroundColor = .darkGray
        view.addSubview(ShowDataButton)
        ShowDataButton.addTarget(self, action: #selector(showFIRData), for: .touchUpInside)
    }
    
    @objc func openGsallery(tapGesture: UITapGestureRecognizer){
        self.ImagePickerMethod()
    }
    
    @objc func showFIRData() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirebaseOutputData") as! FirebaseOutputData
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func addNewEntry() {
        Data.DBEntityName = DBEntityName.text
        Data.TitleName = TitleName.text
        Data.GmailId = GmailId.text
        Data.Password = Password.text
        
        if (DBEntityName.text == "" || TitleName.text == "" || GmailId.text == "" || Password.text == "") {
            let alert = UIAlertController(title: "Fields Missing?", message: "You had missed some textFields, Complete all the fields First", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action:UIAlertAction!) in
                alert.dismiss(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            AddButton.setTitleColor(.systemGray4, for: .normal)
            AddButton.backgroundColor = .darkGray
//            database.child(Data.DBEntityName!).observeSingleEvent(of: .value, with: {
//                DataSnapshot in
//                guard let value = DataSnapshot.value as? [String: Any] else {
//                    return
//                }
//                print("Value : \(value)")
//            })
            
            let alert = UIAlertController(title: "Data Successfully Uploded", message: "You had successfully uploded textFields data.", preferredStyle: .alert)
          
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [self, weak alert] (_) in
                
                saveFIRData()
                alert?.dismiss(animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func saveFIRData() {
        //        let object: [String: Any] = [
        //            "Name": Data.TitleName!, "Gmail": Data.GmailId!, "Password": Data.Password!  as NSObject, "RegisteredId": "yes"]
        //        self.database.child("\(Data.DBEntityName ?? Data.TitleName!)\(Int.random(in: 0..<100))").setValue(object)
        self.uploadImg(self.imageView.image!) { url in
            
            self.saveImage(name: self.Data.TitleName!, gmail: self.Data.GmailId!, password: self.Data.Password!, profileURL: url!){ success in
                if success != nil {
                    print("Yeah Yes")
                }
            }
        }
    }
}

extension FirebaseDataBase: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   @objc func ImagePickerMethod() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            ImgPicker.sourceType = .savedPhotosAlbum
            ImgPicker.delegate = self
            ImgPicker.isEditing = true
            
            imageView.image = pickedImg ?? UIImage(named: "bird")
            
            self.present(ImgPicker, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        pickedImg = image
        imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
}


extension FirebaseDataBase {
    
    func uploadImg(_ image:UIImage, completation: @escaping((_ url: URL?) -> ())) {
        let storageRef = Storage.storage().reference().child(Data.TitleName! + ".png")
        let imgData = imageView.image?.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storageRef.putData(imgData!, metadata: metaData) { (metaData, error) in
            if error == nil {
                print("success")
                storageRef.downloadURL(completion: { (url, error) in
                    completation(url!)
                })
            } else {
                print("error in save image")
                completation(nil)
            }
        }
    }
    

    
    
    
    /*
     let object: [String: Any] = [
         "Name": Data.TitleName!, "Gmail": Data.GmailId!, "Password": Data.Password!  as NSObject, "RegisteredId": "yes"]
     self.database.child("\(Data.DBEntityName ?? Data.TitleName!)\(Int.random(in: 0..<100))").setValue(object)
     */
    
    func saveImage(name: String,gmail: String,password: String, profileURL: URL, completation: @escaping((_ url: URL?) -> ())) {
        let dict = [ "Name": name, "Gmail": gmail, "Password": password, "RegisteredId": "yes", "profileImgUrl":profileURL.absoluteString] as! [String : Any]
        self.database.child(Data.DBEntityName ?? Data.TitleName!).childByAutoId().setValue(dict)
    }
    
    
}
