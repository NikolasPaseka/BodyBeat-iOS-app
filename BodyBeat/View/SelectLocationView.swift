//
//  SelectLocationView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 28.05.2022.
//

import SwiftUI
import MapKit

struct SelectLocationView: View {
    @State var mapRegion: MKCoordinateRegion
    
    @State var pointsOfInterest: [AnnotatedItem]
    @Binding var selectedLocation: CLLocationCoordinate2D?
    
    init(selectedLocation: Binding<CLLocationCoordinate2D?>, region: MKCoordinateRegion) {
        if let selectedLocation = selectedLocation.wrappedValue {
            self.mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude),
                                                span: MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3))
            
            pointsOfInterest = [AnnotatedItem(coordinate: selectedLocation)]
        } else {
//            self.mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 12, longitude: 12),
//                                                span: MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3))
            self.mapRegion = region
            pointsOfInterest = []
        }
        self._selectedLocation = selectedLocation
    }
    
    var body: some View {
        ZStack {
            MapView(region: $mapRegion, pointsOfInterest: pointsOfInterest)
            
            Circle()
                .fill(Color.lighterOrange)
                .opacity(0.5)
                .frame(width: 28, height: 28)
            
            VStack {
                Spacer()
                
                Button {
                    selectedLocation = CLLocationCoordinate2D(latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
                    pointsOfInterest = [AnnotatedItem(coordinate: selectedLocation!)]
                } label: {
                    Image(systemName: "pin.fill")
                        .padding()
                        .background(Color.darkerOrange)
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .clipShape(Circle())
                        .padding()
                        .padding(.bottom, 30)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct SelectLocationView_Previews: PreviewProvider {
    static var previews: some View {
        SelectLocationView(selectedLocation: .constant(nil), region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 12, longitude: 12), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)))
    }
}
