//
//  ViewController.swift
//  MindTheMine
//
//  Created by Wei Chung Chuo on 8/19/15.
//  Copyright © 2015 Bingyao Li. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class StartController: UIViewController, CLLocationManagerDelegate {
    //    let socket = SocketIOClient(socketURL: "http://localhost:5001")
    var socket: SocketIOClient?
    @IBOutlet weak var name: UITextField!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = appDelegate.socket
        
        //----------GPS----------------
        print("turning on")
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    //    --------------GPS UPdate-----------
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(locationManager.location!.coordinate)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "startPressed") {
            var svc = segue!.destinationViewController as! GameControllerA;
            
            svc.name = name.text;
            svc.lat = locationManager.location!.coordinate.latitude
            svc.lon = locationManager.location!.coordinate.longitude
        }
    }
    @IBAction func startPressed(sender: UIButton)
    {
        let userName:String = name.text!
        let lat = locationManager.location!.coordinate.latitude
        let lon = locationManager.location!.coordinate.longitude
        socket!.emit("startPressed",[
            "name":userName,
            "lat":lat,
            "lon":lon
            ])
    }
    
    
}

