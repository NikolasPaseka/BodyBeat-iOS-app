//
//  ParkDetailView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 22.05.2022.
//

import SwiftUI
import MapKit

struct ParkDetailView: View {
    var park: Park
    @State var data: Data?
    
    func fetchData() {
        guard let url = URL(string: park.image) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }
        task.resume()
    }
    
    var body: some View {
        VStack {
            if let data = data, let uiimage = UIImage(data: data) {
                Image(uiImage: uiimage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
            }

            Text("Location")
                .font(.title2.bold())
                .padding(.top, 20)
            MapView(region: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: park.latitude, longitude: park.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))), pointsOfInterest: [AnnotatedItem(coordinate: CLLocationCoordinate2D(latitude: park.latitude, longitude: park.longitude))])
            
            Spacer()
        }
        .navigationTitle(park.name)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        .onAppear {
            fetchData()
        }
    }
}

struct ParkDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ParkDetailView(park: Park(name: "Brno Komarov", latitude: 12, longitude: 12, image: "https://res.cloudinary.com/passy/image/upload/v1653240254/cld-sample.jpg"))
            .preferredColorScheme(.dark)
    }
}
