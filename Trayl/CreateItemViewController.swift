//
//  CreateItemViewController.swift
//  Trayl
//
//  Created by Nikhil Kulkarni on 9/12/15.
//  Copyright © 2015 Aniruddha Nadkarni. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class CreateItemViewController: UIViewController {
    
    override func viewDidLoad() {
        //TODO: Add lost item
//        addItem("4048600194", itemName: "Basketball", itemDescription: "NCAA Wilson basketball", contact: "404-860-0194", location: CLLocationCoordinate2DMake(37.3, -120.0))
    }
    
    func addItem(phone: String, itemName: String, itemDescription: String, contact: String, location: CLLocationCoordinate2D) {
        let url = "http://sca3.canain.com:7000/add"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"phone\": \"\(phone)\" \n,\"data\": {\n \"\(title)\": \"Basketball\",\n \"description\": \"\(description)\",\n\"contact\": \"434-260-1893\",\n\"location\": {\n\"lat\": \"\(location.latitude.description)\",\n\"long\": \"\(location.longitude)\"}}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            print(response)
            let parsedJSON = JSON(data: data!)
            print(parsedJSON)
        }
        task.resume()
    }

}
