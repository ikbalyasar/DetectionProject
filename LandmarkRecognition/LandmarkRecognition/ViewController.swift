//
//  ViewController.swift
//  LandmarkRecognition
//
//  Created by Muhammet İkbal Yaşar 
//

import UIKit
import MapKit
import CoreLocation
import Vision

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet var landmarkImageView: UIImageView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var predictionTable: UITableView!
    @IBOutlet var locationButton: UIButton!
    // MARK: - Locations Variables
    private var locationManager = CLLocationManager();
    private var userLocation: CLLocationCoordinate2D?;
    private var pin : PoiPin?
    private var count = 0
    private var results: [VNClassificationObservation] = []
    private var selectedResult: String?
    var selectedLandmark: Landmark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Title
        self.title = "Landmark Recognition"
        self.predictionTable.delegate = self
        self.predictionTable.dataSource = self
        //LocationButton
        self.locationButton.addShadow(opacitiy: 0.7, shadowRadius: 2, shadowOffsetWidth: 1, shadowOffsetHeight: 1, shadowColor: .darkGray, backgroundColor: .white)
        self.locationButton.addCornerRadius(cornerRadius: 26)
        
        initializeLocationManager()
        //print(Constants.historicalInfo.maidensTower)
        print(Landmark.allValue[0].description)
    }
    
    //Location button tapped
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        if let location = locationManager.location?.coordinate {
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01));
            mapView.setRegion(region, animated: true);
            
        }
    }
    
    //Camera button tapped
    @IBAction func camera(_ sender: UIBarButtonItem) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        
        present(cameraPicker, animated: true)
    }
    
    //Photo library button tapped
    @IBAction func openLibrary(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    //Initialize Location Manager
    private func initializeLocationManager() {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        if let location = locationManager.location?.coordinate {
            
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01));
            mapView.setRegion(region, animated: true);
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "predictionCell", for: indexPath) as? PredictionCell {
            
            cell.predictionName.text = results[indexPath.row].identifier
            cell.predictionConfidence.text = String(format: "%3.2f%%", results[indexPath.row].confidence * 100)
            cell.selectionStyle = UITableViewCellSelectionStyle.blue
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedLandmarkName = results[indexPath.row].identifier
        selectedLandmark = Landmark.allValue.first{$0.name == selectedLandmarkName}
        print(selectedLandmark?.name ?? "None")
        let destinationLocation = CLLocationCoordinate2DMake(selectedLandmark!.lat, selectedLandmark!.lon)
        let region = MKCoordinateRegion(center: destinationLocation, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005));
        self.mapView.setRegion(region, animated: true);
        self.pin = PoiPin(title: selectedLandmark!.name, coordinate:destinationLocation)
        self.mapView.addAnnotation(self.pin!)
        self.mapView.selectAnnotation(self.pin!, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of:PoiPin.self)  {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            view.pinTintColor = #colorLiteral(red: 0, green: 0.4874866009, blue: 0.6860607862, alpha: 1)
            view.tintColor = #colorLiteral(red: 0, green: 0.4874866009, blue: 0.6860607862, alpha: 1)
            view.isEnabled = true
            view.animatesDrop = true
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegue(withIdentifier: "showDetailsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsSegue"{
            let detailVC = segue.destination as! DetailViewController
            detailVC.selectedHistoricalPlace = selectedLandmark
        }
    }
    
    lazy var classificationRequest: VNCoreMLRequest = {
        // Load the ML model through its generated class and create a Vision request for it.
        do {
            let model = try VNCoreMLModel(for: DenseNet169_Landmark().model)
            return VNCoreMLRequest(model: model, completionHandler: handleClassification)
        } catch {
            fatalError("Can't load Vision ML model: \(error).")
        }
    }()
    
    func handleClassification(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNClassificationObservation]
            else { fatalError("Unexpected result type from VNCoreMLRequest.") }
        print(observations)
        DispatchQueue.main.async {
            self.results = Array(observations[0...4])
            self.count = 3
            self.predictionTable.reloadData()
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        //classifer1.text = "Analyzing Image..."
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 224, height: 224), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 224, height: 224))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        landmarkImageView.image = newImage
        landmarkImageView.contentMode = .scaleAspectFit
        let landmarkImage : CIImage = CIImage(image: newImage)!
        // Run the Core ML Landmark classifier -- results in handleClassification method
        let handler = VNImageRequestHandler(ciImage: landmarkImage)
        do {
            try handler.perform([classificationRequest])
        } catch {
            print(error)
        }
    }   
}

