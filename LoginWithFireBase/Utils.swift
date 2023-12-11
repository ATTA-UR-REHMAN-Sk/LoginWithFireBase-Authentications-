////
////  Utils.swift
////  LoginWithFireBase
////
////  Created by apple on 25/07/2023.
////
//
//import Foundation
//
//class Utils: NSObject {
//    
//    
//    class func getPath(_ fileName: String) -> String {
//        
//        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let fileUrl = documentDirectory.appendingPathExtension(fileName)
//        
//        print("Database Path: ",fileUrl.path)
//        
//        return fileUrl.path
//    }
//    
//    
//    class func copyDatabase (_ fileName: String) -> String {
//        
//        let dbPath = getPath("Signup.db")
//        let fileMAnager = FileManager.default
//        
//        if fileMAnager.fileExists(atPath: dbPath) {
//            let bundl = Bundle.main.resourceURL
//            let file = bundl?.appendingPathExtension(fileName)
//            var error: NSError?
//            do{
//                try fileMAnager.copyItem(atPath: (file?.path)!, toPath: dbPath)
//            } catch let error1 as NSError {
//                error = error1
//            }
//            
//            if error == nil {
//                return "Database copy successful!"
//            } else {
//                return "Error copying database: \(error?.localizedDescription ?? "Unknown error")"
//            }
//        }
//    } 
//}
