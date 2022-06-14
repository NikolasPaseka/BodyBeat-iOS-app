//
//  TimerButtonView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 14.06.2022.
//

import SwiftUI

struct TimerButtonView: View {
    var minutes: Int
    var seconds: Int
    
    var body: some View {
        Text(getButtonLabel())
            .font(.title2.bold())
            .frame(width: 90, height: 45)
            .foregroundColor(.white)
            .background(.black)
            .cornerRadius(7)
    }
    
    func getButtonLabel() -> String {
        var minutesLabel: String = "\(minutes)"
        var secondsLabel: String = "\(seconds)"
        if minutes < 10 {
            minutesLabel = "0\(minutesLabel)"
        }
        if seconds < 10 {
            secondsLabel = "0\(secondsLabel)"
        }
        return "\(minutesLabel):\(secondsLabel)"
    }
}

struct TimerButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TimerButtonView(minutes: 2, seconds: 2)
    }
}
