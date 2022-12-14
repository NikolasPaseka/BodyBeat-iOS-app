//
//  ConfirmButtonView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 19.05.2022.
//

import SwiftUI

struct ConfirmButtonView: View {
    var buttonLabel: String
    var width: Float?
    
    var body: some View {
        Text(buttonLabel)
            //.font(.system(size: 20, weight: .semibold, design: .default))
            .font(.headline)
            .frame(width: CGFloat(self.width ?? 210.0), height: 50)
            .foregroundColor(.white)
            .background(Color("darkerOrange"))
            .cornerRadius(15.0)
    }
}

struct ConfirmButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmButtonView(buttonLabel: "Button")
    }
}
