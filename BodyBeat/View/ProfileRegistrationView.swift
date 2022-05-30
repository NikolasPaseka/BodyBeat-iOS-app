//
//  ProfileRegistrationView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 23.05.2022.
//

import SwiftUI
import Firebase

struct ProfileRegistrationView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var repeatPassword: String = ""
    @Binding var isVisible: Bool
    
    init(isVisible: Binding<Bool>) {
        self._isVisible = isVisible
    }
    
    var body: some View {
        VStack {
            Text("Create a new profile")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .font(.title2.bold())
            
            FormInputTextField(image: "person.fill", label: "Email Address", value: $email, isPassword: false)
            FormInputTextField(image: "lock.fill", label: "Password", value: $password, isPassword: true)
            FormInputTextField(image: "lock.fill", label: "Repeat password", value: $repeatPassword, isPassword: true)
            
            Button {
                register()
                isVisible = false
            } label: {
                ConfirmButtonView(buttonLabel: "Register", width: 150)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("BodyBeat Profile")
        .background(Color.backgroundColor)
    }
    
    func register() {
        // TODO - vypsat chybovou hlasku
        guard password == repeatPassword else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if (error != nil) {
                print(error!.localizedDescription)
            }
        }
    }
}

struct ProfileRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileRegistrationView(isVisible: .constant(false))
            .preferredColorScheme(.dark)
    }
}
