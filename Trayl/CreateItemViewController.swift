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

class CreateItemViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var descriptionField: UITextField!
    @IBOutlet var contactField: UITextField!
    @IBOutlet var sendToShuyangButton: UIButton!
    var location : CLLocation?
    var lost: Bool = true
    
    override func viewDidLoad() {
        //TODO: Add lost item
//        addItem("4048600194", itemName: "Basketball", itemDescription: "NCAA Wilson basketball", contact: "404-860-0194", location: CLLocationCoordinate2DMake(37.3, -120.0))
    
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        self.sendToShuyangButton.layer.shadowColor = UIColor.grayColor().CGColor
        self.sendToShuyangButton.layer.shadowOffset = CGSizeMake(0, 1.0)
        self.sendToShuyangButton.layer.shadowOpacity = 1.0
        self.sendToShuyangButton.layer.shadowRadius = 8.0
        self.sendToShuyangButton.layer.cornerRadius = 5.0
        
        print(self.location)
        titleField.delegate = self
        descriptionField.delegate = self
        contactField.delegate = self
    }
    
    @IBAction func sendToShuyang(sender: AnyObject) {
        if titleField.text == "" || descriptionField.text == "" || contactField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Fill out all fields", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            addItem("1234567890", itemName: titleField.text!, itemDescription: descriptionField.text!, contact: contactField.text!, location: self.location!.coordinate)
            
        }
    }
    
    @IBAction func segmentation(sender: AnyObject) {
        let segment = sender as! UISegmentedControl
        if segment.selectedSegmentIndex == 0 {
            lost = true
        } else {
            lost = false
        }
    }
    
    func addItem(phone: String, itemName: String, itemDescription: String, contact: String, location: CLLocationCoordinate2D) {
        let url = "http://sca3.canain.com:7000/add"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"phone\": \"\(phone)\" \n,\"data\": {\n \"title\": \"\(itemName)\",\n \"description\": \"\(description)\",\n\"contact\": \"434-260-1893\", \n \"lost\": \(self.lost),\n\"location\": {\n\"lat\": \(location.latitude.description),\n\"long\": \(location.longitude)}}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            print(response)
            let parsedJSON = JSON(data: data!)
            print(parsedJSON)
        }
        task.resume()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        titleField.endEditing(true)
        descriptionField.endEditing(true)
        contactField.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("Hopefully this prints")
        if (textField == titleField) {
            descriptionField.becomeFirstResponder()
        } else if (textField == descriptionField) {
            contactField.becomeFirstResponder()
        } else {
            contactField.resignFirstResponder()
        }
        
        return true
    }

}
