//
//  ClassDetailLocationTableViewCell.swift
//  missfit
//
//  Created by Hank Liang on 5/18/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ClassDetailLocationTableViewCell: UITableViewCell, MKMapViewDelegate {
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var lineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationInfo: UILabel!
    @IBOutlet weak var phone: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var missfitLocation: MissFitLocation?
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    

    @IBAction func phoneButtonClicked(sender: AnyObject) {
        UmengHelper.event(AnalyticsDial400)
        let servicePhoneNumber = (sender as! UIButton).titleForState(.Normal)
        UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://" + servicePhoneNumber!.stringByReplacingOccurrencesOfString("-", withString: "", options: nil, range: nil))!)
    }

    @IBAction func locationRouteButtonClicked(sender: AnyObject) {
        UmengHelper.event(AnalyticsClickLocationRoute)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        missfitLocation!.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
    
    func setData(missfitLocation: MissFitLocation) {
        self.missfitLocation = missfitLocation
        locationInfo.text = missfitLocation.address
        let initialLocation = CLLocation(latitude: missfitLocation.locationCoordinate.latitude, longitude: missfitLocation.locationCoordinate.longtitude)
        centerMapOnLocation(initialLocation)
        mapView.addAnnotation(missfitLocation)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        line.backgroundColor = MissFitTheme.theme.colorSeperator
        lineHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        phone.layer.borderWidth = 1.0
        phone.layer.borderColor = MissFitTheme.theme.colorPink.CGColor
        phone.layer.cornerRadius = 5.0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? MissFitLocation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
        calloutAccessoryControlTapped control: UIControl!) {
            let location = view.annotation as! MissFitLocation
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }

}
