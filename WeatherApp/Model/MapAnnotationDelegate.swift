//
//  MapAnnotationDelegate.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/26/22.
//

import Foundation
import CoreLocation


protocol MapAnnotationDelegate: AnyObject {
    func addAnnotation(for model: MapViewController.Model)
    func deleteAnnotation(at index: Int)
    func moveAnnotation(at sourceIndex: Int, to destinationIndex: Int)
}
