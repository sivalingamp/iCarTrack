//
//  UserDefault.swift
//  DataPlatform
//
//  Created by siva lingam on 16/5/21.
//

import Foundation

struct UserDefault {
    
    static let (nameKey, usernameKey) = ("name", "username")
    static let userSessionKey = "com.save.usersession"
    private static let userDefault = UserDefaults.standard
    
    /**
       - Description - It's using for the passing and fetching
                    user values from the UserDefaults.
     */
    struct LastLoggedInUser {
        let name: String
        let username: String
        
        init(_ json: [String: String]) {
            self.name = json[nameKey] ?? ""
            self.username = json[usernameKey] ?? ""
        }
    }
    
    /**
     - Description - Saving user details
     - Inputs - name `String` & address `String`
     */
    static func save(_ name: String, username: String){
        userDefault.set([nameKey: name, usernameKey: username],
                        forKey: userSessionKey)
    }
    
    /**
     - Description - Fetching Values via Model `LastLoggedInUser` you can use it based on your uses.
     - Output - `LastLoggedInUser` model
     */
    static func getLastLoggedInUser()-> LastLoggedInUser {
        return LastLoggedInUser((userDefault.value(forKey: userSessionKey) as? [String: String]) ?? [:])
    }
    
    /**
        - Description - Clearing user details for the user key `com.save.usersession`
     */
    static func clearUserData(){
        userDefault.removeObject(forKey: userSessionKey)
    }
}
