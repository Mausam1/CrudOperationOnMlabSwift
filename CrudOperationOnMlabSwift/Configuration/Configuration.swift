//
//  Configuration.swift
//  CrudOperationOnMlabSwift
//
//  Created by Mausam on 12/18/16.
//  Copyright © 2016 Mausam. All rights reserved.
//

import Foundation
import UIKit

let baseUrlString = "https://api.mongolab.com/api/1/databases/"
let databaseName = "iosdemo" //Enter your database name
let section = "collections"
let collectionName = "employee" // Enter your collection name
let yourApiKey = "" // Enter yout mlab account api key
let apiKey = "apiKey=\(yourApiKey)"
let headers = [
    "Content-Type": "application/json"
]

let timeout = 10 as TimeInterval

let errorMessage = "Something went wrong, Please try again"

var baseUrlWithKey:URL = URL(string: baseUrlString + databaseName + "/" + section + "/" + collectionName + "?" + apiKey )!

var baseUrl:URL = URL(string: baseUrlString + databaseName + "/" + section + "/" + collectionName + "/")!

let appDelegate = UIApplication.shared.delegate as! AppDelegate

//var allEmployees = [AnyObject]()

var allEmployees = AllEmployeeStruct<AnyObject>()


let allEmployeeIndicatorMsg = "Fetching..."

let createNewEmployeeIndicatorMsg = "Creating..."

let updateExistingEmployeeIndicatorMsg = "Updating..."

let deleteExistingEmployeeIndicatorMsg = "Deleting..."

let context = appDelegate.persistentContainer.viewContext


