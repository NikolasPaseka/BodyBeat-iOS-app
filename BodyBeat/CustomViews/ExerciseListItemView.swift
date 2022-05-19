//
//  ExerciseListItemView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 19.05.2022.
//

import SwiftUI

struct ExerciseListItemView: View {
    var title: String
    var sets: Int
    var repeats: Int
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 18, weight: .medium, design: .default))
            
            Text("\(sets) x \(repeats)")
                .font(.system(size: 13, weight: .regular, design: .default))
                .frame(alignment: .topLeading)
        }
    }
}

struct ExerciseListItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExerciseListItemView(title: "Exercise", sets: 3, repeats: 10)
        }.previewLayout(.fixed(width: 180, height: 50))
    }
}
