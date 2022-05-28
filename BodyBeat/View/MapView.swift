//
//  MapView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 28.05.2022.
//

import SwiftUI
import MapKit

struct AnnotatedItem: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}


struct MapView: View {
    @Binding var region: MKCoordinateRegion
    @State private var mapType: MKMapType = .standard
    @State private var trackingMode = MapUserTrackingMode.follow
    var pointsOfInterest: [AnnotatedItem]
    
    var body: some View {
        Map(coordinateRegion: $region,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: $trackingMode,
            annotationItems: pointsOfInterest){ item in
                // MapPin(coordinate: item.coordinate, tint: .red)
                MapMarker(coordinate: item.coordinate, tint: Color.lighterOrange)
            }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(region: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 12, longitude: 12), span: MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3))), pointsOfInterest: [])
    }
}
