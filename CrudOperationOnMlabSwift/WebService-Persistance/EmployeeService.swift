//
//  UserService.swift
//  CrudOperationOnMlabSwift
//
//  Created by Mausam on 12/17/16.
//  Copyright © 2016 Mausam. All rights reserved.
//

import Foundation
import Security

class EmployeeService {
    
    class func getAllEmployees(_ url:URL!, getBack: @escaping (NSError?, Bool, Data?) -> ()){
        var request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: timeout)
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let task:URLSessionDataTask = session.dataTask(with: request as URLRequest) { Data,response,error in
            guard error == nil && Data != nil else {                                                                          print("error=\(error)")
                getBack (error as NSError?, false, nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {                           print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                getBack (error as NSError?, false, Data)
            }
            else{
                getBack (nil,true,Data!)
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    class func createNewEmployee(_ url:URL,employee:Employee,httpMethod:NSString, getBack: @escaping (_ error:NSError?,_ result:Bool,_ resultData:Data?) -> ()){
        
        var request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: timeout)
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        request.httpMethod = httpMethod as String
        
        if let json = employee.toJSON(){
            if let data = json.data(using: .utf8){
              //  if let encryptedData = data.base64EncodedData() as? Data{}
                request.httpBody = data
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task:URLSessionDataTask = session.dataTask(with: request as URLRequest) { Data,response,error in
                    guard error == nil && Data != nil else {                                                                                 print("error=\(error)")
                        getBack (error as NSError?, false, nil)
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {                                  print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                        getBack (error as NSError?, false, Data)
                    }
                        
                    else{
                        
                        //let responseString = NSString(data: Data!, encoding: String.Encoding.utf8.rawValue)
                        //print("responseString = \(responseString!)")
                        getBack (nil,true,Data!)
                    }
                }
                task.resume()
                session.finishTasksAndInvalidate()
            }
        }
        
    }
    
    class func updateExistingEmployee(_ url:URL,id:String, employee:Employee,httpMethod:NSString, getBack: @escaping (_ error:NSError?,_ result:Bool,_ resultData:Data?) -> ()){
        
        let strUrl = url.absoluteString + id + "?" + apiKey
        
        var request = URLRequest(url: URL(string: strUrl)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: timeout)
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        request.httpMethod = httpMethod as String
        
        if let json = employee.toJSON(){
            print(json)
            if let data = json.data(using: .utf8){
                request.httpBody = data
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task:URLSessionDataTask = session.dataTask(with: request as URLRequest) { Data,response,error in
                    guard error == nil && Data != nil else {
                        print("error=\(error)")
                        getBack (error as NSError?, false, nil)
                        return
                    }
                    
                    if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                        getBack (error as NSError?, false, Data)
                    }
                    else {
                        
                        // let responseString = NSString(data: Data!, encoding: String.Encoding.utf8.rawValue)
                        // print("responseString = \(responseString!)")
                        getBack (nil,true,Data!)
                    }
                    
                }
                task.resume()
                session.finishTasksAndInvalidate()
            }
        }
    }
    
    class func deleteExistingEmployee(_ url:URL,id:String,httpMethod:NSString, getBack: @escaping (_ error:NSError?,_ result:Bool,_ resultData:Data?) -> ()){
        
        let strUrl = url.absoluteString + id + "?" + apiKey
        
        var request = URLRequest(url: URL(string: strUrl)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: timeout)
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        request.httpMethod = httpMethod as String
        
        let task:URLSessionDataTask = session.dataTask(with: request as URLRequest) { Data,response,error in
            guard error == nil && Data != nil else {
                print("error=\(error)")
                getBack (error as NSError?, false, nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                getBack (error as NSError?, false, Data)
            }
            else {
                // let responseString = NSString(data: Data!, encoding: String.Encoding.utf8.rawValue)
                // print("responseString = \(responseString!)")
                getBack (nil,true,Data!)
            }
            
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
