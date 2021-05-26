//
//  ViewController.swift
//  UserDetailswithMap
//  Created by Admin Macappstudio on 25/05/21.
//

import UIKit
import CoreData
import CoreLocation
import GoogleMaps

class ViewController: UIViewController, UITextFieldDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var SignUpView: UIView!
    @IBOutlet weak var CityText: UITextField!
    @IBOutlet weak var StreetText: UITextField!
    @IBOutlet weak var Doorno: UITextField!
    @IBOutlet weak var MobileNumText: UITextField!
    @IBOutlet weak var departmentText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    
    var locationManager:CLLocationManager!
    var gename,gelocality,geadministrativeArea,gecountry,gecountrycode,gepostalcode:String?
    var gelat,gelog:Double?
    var create = [Users]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
      
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
        
        CityText.delegate = self
        StreetText.delegate = self
        Doorno.delegate = self
        MobileNumText.delegate = self
        departmentText.delegate = self
        ageText.delegate = self
        nameText.delegate = self
        ViewShawdow()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation

        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")

        gelat = userLocation.coordinate.latitude
        gelog = userLocation.coordinate.longitude
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { [self] (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                
                gename = placemark.name!
                gelocality = placemark.locality!
                geadministrativeArea = placemark.administrativeArea!
                gecountry = placemark.country!
                gepostalcode = placemark.postalCode!
                gecountrycode = placemark.isoCountryCode!
                
                print("name : \(placemark.name!)")
                print("locality \(placemark.locality!)")
                print("administrativeArea : \(placemark.administrativeArea!)")
                print("country \(placemark.country!)")
                print("CountryCode: \(placemark.isoCountryCode!)")
                print(placemark.postalCode!)

            }
        }

    }

    func CreatData() {
       
        let User = Users(context: self.context)
        User.name = nameText.text ?? ""
        User.age = ageText.text ?? ""
        User.city = CityText.text ?? ""
        User.department = departmentText.text ?? ""
        User.mobileno = MobileNumText.text ?? ""
        User.doorno = Doorno.text ?? ""
        User.streetno = StreetText.text ?? ""
        User.latitude = gelat ?? 9.5139
        User.longitude = gelog ?? 78.1002
        User.geocountry = gecountry ?? ""
        User.geoadministrativeArea = geadministrativeArea ?? ""
        User.geocountrycode = gecountrycode ?? ""
        User.geolocality = gelocality ?? ""
        User.geoname = gename ?? ""
        User.geopostalcode = gepostalcode ?? ""
        create.append(User)
        saveCategories()
        
    }
    
    func saveCategories(){
        do{
            try context.save()
        }catch {
            print("Error saving Task with \(error)")
        }
    }
    
    func ViewShawdow(){
        // corner radius
        SignUpView.layer.cornerRadius = 3

        // border
        SignUpView.layer.borderWidth = 1.0
        SignUpView.layer.borderColor = UIColor.lightGray.cgColor

        // shadow
        SignUpView.layer.shadowColor = UIColor.black.cgColor
        SignUpView.layer.shadowOffset = CGSize(width: 3, height: 3)
        SignUpView.layer.shadowOpacity = 0.7
        SignUpView.layer.shadowRadius = 4.0

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            var point = SignUpView.frame.origin
            point.y = 19
            point.x = 0
            scrolView.setContentOffset(point, animated: true)
            nextField.becomeFirstResponder()
        } else {
           textField.resignFirstResponder()
            DismissKeyboard()
        }
        return false
      }
    
    func HideKeyboard() {
      let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self , action: #selector(DismissKeyboard))
      view.addGestureRecognizer(Tap)
    }
    
    @objc func DismissKeyboard(){
    var point = SignUpView.frame.origin
    point.y = 0
    point.x = 0
    scrolView.setContentOffset(point, animated: true)
    view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameText{
            scrolView.setContentOffset(CGPoint(x: 0, y: 19), animated: true)
        }else if textField == ageText{
            scrolView.setContentOffset(CGPoint(x: 0, y: 38), animated: true)
        }else if textField == departmentText{
            scrolView.setContentOffset(CGPoint(x: 0, y: 57), animated: true)
        }else if textField == MobileNumText{
            scrolView.setContentOffset(CGPoint(x: 0, y: 76), animated: true)
        }else if textField == Doorno{
            scrolView.setContentOffset(CGPoint(x: 0, y: 95), animated: true)
        }else if textField == StreetText{
            scrolView.setContentOffset(CGPoint(x: 0, y: 114), animated: true)
        }else if textField == CityText{
            scrolView.setContentOffset(CGPoint(x: 0, y: 133), animated: true)
        }
        
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("GMSMapView user : \(position.target.latitude) \(position.target.longitude)")
         }
    @IBAction func seedetails(_ sender: Any) {
        DismissKeyboard()
        
        let mobileno = MobileNumText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Name = nameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Age = ageText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let MobileNum = MobileNumText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Department = departmentText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Dooro = Doorno.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let street = StreetText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let city = CityText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Name.isEmpty == true || mobileno.isEmpty == true || Age.isEmpty == true || MobileNum.isEmpty == true || Department.isEmpty == true || Dooro.isEmpty == true || street.isEmpty == true || street.isEmpty == true || city.isEmpty == true{
            
            let alertController = UIAlertController(title: "Alert", message:
                "Fill All Fields", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
        }
        else if mobileno.count < 10 || mobileno.count > 10{
          print("Enter Your 10 Digits Mobile Number")
            
            let alertController = UIAlertController(title: "Alert", message:
                "Check Your Mobile Number", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)

        }else{
            CreatData()
            nameText.text = ""
            ageText.text = ""
            departmentText.text = ""
            MobileNumText.text = ""
            Doorno.text = ""
            StreetText.text = ""
            CityText.text = ""
            performSegue(withIdentifier: "home", sender: self)
        }
    }
    
    
}

