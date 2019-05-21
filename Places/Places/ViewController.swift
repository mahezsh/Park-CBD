//
//  ViewController.swift
//  Places
//
//  Created by Macbook on 12/5/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lat: UITextField!
    @IBOutlet weak var long: UITextField!
    
    
    var places = [Place]()
    var filteredPlaces = [Place]()
    let queryService = QueryService()
    var sortedPlaces = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseJSONOnline()
        getCurrLoc()

    }
    
    func getCurrLoc(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        var latitude: Double? {
            if let text = lat.text {
                return Double(text)
            } else {
                return nil
            }
        }
        
        var longitude: Double? {
            if let text = long.text {
                return Double(text)
            } else {
                return nil
            }
        }
        
        print("getCurrLoc Clicked")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.lat.text = "\(location.coordinate.latitude)"
            self.long.text = "\(location.coordinate.longitude)"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Location Access Denied",
                                                message: "Please enable your location services.",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if URL(string: UIApplication.openSettingsURLString) != nil {
                print("Open Settings Clicked")
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sorttt( latt : String, longg : String){
        let lattt = (latt as NSString).doubleValue
        let longgg = (longg as NSString).doubleValue
        let LocationAtual: CLLocation = CLLocation(latitude: lattt, longitude: longgg)
        places.sort(by: { $0.distance(to: LocationAtual) < $1.distance(to: LocationAtual) })
        tableView.reloadData()
    }
    
    func grabit() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation();
        
        print(self.lat.text ?? 0)
        print(self.long.text ?? 0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
      
            if let selectionIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectionIndexPath, animated: animated)
            }
        super.viewWillAppear(animated)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var place: Place

        place = places[indexPath.row]
        cell.textLabel!.text = "Marker ID " + place.stMarkerID + "  Bay ID " + place.bayID
        cell.detailTextLabel!.text = "Lat " + place.lat + "  Long " + place.lon
        
        return cell
    }

    @IBAction func sortNearbyClicked(_ sender: Any) {
        sorttt(latt: self.lat.text!, longg: self.long.text!)
    }
    
    @IBAction func getCurrLocClicked(_ sender: Any) {
        getCurrLoc()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    func parseJSONOnline()
    {
        queryService.parseJSONOnline() { results in
            if let results = results {
                self.places = results
                self.tableView.reloadData()
                self.tableView.setContentOffset(CGPoint.zero, animated: false)
            }
        }
    }
    
    }



