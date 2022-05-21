//
//  RoundedTextField.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 20.05.2022.
//

import SwiftUI

struct RoundedTextField: View {
    var placeHolder: String
    @Binding var value: String
    
    var body: some View {
        TextField(placeHolder, text: $value)
            .padding(12)
            .background(.black)
            .cornerRadius(20)
            .font(.headline)
            .foregroundColor(.white)
    }
}

struct RoundedTextField_Previews: PreviewProvider {
    static var previews: some View {
        RoundedTextField(placeHolder: "Input view", value: .constant("value"))
    }
}
