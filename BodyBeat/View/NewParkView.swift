//
//  NewParkView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 26.05.2022.
//

import SwiftUI
import Cloudinary
import MapKit

struct NewParkView: View {
    @StateObject var locationManager: LocationManager = LocationManager()
    
    @Binding var isPresented: Bool
    
    @State var name: String = ""
    @State var image: UIImage = UIImage(named: "uploadButton")!
    
    @State var isPhotoGalleryPresented: Bool = false
    @State var selectedLocation: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationView {
            VStack {
                RoundedTextField(placeHolder: "Workout park name", value: $name)
                    .padding()
                
                Text("Select image")
                    .font(.title3.bold())
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280, height: 150)
                    .onTapGesture {
                        isPhotoGalleryPresented = true
                    }
                
                NavigationLink {
                    SelectLocationView(selectedLocation: $selectedLocation, region: locationManager.region)
                } label: {
                    ConfirmButtonView(buttonLabel: "Set location")
                        .padding()
                }
    
                Spacer()
            }
            .padding()
            .navigationTitle("New workout park")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Upload") {
                        uploadImageToCloudinary()
                        isPresented = false
                    }
                }
            }
            .sheet(isPresented: $isPhotoGalleryPresented) {
                PhotoPicker(image: $image)
            }
        }
    }
    
    func uploadParkToApi(urlString: String) {
        // TODO POPUP message
        // TODO check image uploaded
        // TODO add hash to the name
        guard name != "" else { return }
        guard let selectedLocation = selectedLocation else { return }

        let json: [String: Any] = [
            "name": name,
            "latitude": selectedLocation.latitude,
            "longitude": selectedLocation.longitude,
            "image": urlString
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        guard let url = URL(string: "http://localhost:3000/createPark") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON) //Code after Successfull POST Request
            }
        }

        task.resume()
    }
    
    func uploadImageToCloudinary() {
        let config = CLDConfiguration(cloudName: "passy", secure: true)
        let cloudinary = CLDCloudinary(configuration: config)
        let params = CLDUploadRequestParams()
            .setPublicId(name)
        
        if let data = image.jpegData(compressionQuality: 0.5) {
            print("uploading")
            let request = cloudinary.createUploader().upload(data: data, uploadPreset: "ztvxcvpx", params: params ,completionHandler:  { response, error in
                
                if let urlString = cloudinary.createUrl().generate(name) {
                    print(urlString)
                    uploadParkToApi(urlString: urlString)
                }
            })
            request.resume()
        }
    }
}

struct NewParkView_Previews: PreviewProvider {
    static var previews: some View {
        NewParkView(isPresented: .constant(true))
            .preferredColorScheme(.dark)
    }
}
