////
////  DatabaseManager.swift
////  LoginWithFireBase
////
////  Created by apple on 25/07/2023.
////
//
//import Foundation
//
//var shareInstance = DatabaseManager()
//
//class DatabaseManager: NSObject {
//
//    var database: FMDatabase? = nil
//
//    class func getInstance() -> DatabaseManager{
//
//        if shareInstance.database == nil {
//            shareInstance.database = FMDatabase(path: Utils.getPath("Signup.db"))
//        }
//        return shareInstance
//    }
//
//    //Insert IN TO RegINfo (name, username, email, password) VALUES(?,?,?,?)
//
//    func SaveData(_ modelInfo: SignupModel) -> Bool {
//
//        shareInstance.database?.open()
//        let isSave = shareInstance.database?.executeUpdate("INSERT INTO Signup(fname,lname,phone,email) VALUES (?,?,?,?)", withArgumentsIn: [modelInfo.fname,modelInfo.lname,modelInfo.phone,modelInfo.email])
//        shareInstance.database?.close()
//
//        return isSave!
//    }
//}
