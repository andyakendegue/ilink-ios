//
//  SimpleUserVC.swift
//  ilink
//
//  Created by Capp Andy MIGOUMBI AKENDEGUE on 29/06/2016.
//  Copyright © 2016 Capp Andy MIGOUMBI AKENDEGUE. All rights reserved.
//

import UIKit
import MapKit

class SimpleUserVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    

    
    @IBOutlet var theMap: MKMapView!
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    var j = 0
    
    
    
   
    

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
        theMap.mapType = MKMapType.Standard
        theMap.showsUserLocation = true
        // Do any additional setup after loading the view, typically from a nib.
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let phoneUser = prefs.valueForKey("USERNAME") as? String
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            //self.usernameLabel.text = prefs.valueForKey("USERNAME") as? String
        }
        
        // Get Markers
        
        let requestURL: NSURL = NSURL(string: "http://ilink-app.com/app/select/locations.php")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    var i = 0
                    
                    //if let stations = json["stations"] as? [[String: AnyObject]] {
                    if let stations = json as? [[String: AnyObject]] {
                        
                        for station in stations {
                            
                            if let latit = station["latitude"] as? String {
                                
                                if let longit = station["longitude"] as? String {
                                    let lastname = station["lastname"] as? String
                                    let network = station["network"] as? String
                                    let phone = station["phone"] as? String
                                    let myLat = Double(latit)
                                    let myLong = Double(longit)
                                    
                                    if phoneUser! == phone! {
                                       
                                    }
                                    i += 1
                                    let i = Capital(title: lastname!, coordinate: CLLocationCoordinate2D(latitude: myLat!, longitude: myLong!), info: network!)
                                    self.theMap.addAnnotation(i)
                                    //print(myLat! ,myLong! , lastname!,i,network!)
                                }
                                
                            }
                        }
                        
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                }
                
            }
        }
        
        task.resume()
        
        // End Get markers
        
        

        
        print(phoneUser!)
        
                
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        //theLabel.text = "\(locations[0])"
      
        myLocations.append(locations[0] as! CLLocation)
        
        
        
        let spanX = 0.007
        let spanY = 0.007
        
        
            let newRegion = MKCoordinateRegion(center: theMap.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
            theMap.setRegion(newRegion, animated: true)

       
        
        
    
       
            //let moi = Capital(title: "Je suis ici!", coordinate: theMap.userLocation.coordinate, info: "Home to the 2012 Summer Olympics.")
            //theMap.addAnnotation(moi)
    
        
        
       if (myLocations.count > 1){
            let sourceIndex = myLocations.count - 1
            let destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            theMap.addOverlay(polyline)
        }
 
    }
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return nil
    }
    // Annotation Pin
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        // 1
        let identifier = "Capital"
        
        // 2
        if annotation is Capital {
            // 3
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil {
                //4
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                // 5
                let btn = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
              annotationView!.tintColor = UIColor.purpleColor()

            } else {
                // 6
                annotationView!.annotation = annotation
                annotationView!.tintColor = UIColor.purpleColor()
            }
            
            
            return annotationView
        }
        
        // 7
        return nil
    }
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let capital = view.annotation as! Capital
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    // End Annotation Pin
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

   
    @IBAction func signoutTapped(sender: UIButton) {
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
    
    @IBAction func changeNetwork(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            let allAnnotations = self.theMap.annotations
            self.theMap.removeAnnotations(allAnnotations)
            mynetworkLocations()
            
            print("first segement clicked")
        case 1:
            let allAnnotations = self.theMap.annotations
            self.theMap.removeAnnotations(allAnnotations)
            allLocations()
            print("second segment clicked")
        case 2:
            print("third segemnet clicked")
        default:
            break;
        }
        
    }
   
    @IBAction func zoomControl(sender: UIStepper) {
        switch sender.selected {
        case true:
            print("first segement clicked")
        case false:
            print("second segment clicked")
        
        }
    }
    
    func allLocations() {
        // Get Markers
        
        let requestURL: NSURL = NSURL(string: "http://ilink-app.com/app/select/locations.php")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    var i = 0
                    
                    //if let stations = json["stations"] as? [[String: AnyObject]] {
                    if let stations = json as? [[String: AnyObject]] {
                        
                        for station in stations {
                            
                            if let latit = station["latitude"] as? String {
                                
                                if let longit = station["longitude"] as? String {
                                    let lastname = station["lastname"] as? String
                                    let network = station["network"] as? String
                                    let myLat = Double(latit)
                                    let myLong = Double(longit)
                                    i += 1
                                    let i = Capital(title: lastname!, coordinate: CLLocationCoordinate2D(latitude: myLat!, longitude: myLong!), info: network!)
                                    self.theMap.addAnnotation(i)
                                    //print(myLat! ,myLong! , lastname!,i,network!)
                                }
                                
                            }
                        }
                        
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                }
                
            }
        }
        
        task.resume()
        
        // End Get markers
    }
    
    func mynetworkLocations() {
        
        // Get Markers
        
        let requestURL: NSURL = NSURL(string: "http://ilink-app.com/app/select/locations.php")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    var i = 0
                    
                    //if let stations = json["stations"] as? [[String: AnyObject]] {
                    if let stations = json as? [[String: AnyObject]] {
                        
                        for station in stations {
                            
                            if let latit = station["latitude"] as? String {
                                
                                if let longit = station["longitude"] as? String {
                                    let lastname = station["lastname"] as? String
                                    let network = station["network"] as? String
                                    let myLat = Double(latit)
                                    let myLong = Double(longit)
                                    i += 1
                                    
                                    let i = Capital(title: lastname!, coordinate: CLLocationCoordinate2D(latitude: myLat!, longitude: myLong!), info: network!)
                                    self.theMap.addAnnotation(i)
                                    
                                    //print(myLat! ,myLong! , lastname!,i,network!)
                                }
                                
                            }
                        }
                        
                    }
                    
                }catch {
                    print("Error with Json: \(error)")
                }
                
            }
        }
        
        task.resume()
        
        // End Get markers

        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
