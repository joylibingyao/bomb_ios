//
//  MainViewController.swift
//  MindTheMine
//
//  Created by Wei Chung Chuo on 8/19/15.
//  Copyright © 2015 Bingyao Li. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class GameControllerA: UIViewController,CLLocationManagerDelegate
{
    let locationManager = CLLocationManager()
    //let socket = SocketIOClient(socketURL: "http://localhost:5001")
    var name:String?
    var lat:CLLocationDegrees?
    var lon:CLLocationDegrees?
    
    @IBOutlet weak var score: UILabel!
    //    socket
    var socket :SocketIOClient?
    
    
    //--------GPS--UPDATING-------
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //        print(locationManager.location?.coordinate)
        let userName:String = name!
        let lat = locationManager.location!.coordinate.latitude
        let lon = locationManager.location!.coordinate.longitude
        socket!.emit("check",[
            "name":userName,
            "lat":lat,
            "lon":lon
            ])
    }

    @IBAction func dropPressed(sender: UIButton)
    {
        let userName:String = name!
        let lat = locationManager.location!.coordinate.latitude
        let lon = locationManager.location!.coordinate.longitude
        print("dropping bomb")
        socket!.emit("dropPressed",[
            "name":userName,
            "lat":lat,
            "lon":lon
            ])
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //---------GPS---------
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.monitoredRegions
        locationManager.startMonitoringSignificantLocationChanges()
        
        // -----------SOCKET------------------
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = appDelegate.socket
//        -----------USERINFO
        socket!.on("userInfo"){data, ack in
            
            
            print(data![0])
            
            self.score.text = String(data![0])
            
        }
//        --------DROP BOMB-----------
        socket!.on("bombAdded"){data, ack in
            
            self.score.text = String(data![0])
            
        }
//        ---------GET BOMBED-----------
        socket?.on("getBombed"){data, ack in
            print(data![0])
            print("that was id")
//            --NOTIFICATION-------
            let alertController = UIAlertController(title: "Smile", message:
                "U Got BOMBED", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }

    
}

