//
//  SpacerLabelView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 19.05.2022.
//

import SwiftUI

struct SpacerLabelView: View {
    var label: String
    
    var body: some View {
        Text(label)
            .font(.system(size: 15, weight: .medium, design: .default))
            .padding(.leading)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 26, alignment: .leading)
            .background(Color("darkerGreen"))
    }
}

struct SpacerLabelView_Previews: PreviewProvider {
    static var previews: some View {
        SpacerLabelView(label: "Label")
    }
}
