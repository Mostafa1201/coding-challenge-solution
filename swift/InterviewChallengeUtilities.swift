//
//  InterviewChallengeUtilities.swift
//

import Foundation

public struct User{
    public var age:Int
    public var gender:String
    public var device:String
    
    init(json:Dictionary<String,AnyObject>){
        age = json["age"] as! Int
        gender = json["gender"] as! String
        device = json["device"] as! String
    }
}

public struct Event{
    public var name: String
    public var timestamp: Int
    public var user_id: String

    init(json:Dictionary<String,AnyObject>){
        name = json["name"] as! String
        timestamp = json["timestamp"] as! Int
        user_id = json["user_id"] as! String
    }
}

typealias Users = Dictionary<String, User>
typealias Events = Array<Event>

func getUsers(filePath: String) -> Users {
    var users = Users()

    do {
        
        let data = try NSData(contentsOfFile: filePath) as Data
        
        if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
            
            let usersJSON = json["users"] as! Dictionary<String,Dictionary<String,AnyObject>>
            for (user_id,userDictionary) in usersJSON{
                users[user_id] = User(json: userDictionary)
            }
        }
    }
    catch let error {
        print("Failed to read users from disk. Error: \(error.localizedDescription)")
    }
    
    return users
}

func getEvents(filePath:String) -> Events{
    var events = Events()
    
    do {
        
        let data = try NSData(contentsOfFile: filePath) as Data
        
        if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
            
            let eventJSON = json["events"] as! Array<Dictionary<String,AnyObject>>
            for eventDictionary in eventJSON{
                events.append(Event(json: eventDictionary))
            }
        }
    }
    catch let error {
        print("Failed to read events from disk. Error: \(error.localizedDescription)")
    }

    return events
}