//
//  FirebaseOutputData.swift
//  LoginWithFireBase
//
//  Created by apple on 30/07/2023.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Kingfisher

class FirebaseOutputData: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Get Data From FIRBase need
    var getDataArr = [ChattModel]()
    var refrnc = DatabaseReference.init()
    var updateRef = DatabaseReference.init()
    
    
    @IBOutlet var FBRTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refrnc = Database.database().reference()
        
        self.getAllFIRData()
        
////        view.addSubview(FBRTableView)
//        self.FBRTableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    
    
    @IBAction func UpdateBtn(_ sender: UIButton) {
        
//        self.updateFIRData()
    }
    
    
   
    
    
    // MARK: - Table view data source
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(getDataArr.count)
        return getDataArr.count 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.chatModel = getDataArr[indexPath.row]
        
        cell.FBREditBtn.tag = indexPath.row
        cell.FBREditBtn.addTarget(self, action: #selector(updateFIRData), for: .touchUpInside)
        
        cell.FBRDeleteBtn.tag = indexPath.row
        cell.FBRDeleteBtn.addTarget(self, action: #selector(deleteFIRData), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FBRTableView.reloadData()
    }

}

extension FirebaseOutputData {
    
    func getAllFIRData() {
        
        self.refrnc.child("Atta123").queryOrderedByKey().observe(.value) { (SnapShot) in
            self.getDataArr.removeAll()
            if let SnapShot = SnapShot.children.allObjects as? [DataSnapshot]{
                for snap in SnapShot {
                    if let mainDict = snap.value as? [String: AnyObject]{
                        let name = mainDict["Name"] as? String
                        let gmail = mainDict["Gmail"] as? String
                        let password = mainDict["Password"] as? String
                        let profileImgUrl = mainDict["profileImgUrl"] as? String ?? ""
                        self.getDataArr.append(ChattModel(Name: name!,Gmail: gmail!,Password: password!,profileImgUrl: profileImgUrl))
                        print(self.getDataArr.count)
                        print(self.getDataArr)
                        self.FBRTableView.reloadData()
                    }
                }
            }
        }
    }
}



extension FirebaseOutputData {
    
   @objc func updateFIRData(){
        // Your Firebase Realtime Database URL
        let databaseURL = "https://emailpaogin-b8ad3-default-rtdb.firebaseio.com/"

        // The specific path of the sub-entity you want to update
        let subEntityPath = "Atta123/-NaXmS3oVruJmdaYQxvD" // Replace this with the desired path

        
        // Reference to the sub-entity in the database
         updateRef = Database.database().reference(fromURL: databaseURL).child(subEntityPath)

        // Create a dictionary containing the data you want to update
        let updatedData: [String: Any] = [
            "Name": "TestingUpdate1",
            "Gmail": "Testing@gmail.com1",
            "Password": "TestingPas1",
     
            // Add other key-value pairs for the data you want to update
        ]
           
           // Use the `updateChildValues()` method to update the entity
       updateRef.updateChildValues(updatedData) { error, _ in
           if let error = error {
               // Handle the error if necessary
               print("Error updating entity: \(error)")
           } else {
               print("Entity updated successfully.")
           }
       }
    }
    
    @objc func deleteFIRData(){
         // Your Firebase Realtime Database URL
         let databaseURL = "https://emailpaogin-b8ad3-default-rtdb.firebaseio.com/"

         // The specific path of the sub-entity you want to update
         let subEntityPath = "Atta123/-NaXmS3oVruJmdaYQxvD" // Replace this with the desired path

         
         // Reference to the sub-entity in the database
          updateRef = Database.database().reference(fromURL: databaseURL).child(subEntityPath)
            // Use the `updateChildValues()` method to update the entity
            updateRef.removeValue() { error, _ in
                if let error = error {
                    // Handle the error if necessary
                    print("Error updating entity: \(error)")
                } else {
                    print("Entity updated successfully.")
                }
            }
        }
}
