//
//  ParksViewModel.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 22.05.2022.
//

import Foundation
import SwiftUI
import MapKit

struct Park: Hashable, Codable, Identifiable {
    var id: String {
        name
    }
    
    //var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    var image: String
}

class ParksViewModel: ObservableObject {
    @Published var parks: [Park] = []
    
    @Published var mapLocation: Park? = nil
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    func fetch(completionHandler: @escaping () -> Void) {
        guard let url = URL(string: "http://localhost:3000/parks") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let parks = try JSONDecoder().decode([Park].self, from: data)
                DispatchQueue.main.async {
                    self.parks = parks
                    if self.parks.count > 0 {
                        self.mapLocation = self.parks[0]
                        if self.mapLocation != nil {
                            self.updateMapRegion(location: self.mapLocation!)
                        }
                    }
                    completionHandler()
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    private func updateMapRegion(location: Park) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: mapSpan)
        }
    }
}
