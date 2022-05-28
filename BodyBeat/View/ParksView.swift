//
//  ParksView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 22.05.2022.
//

import SwiftUI
import MapKit

struct ParksView: View {
    @StateObject var viewModel = ParksViewModel()
    @StateObject var locationManager = LocationManager()
    
    @State var isNewParkVisible: Bool = false
    @State var renderMode: Int = 0
    
    func getPointsOfInterest() -> [AnnotatedItem] {
        var pointsOfInterest: [AnnotatedItem] = []
        
        for park in viewModel.parks {
            pointsOfInterest.append(AnnotatedItem(coordinate: .init(latitude: park.latitude, longitude: park.longitude)))
        }
        return pointsOfInterest
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Render mode", selection: $renderMode) {
                    Text("Map").tag(0)
                    Text("List").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                if (renderMode == 0) {
                    ParksMapView(region: locationManager.region, pointsOfInterest: getPointsOfInterest())
                        .onAppear {
                            viewModel.fetch()
                        }
                } else {
                    List {
                        ForEach(viewModel.parks, id: \.self) { park in
                            NavigationLink(destination: ParkDetailView(park: park)) {
                                Text(park.name)
                            }
                        }.listRowBackground(Color.lighterGrey)
                    }
                    .onAppear {
                        viewModel.fetch()
                    }
                }
            }
            .navigationTitle("Workout parks")
            .background(Color.backgroundColor)
            .toolbar {
                ToolbarItem {
                    Button {
                        isNewParkVisible = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isNewParkVisible) {
                NewParkView(isPresented: $isNewParkVisible)
            }
        }
    }
}

struct ParksMapView: View {
    @State var region: MKCoordinateRegion
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

struct ParksView_Previews: PreviewProvider {
    static var previews: some View {
        ParksView()
            .preferredColorScheme(.dark)
    }
}
