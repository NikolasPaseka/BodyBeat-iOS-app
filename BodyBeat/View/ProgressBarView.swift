//
//  ProgressBarView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 19.05.2022.
//

import SwiftUI

struct ProgressBarView: View {
    @State var progress: Float = 0
    @State var timeRemaining: Int
    var numberOfSeconds: Int
    @Binding var isPresenting: Bool
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(timeRemaining: State<Int>, isPresenting: Binding<Bool>) {
        self._timeRemaining = timeRemaining
        self._isPresenting = isPresenting
        self.numberOfSeconds = timeRemaining.wrappedValue
    }
    
    func getTimerLabel() -> String {
        let minutes: Int = timeRemaining / 60
        let seconds: Int = timeRemaining % 60
        if seconds < 10 {
            return "\(minutes):0\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 20.0)
                    .opacity(0.20)
                    .foregroundColor(.gray)
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color("lighterGreen"))
                    .rotationEffect(Angle(degrees: 270))
                    .animation(.easeInOut, value: 2.0)
                
                Text(getTimerLabel())
                    .onReceive(timer) { _ in
                        if timeRemaining > 0 {
                            progress += 1.0/Float(numberOfSeconds)
                            timeRemaining -= 1
                        } else {
                            isPresenting = false
                        }
                    }
                    .font(.title)
            }
            Button {
                isPresenting = false
            } label : {
                ConfirmButtonView(buttonLabel: "Continue")
            }
        }.interactiveDismissDisabled()
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(timeRemaining: State(initialValue: 10), isPresenting: .constant(true))
    }
}
