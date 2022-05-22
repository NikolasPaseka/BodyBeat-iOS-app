//
//  ParksViewModel.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 22.05.2022.
//

import Foundation

struct Park: Hashable, Codable {
    //var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    var image: String
}

class ParksViewModel: ObservableObject {
    @Published var parks: [Park] = []
    
    func fetch() {
        //guard let url = URL(string: "https://2e7b99d4-a7bd-4d8d-a097-7704b567b206.mock.pstmn.io/parks") else { return }
        guard let url = URL(string: "http://localhost:3000/parks") else { return }
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
