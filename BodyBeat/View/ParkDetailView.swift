//
//  ParkDetailView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 22.05.2022.
//

import SwiftUI

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
            Text(park.name)
                .padding()
                .font(.title)
            if let data = data, let uiimage = UIImage(data: data) {
                Image(uiImage: uiimage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .background(.gray)
            } else {
                Image(systemName: "image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .background(.gray)
                    .onAppear {
                        fetchData()
                    }
            }
            
            Button {
                
            } label: {
                ConfirmButtonView(buttonLabel: "Show location")
                    .padding()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
    }
}

struct ParkDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ParkDetailView(park: Park(name: "Brno Komarov", latitude: 12, longitude: 12, image: "https://res.cloudinary.com/passy/image/upload/v1653240254/cld-sample.jpg"))
            .preferredColorScheme(.dark)
    }
}
