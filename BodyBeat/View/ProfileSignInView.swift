//
//  ProfileSignInView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 23.05.2022.
//

import SwiftUI

struct ProfileSignInView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    @State var isVisible: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Sign in to your profile")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .font(.title2.bold())
                
//                RoundedTextField(placeHolder: "Email Address", value: $email)
//                    .frame(width: 330)
                FormInputTextField(image: "person.fill", label: "Email Address", value: $email, isPassword: false)
                FormInputTextField(image: "lock.fill", label: "Password", value: $password, isPassword: true)
                
                ConfirmButtonView(buttonLabel: "Sign in", width: 150)
                    .padding()
                
                HStack {
                    Text("Don't have account")
                        .font(.body)
                    Text("|")
                    NavigationLink(destination: ProfileRegistrationView(isVisible: $isVisible), isActive: $isVisible) {
                        Button {
                            isVisible = true
                        } label: {
                            Text("Register now")
                                .foregroundColor(Color.lighterOrange)
                                .font(.body)
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("BodyBeat Profile")
            .padding()
            .background(Color.backgroundColor)
        }
    }
}

struct ProfileSignInView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSignInView()
            .preferredColorScheme(.dark)
    }
}
