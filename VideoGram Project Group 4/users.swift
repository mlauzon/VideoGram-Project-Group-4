//
//  UserBase.swift
//  VideoGram
//
//  Created by student on 9/19/18.
//  Copyright © 2018 The-Windows-Specialists. All rights reserved.
//

import Foundation
import CloudKit


// ToDo: Add email verification when registering, send an email to users
//enum RegistrationResults {
//    case InvalidEmailAddress
//    case PasswordNotStrongEnough
//    case RegistrationFailed
//    case SuccessfulRegistration
//}

enum LoginResults {
    case UsernameDoesNotExist
    case UsernameExists
    case IncorrectPassword
    case SuccessfulLogin
}

struct User {
    var username: String = ""
    var password: String = ""
    //var email: String = ""
}

class UserBase{
    static let CKUsers = UserBase()
    
    var users: [User] = []
    var privateCKDatabase: CKDatabase = CKContainer.default().privateCloudDatabase
    var publicCKDatabase: CKDatabase = CKContainer.default().publicCloudDatabase
    var sharedCKDatabase: CKDatabase = CKContainer.default().sharedCloudDatabase
    
    private init() {
    }
    
    func testCKConnection() -> Bool {
        if let _ = FileManager.default.ubiquityIdentityToken {
            return true
        }
        else {
            return false
        }
    }
    
    func loadUserBase() {
        users = []
        
        let predicate = NSPredicate(value:true)
        let query = CKQuery(recordType: "User", predicate: predicate)
        privateCKDatabase.perform(query, inZoneWith: nil) { (records: [CKRecord]?, error: Error?) in
            if error == nil {
                guard let records = records else {
                    print ("No Records")
                    return
                }
                for record in records {
                    let username = record.object(forKey: "username") as! String
                    let password = record.object(forKey: "password") as! String
                    self.addUser(username: username, password: password)
                }
            }
            else {
                print (error?.localizedDescription ?? "Error")
            }
            
        }
    }
    
    func saveUserBase() {
        let record = CKRecord(recordType: "User")
        
        for user in users {
            record.setObject(user.username as CKRecordValue?, forKey: "username")
            record.setObject(user.password as CKRecordValue?, forKey: "password")
            privateCKDatabase.save(record) { (savedRecord: CKRecord?, error: Error?) -> Void in
                if error == nil {
                    return
                }
            }
        }
    }
    
    func addUser(username: String, password: String) {
        let newUser = User(username: username, password: password)
        users.append(newUser)
    }
    
    func verifyUser(username: String)->LoginResults{
        if users.contains(where: {$0.username == username.lowercased()}) {
            return .UsernameExists
        }
        else {
            return .UsernameDoesNotExist
        }
    }
    
    func login(username: String, password: String)->LoginResults {
        let verification = verifyUser(username: username)
        
        if let user = users.first(where: {$0.username == username.lowercased()}) {
            if verification == .UsernameExists {
                if user.password == password {
                    return .SuccessfulLogin
                }
            }
        }
        return .IncorrectPassword
    }
    
    
    //TODO
    //Add register throughu Social Media
    //Add email verification when registering new account
    //Check for password complexity when registering new account
    //Add 2-step verification
    
}


