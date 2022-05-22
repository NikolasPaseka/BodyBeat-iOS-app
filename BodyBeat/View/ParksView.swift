//
//  ParksView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 22.05.2022.
//

import SwiftUI
import MapKit

struct Park: Hashable, Codable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
}

struct AnnotatedItem: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

private class ViewModel: ObservableObject {
    @Published var parks: [Park] = []
    
    func fetch() {
        guard let url = URL(string: "https://2e7b99d4-a7bd-4d8d-a097-7704b567b206.mock.pstmn.io/parks") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let parks = try JSONDecoder().decode([Park].self, from: data)
                DispatchQueue.main.async {
                    self.parks = parks
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

struct ParksView: View {
    @StateObject private var viewModel = ViewModel()
    
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
                    // TODO - zamerit current lokaci
                    ParksMapView(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 12, longitude: 12), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)), pointsOfInterest: getPointsOfInterest())
                        .onAppear {
                            viewModel.fetch()
                        }
                } else {
                    List {
                        ForEach(viewModel.parks, id: \.self) { park in
                            Text(park.name)
                        }.listRowBackground(Color.lighterGrey)
                    }.onAppear {
                        viewModel.fetch()
                    }
                }
            }
            .navigationTitle("Workout parks")
            .background(Color.backgroundColor)
        }
    }
}

struct ParksMapView: View {
    @State var region: MKCoordinateRegion
    @State private var mapType: MKMapType = .standard
    @State private var trackingMode = MapUserTrackingMode.follow
    var pointsOfInterest: [AnnotatedItem]
    
//    var long: Double
//    var lat: Double
    
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
