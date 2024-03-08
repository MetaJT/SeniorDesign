/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The main view controller.
*/

import UIKit
import CoreLocation
import MapKit
import SwiftUI

class IndoorMapViewController: UIViewController, MKMapViewDelegate, LevelPickerDelegate, UISearchBarDelegate {
    @IBOutlet var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    @IBOutlet var levelPicker: LevelPickerView!
    @IBOutlet var searchRoomField: UISearchBar!
    @IBOutlet var searchActualRoomField: UISearchBar!
    
    @State private var buildingSearchText: String = ""
//    @FocusState private var buildingSearchTextFocused: Bool
    @State private var roomSearchText: String = ""
    @State private var savedLevel: Int = 1
    
    var venue: Venue?
    private var levels: [Level] = []
    private var currentLevelFeatures = [StylableFeature]()
    private var currentLevelOverlays = [MKOverlay]()
    private var currentLevelAnnotations = [MKAnnotation]()
    let pointAnnotationViewIdentifier = "PointAnnotationView"
    let labelAnnotationViewIdentifier = "LabelAnnotationView"
    
    private var searchAnnotations: [MKAnnotation] = []
    private var anchorData: [AnchorB] = []
    private var occupantData: [OccupantB] = []
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchRoomField.delegate = self
        searchActualRoomField.delegate = self
        
        loadJsonData()
        
        let navigateSection = NavigateSectionView()
//        let overlayView = UIView()
//        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        overlayView.frame = CGRect(x: 0, y: 0, width: view.bounds.width/2, height: view.bounds.height/2)
        self.view.addSubview(navigateSection)
        self.view.bringSubviewToFront(navigateSection)

        // Request location authorization so the user's current location can be displayed on the map
        locationManager.requestWhenInUseAuthorization()

        self.mapView.delegate = self
        self.mapView.register(PointAnnotationView.self, forAnnotationViewWithReuseIdentifier: pointAnnotationViewIdentifier)
        self.mapView.register(LabelAnnotationView.self, forAnnotationViewWithReuseIdentifier: labelAnnotationViewIdentifier)

        // Decode the IMDF data. In this case, IMDF data is stored locally in the current bundle.
        let imdfDirectory = Bundle.main.resourceURL!.appendingPathComponent("IMDFData")
        do {
            let imdfDecoder = IMDFDecoder()
            venue = try imdfDecoder.decode(imdfDirectory)
        } catch let error {
            print(error)
        }
        
        // You might have multiple levels per ordinal. A selected level picker item displays all levels with the same ordinal.
        if let levelsByOrdinal = self.venue?.levelsByOrdinal {
            let levels = levelsByOrdinal.mapValues { (levels: [Level]) -> [Level] in
                // Choose indoor level over outdoor level
                if let level = levels.first(where: { $0.properties.outdoor == false }) {
                    return [level]
                } else {
                    return [levels.first!]
                }
            }.flatMap({ $0.value })
            
            // Sort levels by their ordinal numbers
            self.levels = levels.sorted(by: { $0.properties.ordinal > $1.properties.ordinal })
        }
        
        // Set the map view's region to enclose the venue
        if let venue = venue, let venueOverlay = venue.geometry[0] as? MKOverlay {
            self.mapView.setVisibleMapRect(venueOverlay.boundingMapRect, edgePadding:
                UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: false)
        }

        // Display a default level at start, for example a level with ordinal 0
        showFeaturesForOrdinal(0)
        
        // Setup the level picker with the shortName of each level
        setupLevelPicker()
    }
    
    func loadJsonData() {
        guard let anchorUrl = Bundle.main.url(forResource: "IMDFData/anchor", withExtension: "geojson")
        else {
            print("json file not found")
            return
        }
        let anchordata = try? Data(contentsOf: anchorUrl)
        guard let occupantUrl = Bundle.main.url(forResource: "IMDFData/occupant", withExtension: "geojson")
        else {
            print("json file not found")
            return
        }
        let occupantdata = try? Data(contentsOf: occupantUrl)
        
        let decoder = JSONDecoder()
        let decoderNew = JSONDecoder()
        do {
            let jsonData = try decoder.decode(MainAnchor.self, from: anchordata!)
            self.anchorData = jsonData.features
            let newjsonData = try decoderNew.decode(MainOccupant.self, from: occupantdata!)
            self.occupantData = newjsonData.features
        } catch {
            print("Error in JSON parsing")
            return
        }
    }
    
    func lookupAnchorCoords(anchorId: String) -> [Double] {
        for anchor in self.anchorData {
            if anchor.id == anchorId {
                return anchor.geometry.coordinates
            }
        }
        return []
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.mapView.removeAnnotations(self.searchAnnotations)
        self.searchAnnotations = []
        if levelPicker.selectedIndex != nil {
            self.savedLevel = levelPicker.selectedIndex!
        }
        levelPicker.selectedIndex = nil
        print(self.savedLevel)
        
        if (self.searchRoomField.text == "" && self.searchActualRoomField.text == "") {
            levelPicker.selectedIndex = self.savedLevel
            return
        }
        
        if (self.searchActualRoomField.text == "") { // If the Room Search bar has no text, select all rooms in the building
            levelPicker.selectedIndex = self.savedLevel
            for occupant in self.occupantData {
                if (occupant.properties.website == "Building " + self.searchRoomField.text!) {
                    let annotation = MKPointAnnotation()
                    let coords: [Double] = lookupAnchorCoords(anchorId: occupant.properties.anchor_id)
                    annotation.coordinate = CLLocationCoordinate2D(latitude: coords[1], longitude: coords[0])
                    annotation.title = ""
                    self.mapView.addAnnotation(annotation)
                    self.searchAnnotations.append(annotation)
                }
            }
        } else { // Both fields have text, so search for a specific room
            for occupant in self.occupantData {
                if (occupant.properties.website == "Building " + self.searchRoomField.text! && occupant.properties.name.en == self.searchActualRoomField.text!) {
                    let annotation = MKPointAnnotation()
                    let coords: [Double] = lookupAnchorCoords(anchorId: occupant.properties.anchor_id)
                    annotation.coordinate = CLLocationCoordinate2D(latitude: coords[1], longitude: coords[0])
                    annotation.title = occupant.properties.website + " - " + occupant.properties.name.en
                    self.mapView.addAnnotation(annotation)
                    self.searchAnnotations.append(annotation)
                    
                    // Clear out the previously-displayed level's geometry
                    self.currentLevelFeatures.removeAll()
                    self.mapView.removeOverlays(self.currentLevelOverlays)
                    self.mapView.removeAnnotations(self.currentLevelAnnotations)
                    self.currentLevelAnnotations.removeAll()
                    self.currentLevelOverlays.removeAll()
                    return
                }
            }
        }
        levelPicker.selectedIndex = self.savedLevel
    }
    
    private func showFeaturesForOrdinal(_ ordinal: Int) {
        guard self.venue != nil else {
            return
        }

        // Clear out the previously-displayed level's geometry
        self.currentLevelFeatures.removeAll()
        self.mapView.removeOverlays(self.currentLevelOverlays)
        self.mapView.removeAnnotations(self.currentLevelAnnotations)
        self.currentLevelAnnotations.removeAll()
        self.currentLevelOverlays.removeAll()

        // Display the level's footprint, unit footprints, opening geometry, and occupant annotations
        if let levels = self.venue?.levelsByOrdinal[ordinal] {
            for level in levels {
                self.currentLevelFeatures.append(level)
                self.currentLevelFeatures += level.units
                self.currentLevelFeatures += level.openings
                
                let occupants = level.units.flatMap({ $0.occupants })
                let amenities = level.units.flatMap({ $0.amenities })
                self.currentLevelAnnotations += occupants
                self.currentLevelAnnotations += amenities
            }
        }
        
        let currentLevelGeometry = self.currentLevelFeatures.flatMap({ $0.geometry })
        self.currentLevelOverlays = currentLevelGeometry.compactMap({ $0 as? MKOverlay })

        // Add the current level's geometry to the map
        self.mapView.addOverlays(self.currentLevelOverlays)
        self.mapView.addAnnotations(self.currentLevelAnnotations)
    }
    
    private func setupLevelPicker() {
        // Use the level's short name for a level picker item display name
        self.levelPicker.levelNames = self.levels.map {
            if let shortName = $0.properties.shortName.bestLocalizedValue {
                return shortName
            } else {
                return "\($0.properties.ordinal)"
            }
        }
        
        // Begin by displaying the level-specific information for Ordinal 0 (which is not necessarily the first level in the list).
        if let baseLevel = levels.first(where: { $0.properties.ordinal == 0 }) {
            levelPicker.selectedIndex = self.levels.firstIndex(of: baseLevel)!
        }
    }

    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let shape = overlay as? (MKShape & MKGeoJSONObject),
            let feature = currentLevelFeatures.first( where: { $0.geometry.contains( where: { $0 == shape }) }) else {
            return MKOverlayRenderer(overlay: overlay)
        }

        let renderer: MKOverlayPathRenderer
        switch overlay {
        case is MKMultiPolygon:
            renderer = MKMultiPolygonRenderer(overlay: overlay)
        case is MKPolygon:
            renderer = MKPolygonRenderer(overlay: overlay)
        case is MKMultiPolyline:
            renderer = MKMultiPolylineRenderer(overlay: overlay)
        case is MKPolyline:
            renderer = MKPolylineRenderer(overlay: overlay)
        default:
            return MKOverlayRenderer(overlay: overlay)
        }

        // Configure the overlay renderer's display properties in feature-specific ways.
        feature.configure(overlayRenderer: renderer)

        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        if let stylableFeature = annotation as? StylableFeature {
            if stylableFeature is Occupant {
                let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: labelAnnotationViewIdentifier, for: annotation)
                stylableFeature.configure(annotationView: annotationView)
                return annotationView
            } else {
                let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointAnnotationViewIdentifier, for: annotation)
                stylableFeature.configure(annotationView: annotationView)
                return annotationView
            }
        }

        return nil
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let venue = self.venue, let location = userLocation.location else {
            return
        }

        // Display location only if the user is inside this venue.
        var isUserInsideVenue = false
        let userMapPoint = MKMapPoint(location.coordinate)
        for geometry in venue.geometry {
            guard let overlay = geometry as? MKOverlay else {
                continue
            }

            if overlay.boundingMapRect.contains(userMapPoint) {
                isUserInsideVenue = true
                break
            }
        }

        guard isUserInsideVenue else {
            return
        }

        // If the device knows which level the user is physically on, automatically switch to that level.
        if let ordinal = location.floor?.level {
            showFeaturesForOrdinal(ordinal)
        }
    }
    
    // MARK: - LevelPickerDelegate
    
    func selectedLevelDidChange(selectedIndex: Int) {
        precondition(selectedIndex >= 0 && selectedIndex < self.levels.count)
        let selectedLevel = self.levels[selectedIndex]
        showFeaturesForOrdinal(selectedLevel.properties.ordinal)
    }
}
