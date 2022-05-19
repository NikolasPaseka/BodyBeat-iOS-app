//
//  PlanProgressView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 06.05.2022.
//

import SwiftUI

struct PlanProgressView: View {
    
    @State var exercises: [Exercise]
    @State var currentExercise: Exercise
    @State var currentSet: Int = 1
    
    @State var isProgressBarPresented: Bool = false
    
    init(exercises: [Exercise]) {
        var exercisesMutable = exercises
        self.currentExercise = exercisesMutable.removeFirst()
        self.exercises = exercisesMutable
    }
    
    func nextExercise() {
        if (currentSet < currentExercise.sets) {
            currentSet += 1
        } else if (!exercises.isEmpty) {
            currentExercise = exercises.removeFirst()
            currentSet = 1
        } else {
            // TODO
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(currentExercise.title ?? "no title")
                Text("\(currentSet)/\(currentExercise.sets)")
            }
            
            Button {
                isProgressBarPresented.toggle()
                nextExercise()
            } label: {
                Text("Done")
            }
        }.sheet(isPresented: $isProgressBarPresented) {
            ProgressBarView(timeRemaining: State(initialValue: 6), isPresenting: $isProgressBarPresented)
                .padding(50)
        }
    }
}


struct PlanProgressView_Previews: PreviewProvider {
    static var previews: some View {
        PlanProgressView(exercises: [])
    }
}
