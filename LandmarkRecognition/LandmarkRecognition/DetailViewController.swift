//
//  DetailViewController.swift
//  LandmarkRecognition
//
//  Created by Muhammet İkbal Yaşar 
//

import UIKit
import CoreLocation
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet var detailTextView: UITextView!
    @IBOutlet var drawRouteButton: UIButton!
    
    var selectedHistoricalPlace : Landmark?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedHistoricalPlace?.name
        detailTextView.text = selectedHistoricalPlace?.description
        
    }
    
    @IBAction func drawRouteButtonTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Uyarı", message: "Navigasyon uygulamasına yönlendiriliyorsunuz !", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            
            let coordinates = CLLocationCoordinate2DMake(self.selectedHistoricalPlace?.lat ?? 0.0, self.selectedHistoricalPlace?.lon ?? 0.0
            )
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = self.selectedHistoricalPlace?.name
            let options = [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ]
            mapItem.openInMaps(launchOptions: options)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
