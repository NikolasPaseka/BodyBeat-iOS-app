//
//  ProfileRegistrationView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 23.05.2022.
//

import SwiftUI

struct ProfileRegistrationView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var repeatPassword: String = ""
    
    var body: some View {
        VStack {
            Text("Create a new profile")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .font(.title2.bold())
            
            FormInputTextField(image: "person.fill", label: "Email Address", value: $email, isPassword: false)
            FormInputTextField(image: "lock.fill", label: "Password", value: $password, isPassword: true)
            FormInputTextField(image: "lock.fill", label: "Repeat password", value: $repeatPassword, isPassword: true)
            
            ConfirmButtonView(buttonLabel: "Register", width: 150)
                .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("BodyBeat Profile")
        .background(Color.backgroundColor)
    }
}

struct ProfileRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileRegistrationView()
            .preferredColorScheme(.dark)
    }
}
