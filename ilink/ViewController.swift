//
//  ViewController.swift
//  ilink
//
//  Created by Capp Andy MIGOUMBI AKENDEGUE on 24/05/2016.
//  Copyright © 2016 Capp Andy MIGOUMBI AKENDEGUE. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var theMap: MKMapView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var theLabel: UILabel!
    
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup our Location Manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        //Setup our Map View
        theMap.delegate = self
        theMap.mapType = MKMapType.standard
        theMap.showsUserLocation = true
        // Do any additional setup after loading the view, typically from a nib.
        let prefs:UserDefaults = UserDefaults.standard()
        let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegue(withIdentifier: "goto_login", sender: self)
        } else {
            //self.usernameLabel.text = prefs.valueForKey("USERNAME") as? String
        }

    }
    
    func locationManager(_ manager:CLLocationManager, didUpdate locations:[CLLocation]) {
        theLabel.text = "\(locations[0])"
        myLocations.append(locations[0] )
        
        let spanX = 0.007
        let spanY = 0.007
        let newRegion = MKCoordinateRegion(center: theMap.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        theMap.setRegion(newRegion, animated: true)
        
        if (myLocations.count > 1){
            let sourceIndex = myLocations.count - 1
            let destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            theMap.add(polyline)
        }
    }
    func mapView(_ mapView: MKMapView!, rendererFor overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue()
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    self.performSegue(withIdentifier: "goto_login", sender: self)
    }

    @IBAction func logoutTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goto_login", sender: self)
    }
}

