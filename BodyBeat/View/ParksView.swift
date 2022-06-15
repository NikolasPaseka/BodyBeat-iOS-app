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
    
    @State var isDownloading: Bool = false
    
    @State var selectedPark: Park? = nil
    
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
                if (isDownloading) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                if (renderMode == 0) {
                    ZStack {
                        ParksMapView(region: locationManager.region, pointsOfInterest: getPointsOfInterest(), selectedPark: $selectedPark, parks: viewModel.parks)
                        VStack {
                            Spacer()
                            if (selectedPark != nil) {
                                ZStack {
                                    ParkPreviewView(park: selectedPark!)
                                }
                            }
                        }
                    }
                } else {
                    List {
                        ForEach(viewModel.parks, id: \.self) { park in
                            NavigationLink(destination: ParkDetailView(park: park)) {
                                Text(park.name)
                            }
                        }
                        .listRowBackground(Color.lighterGrey)
                    }
                    .refreshable {
                        isDownloading = true
                        viewModel.fetch {
                            isDownloading = false
                        }
                    }
                    .padding(.top, -30)
                }
            }
            .task {
                isDownloading = true
                viewModel.fetch {
                    isDownloading = false
                    //selectedPark = viewModel.park[0]
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
    
    @Binding var selectedPark: Park?
    
    var parks: [Park]
    
    var body: some View {
        Map(coordinateRegion: $region,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: $trackingMode,
//            annotationItems: pointsOfInterest){ item in
//                // MapPin(coordinate: item.coordinate, tint: .red)
//                //MapMarker(coordinate: item.coordinate, tint: Color.lighterOrange)
//                MapAnnotation(coordinate: item.coordinate) {
//                    LocationMapAnnotationView()
//                }
            
            annotationItems: parks,
            annotationContent: { park in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: park.latitude, longitude: park.longitude)) {
                    LocationMapAnnotationView()
                    .scaleEffect(park == selectedPark ? 1 : 0.7)
                        .onTapGesture {
                            if (park == selectedPark) {
                                selectedPark = nil
                            } else {
                                selectedPark = park
                            }
                        }
                }
        })
    }
}

struct ParksView_Previews: PreviewProvider {
    static var previews: some View {
        ParksView()
            .preferredColorScheme(.dark)
    }
}
