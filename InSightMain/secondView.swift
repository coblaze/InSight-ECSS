//
//  secondView.swift
//  InSight
//
//  
//



import UIKit
import MapKit
import CoreLocation
import AVFoundation
import Speech


class secondView: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var secondViewMap: MKMapView!
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    fileprivate let geocoder: CLGeocoder = CLGeocoder()
    fileprivate let speechSynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    private var hasSpoken = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request location permission
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        secondViewMap.showsUserLocation = true
        
        // Request microphone permission
        AVAudioSession.sharedInstance().requestRecordPermission { (isGranted) in
            if !isGranted {
                // Handle case where user did not grant microphone permission
                print("Microphone access denied")
            }
        }
    }

    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            secondViewMap.setRegion(region, animated: true)
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let placemark = placemarks?.first {
                    let city = placemark.locality ?? ""
                    let address = placemark.name ?? ""
                    print("You are in \(city), at address: \(address)")
                    
                    // Text-to-speech engine to say the city and address to the user
                    if !self.hasSpoken {
                        let say = AVSpeechUtterance(string: "You are in \(city), at address: \(address). Tap anywhere to begin navigating")
                        say.volume = 5.0
                        self.speechSynthesizer.speak(say)
                        
                        self.hasSpoken = true
                    
                    }
                    
                }
            }
        }
    }
    
    
    @IBAction func toThird(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "voiceVC") as! thirdView
        present(vc, animated: true)
        
        
        
        
    }
}

