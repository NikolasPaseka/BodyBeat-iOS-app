//
//  ContentView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 06.05.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        TabView {
            PlanListView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Plans")
                }
            
            Text("Schedule")
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Schedule")
                }
            
            Text("Parks")
                .tabItem {
                    Image(systemName: "location")
                    Text("Parks")
                }
            
            Text("Profile")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
