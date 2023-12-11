//
//  FireBaseData.swift
//  LoginWithFireBase
//
//  Created by apple on 29/07/2023.
//

import Foundation

//Data Used To Save Data
struct Variables {
    var DBEntityName: String?
    var TitleName: String?
    var GmailId: String?
    var Password: String?
}


// Data Used to FatchData
class ChattModel {
    var Name: String?
    var Gmail: String?
    var Password: String?
    var profileImgUrl: String?
    
    init(Name: String? = nil, Gmail: String? = nil, Password: String? = nil, profileImgUrl: String? = nil) {
        self.Name = Name
        self.Gmail = Gmail
        self.Password = Password
        self.profileImgUrl = profileImgUrl
    }

}


