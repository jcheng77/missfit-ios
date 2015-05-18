//
//  MissFitLocation.swift
//  missfit
//
//  Created by Hank Liang on 4/20/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

class MissFitLocation: NSObject, MKAnnotation {
    var locationId: String
    var name: String
    var phone: String
    var district: String
    var address: String
    var area: String?
    var picUrl: String?
    var isVerified: Bool = false
    var locationCoordinate: MissFitLocationCoordinate
    
    // MKAnnotation
    let title: String
    let coordinate: CLLocationCoordinate2D
    
    init(json: JSON) {
        locationId = json["_id"].stringValue
        district = json["district"].stringValue
        address = json["address"].stringValue
        area = json["area"].string
        name = json["name"].stringValue
        phone = json["phone"].stringValue
        picUrl = json["pic"].string
        isVerified = json["verified"].boolValue
        locationCoordinate = MissFitLocationCoordinate(json: json["geo"])
        title = name
        coordinate = CLLocationCoordinate2D(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longtitude)
    }
    
    var subtitle: String {
        return name
    }
    
    // annotation callout info button opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
}
