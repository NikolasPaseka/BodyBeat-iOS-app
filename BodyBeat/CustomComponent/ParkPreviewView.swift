//
//  ParkPreviewView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 15.06.2022.
//

import SwiftUI

struct ParkPreviewView: View {
    let park: Park
    
    @State var imageData: Data?
    
    func fetchImageData() {
        guard let url = URL(string: park.image) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            self.imageData = data
        }.resume()
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                imageSection
                Text(park.name)
                    .font(.title2.bold())
            }
            
            VStack(alignment: .trailing, spacing: 8) {
                Button {
                    
                } label: {
                    ConfirmButtonView(buttonLabel: "Show detail", width: 150)
                }
            }
            .padding(.leading, 40)

        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .offset(y: 65)
        )
        .cornerRadius(10)
        .task {
            fetchImageData()
        }
    }
}

extension ParkPreviewView {
    
    private var imageSection: some View {
        ZStack {
            if let data = imageData, let uiimage = UIImage(data: data) {
                Image(uiImage: uiimage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            } else {
                Image(uiImage: UIImage(named: "preview")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            }
        }
        .padding(6)
        .background(.white)
        .cornerRadius(10)
    }
    
}

struct ParkPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ParkPreviewView(park: Park(name: "Test", latitude: 10.3, longitude: 10.3, image: "image"))
    }
}
