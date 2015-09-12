//
//  ViewController.swift
//  Trayl
//
//  Created by Aniruddha Nadkarni on 9/11/15.
//  Copyright © 2015 Aniruddha Nadkarni. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var postItemButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    var searchBarIsActive = false
    var location: CLLocation?
    
    let locationManager = CLLocationManager()
    var foundLocation = false
    var postMode = false
    var confirmPresent = false
    
    var droppedPin: MKAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        self.postItemButton.layer.shadowColor = UIColor.grayColor().CGColor
        self.postItemButton.layer.shadowOffset = CGSizeMake(0, 1.0)
        self.postItemButton.layer.shadowOpacity = 1.0
        self.postItemButton.layer.shadowRadius = 8.0
        self.postItemButton.layer.cornerRadius = 5.0
        
        self.confirmButton.layer.shadowColor = UIColor.grayColor().CGColor
        self.confirmButton.layer.shadowOffset = CGSizeMake(0, 1.0)
        self.confirmButton.layer.shadowOpacity = 1.0
        self.confirmButton.layer.shadowRadius = 8.0
        self.confirmButton.layer.cornerRadius = 5.0
        
        self.cancelButton.layer.shadowColor = UIColor.grayColor().CGColor
        self.cancelButton.layer.shadowOffset = CGSizeMake(0, 1.0)
        self.cancelButton.layer.shadowOpacity = 1.0
        self.cancelButton.layer.shadowRadius = 8.0
        self.cancelButton.layer.cornerRadius = 5.0
        
        self.confirmButton.transform = CGAffineTransformMakeTranslation(0, 150)
        self.cancelButton.transform = CGAffineTransformMakeTranslation(0, 120)
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        let tapCheck = UITapGestureRecognizer(target: self, action: "addPin:")
        tapCheck.numberOfTapsRequired = 1
        tapCheck.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(tapCheck)
        
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.hidden = true

        getPoll()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBarIsActive = true
        self.tableView.hidden = false
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBarIsActive = false
        self.tableView.hidden = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        searchBar.endEditing(true)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            // TODO: If user does not authorize
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !foundLocation {
            let location = locations.first
            self.location = location
            mapView.setCamera(MKMapCamera(lookingAtCenterCoordinate: (location?.coordinate)!, fromEyeCoordinate: (location?.coordinate)!, eyeAltitude: 5000.0), animated: false)
            foundLocation = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    @IBAction func postItem(sender: AnyObject) {
        postMode = true
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            self.cancelButton.transform = CGAffineTransformMakeTranslation(0, 0)
            self.postItemButton.alpha = 0.0
            self.postItemButton.transform = CGAffineTransformMakeTranslation(0, 120)
            }) { (bool) -> Void in
        }
        
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
    
    
    @IBAction func cancelPosting(sender: AnyObject) {
        postMode = false
        if (confirmPresent) {
            confirmPresent = false
            self.mapView.removeAnnotation(droppedPin!)
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                self.cancelButton.transform = CGAffineTransformMakeTranslation(0, 120)
                self.confirmButton.transform = CGAffineTransformMakeTranslation(0, 150)
                self.postItemButton.alpha = 1.0
                self.postItemButton.transform = CGAffineTransformMakeTranslation(0, 0)
                }) { (bool) -> Void in
            }
        } else {
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                self.cancelButton.transform = CGAffineTransformMakeTranslation(0, 120)
                self.postItemButton.alpha = 1.0
                self.postItemButton.transform = CGAffineTransformMakeTranslation(0, 0)
                }) { (bool) -> Void in
            }
        }
    }


    
    @IBAction func addPin(recognizer: UITapGestureRecognizer) {
        if (postMode) {
            if !confirmPresent {
                confirmPresent = true
                UIView.animateWithDuration(0.325, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                    self.confirmButton.transform = CGAffineTransformMakeTranslation(0, 0)
                    }) { (bool) -> Void in
                }
            }
            
            let point = recognizer.locationInView(self.mapView)
            let location = mapView.convertPoint(point, toCoordinateFromView: self.view)
            let annotation = PinImageAnnotationView(myCoordinate: location, myPinImage: UIImage(named: "neutral_grey_pin")!)
            
            
            if (droppedPin != nil) {
                self.mapView.removeAnnotation(droppedPin!)
            }
            droppedPin = annotation
            self.mapView.addAnnotation(annotation)
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func getPoll() {
        let url = "http://sca3.canain.com:7000/poll"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            let parsedJSON = JSON(data: data!)
            let dict = parsedJSON.dictionaryValue

            let arr = dict["data"]!.array
            
            for var i = 0; i < arr!.count; i++ {
                let title = arr![i].dictionaryValue["title"]?.stringValue
                let lat = arr![i].dictionaryValue["location"]?.dictionaryValue["lat"]?.doubleValue
                let long = arr![i].dictionaryValue["location"]?.dictionaryValue["long"]?.doubleValue
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(lat!, long!)
                    annotation.title = title
                    self.mapView.addAnnotation(annotation)
                })
            }
        }
        task.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "confirm" {
            let dc = segue.destinationViewController as! CreateItemViewController
            dc.location = self.location
        }
        
    }
    
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = MKAnnotationView()
        pinView.image = UIImage(named: "neutral_grey_pin")
        return pinView
    }
    
    @IBAction func recenter(sender: AnyObject) {
        self.mapView.setCamera(MKMapCamera(lookingAtCenterCoordinate: (self.location?.coordinate)!, fromEyeCoordinate: (self.location?.coordinate)!, eyeAltitude: 5000.0), animated: true)
    }
}

