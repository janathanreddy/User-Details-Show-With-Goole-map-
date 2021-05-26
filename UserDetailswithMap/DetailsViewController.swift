//
//  DetailsViewController.swift
//  UserDetailswithMap
//
//  Created by Admin Macappstudio on 26/05/21.
//

import UIKit
import CoreData
import GoogleMaps
import CoreLocation

class DetailsViewController: UIViewController, GMSMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var MapView: GMSMapView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var agelabel: UILabel!
    @IBOutlet weak var mobilenolabel: UILabel!
    @IBOutlet weak var departmentlabel: UILabel!
    @IBOutlet weak var adresstextfieldview: UITextView!
    var address:String?
    var marker = GMSMarker()
    var gename,gelocality,geadministrativeArea,gecountry,gecountrycode,gepostalcode:String?
    var gelat,gelog:Double?
    
    var locationManager = CLLocationManager()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndPrintEachPerson()
        print("withLatitude : \(gelat) \(gelog)")
        let Camera = GMSCameraPosition.camera(withLatitude: gelat!, longitude: gelog!, zoom: 10.0)
        MapView.camera = Camera
        MapView.isMyLocationEnabled = true
        
        self.Show_Maker(poition: MapView.camera.target)
        self.MapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        MapView.layer.cornerRadius = 3

        // border
        MapView.layer.borderWidth = 1.0
        MapView.layer.borderColor = UIColor.lightGray.cgColor

        // shadow
        MapView.layer.shadowColor = UIColor.black.cgColor
        MapView.layer.shadowOffset = CGSize(width: 3, height: 3)
        MapView.layer.shadowOpacity = 0.7
        MapView.layer.shadowRadius = 4.0

        detailsView.layer.cornerRadius = 3

        // border
        detailsView.layer.borderWidth = 1.0
        detailsView.layer.borderColor = UIColor.lightGray.cgColor

        // shadow
        detailsView.layer.shadowColor = UIColor.black.cgColor
        detailsView.layer.shadowOffset = CGSize(width: 3, height: 3)
        detailsView.layer.shadowOpacity = 0.7
        detailsView.layer.shadowRadius = 4.0

       
    }
    
    func Show_Maker(poition:CLLocationCoordinate2D){
        marker.position = poition
        marker.title = "Location"
        marker.snippet = address
        marker.appearAnimation = .pop
        marker.isDraggable = true
        marker.map = MapView
        DrawCircle()
    }
    func DrawCircle(){
        let CirclePosition = marker.position
        let Circle = GMSCircle(position: CirclePosition, radius: 5)
        Circle.map = MapView
    }

    @IBAction func backbutton(_ sender: Any) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(batchDeleteRequest)
            } catch {
            }
        dismiss(animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let camera = GMSCameraPosition.camera(withLatitude: gelat!, longitude: gelog!, zoom: 17.0)
        self.MapView.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker,coordinate: CLLocationCoordinate2D) -> Bool {
        marker.position = coordinate
            print("position \(marker.position.latitude)")
            print("position marker \(marker.position.longitude)")
            return true
        }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("Did End Drag")
        DrawCircle()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("GMSMapView : \(position.target.latitude) \(position.target.longitude)")
         }
  
    func fetchAndPrintEachPerson() {
        let fetchRequest = NSFetchRequest<Users>(entityName: "Users")
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            for item in fetchedResults {
                gelat = item.value(forKey: "latitude") as? Double
                gelog = item.value(forKey: "longitude") as? Double
                namelabel.text = item.value(forKey: "name") as? String
                agelabel.text = item.value(forKey: "age") as? String
                mobilenolabel.text = item.value(forKey: "mobileno") as? String
                departmentlabel.text = item.value(forKey: "department") as? String
                adresstextfieldview.text = "\(item.value(forKey: "doorno") as! String), \(item.value(forKey: "streetno") as! String), \(item.value(forKey: "city") as! String)"
                print("name \(item.value(forKey: "geoname")!)")
                address = "\(item.value(forKey: "geoname") as! String), \(item.value(forKey: "geolocality") as! String), \(item.value(forKey: "geoadministrativeArea") as! String),\(item.value(forKey: "geocountry") as! String),\(item.value(forKey: "geocountrycode") as! String),\(item.value(forKey: "geopostalcode") as! String)"
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
}
