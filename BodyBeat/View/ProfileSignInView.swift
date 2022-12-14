//
//  ProfileSignInView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 23.05.2022.
//

import SwiftUI
import Firebase

struct ProfileSignInView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Plan.title, ascending: true)],
        animation: .default)
    private var plans: FetchedResults<Plan>
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var fireStoreManager: FirestoreManager
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var isUserLoggedIn: Bool = false
    @State var user: User?
    @State var userId: String = ""
    
    @State var isDownloading: Bool = false
    @State var isVisible: Bool = false
    
    @State var errorMessage: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if (isUserLoggedIn == false && user == nil) {
                    Text("Sign in to your profile")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .font(.title2.bold())
                    FormInputTextField(image: "person.fill", label: "Email Address", value: $email, isPassword: false)
                    FormInputTextField(image: "lock.fill", label: "Password", value: $password, isPassword: true)
                    
                    Button {
                        signIn()
                    } label: {
                        ConfirmButtonView(buttonLabel: "Sign in", width: 150)
                            .padding()
                    }
                    
                    Text(errorMessage)
                        .font(.body.bold())
                        .foregroundColor(.red)
                    
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
                } else {
                    Text("You are signed in")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    Text(user?.email ?? "none")
                    
                    if (isDownloading) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    
                    Button {
                        isDownloading = true
                        fireStoreManager.syncData(plans: plans.map { $0.self }, viewContext: viewContext, userId: userId) {
                            isDownloading = false
                        }
                    } label: {
                        ConfirmButtonView(buttonLabel: "Sync data", width: 150)
                            .padding()
                    }
                    
                    Button {
                        logout()
                        isUserLoggedIn = false
                    } label: {
                        ConfirmButtonView(buttonLabel: "Log out", width: 150)
                            .padding()
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("BodyBeat Profile")
            .padding()
            .background(Color.backgroundColor)
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        self.user = user
                        isUserLoggedIn = true
                        userId = user!.uid
                    }
                }
            }
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if (error != nil) {
                print(error!.localizedDescription)
                errorMessage = "Invalid email or password"
            } else {
                errorMessage = ""
            }
        }
    }
    
    func logout() {
        isUserLoggedIn = false
        user = nil
        email = ""
        password = ""
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
    }
}

struct ProfileSignInView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSignInView()
            .preferredColorScheme(.dark)
    }
}
