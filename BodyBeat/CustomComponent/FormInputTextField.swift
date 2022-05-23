//
//  FormInputTextField.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 23.05.2022.
//

import SwiftUI

struct FormInputTextField: View {
    var image: String
    var label: String
    @Binding var value: String
    var isPassword: Bool
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .foregroundColor(Color.gray)
            if (isPassword) {
                SecureField(label, text: $value)
            } else {
                TextField(label, text: $value)
            }
        }
        .padding()
        .background(.black)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 2).foregroundColor(Color.lighterGrey))
        .frame(width: 330)
        .padding(8)
    }
}

struct FormInputTextField_Previews: PreviewProvider {
    static var previews: some View {
        FormInputTextField(image: "person.fill", label: "Label", value: .constant(""), isPassword: false)
    }
}
