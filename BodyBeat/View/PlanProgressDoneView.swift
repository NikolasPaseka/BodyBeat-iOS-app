//
//  PlanProgressDoneView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 23.05.2022.
//

import SwiftUI

struct PlanProgressDoneView: View {
    var plan: Plan    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Congratulations, you have done your training")
                .font(.title2.bold())
            
            Button {
                dismiss()
            } label: {
                ConfirmButtonView(buttonLabel: "Confirm", width: 150)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
    }
}

struct PlanProgressDoneView_Previews: PreviewProvider {
    static var previews: some View {
        PlanProgressDoneView(plan: Plan())
            .preferredColorScheme(.dark)
    }
}
