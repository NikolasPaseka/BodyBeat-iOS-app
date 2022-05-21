//
//  PlanProgressView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 06.05.2022.
//

import SwiftUI

struct PlanProgressView: View {
    
    var plan: Plan
    @State var exercises: [Exercise]
    @State var currentExercise: Exercise
    @State var currentSet: Int = 1
    
    @State var isProgressBarPresented: Bool = false
    
    init(plan: Plan, exercises: [Exercise]) {
        var exercisesMutable = exercises
        self.currentExercise = exercisesMutable.removeFirst()
        self.exercises = exercisesMutable
        self.plan = plan
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
        ScrollView {
            VStack {
                Text("Current training")
                    .font(.headline)
                HStack {
                    ExerciseListItemView(title: currentExercise.title ?? "empty",
                                         sets: Int(currentExercise.sets),
                                         repeats: Int(currentExercise.repeats))
                    Spacer()
                    Text("\(currentSet)/\(currentExercise.sets)")
                        .padding(8)
                        .padding(.leading, 12)
                        .padding(.trailing, 12)
                        .background(Color("darkerGreen"))
                        .cornerRadius(5.0)
                        .font(.body)
                }.padding()
                
                Button {
                    isProgressBarPresented.toggle()
                    nextExercise()
                } label: {
                    ConfirmButtonView(buttonLabel: "Done", width: 180)
                }
                
                Spacer()
            }.padding()
            
            SpacerLabelView(label: "Upcoming excersises")
            
            ForEach(exercises) { exercise in
                HStack {
                    ExerciseListItemView(title: exercise.title ?? "no title",
                                         sets: Int(exercise.sets),
                                         repeats: Int(exercise.repeats))
                        .padding(.top, 4)
                        .padding(.leading, 12)
                    Spacer()
                }
            }
            
        }.navigationBarTitleDisplayMode(.inline)
        .navigationTitle(plan.title ?? "no title")
        .background(Color("backgroundGrey"))
        .sheet(isPresented: $isProgressBarPresented) {
            ProgressBarView(timeRemaining: State(initialValue: Int(plan.timerExercise)),
                            isPresenting: $isProgressBarPresented)
                .padding(50)
        }
    }
}


struct PlanProgressView_Previews: PreviewProvider {
    static var previews: some View {
        PlanProgressView(plan: Plan(), exercises: [])
    }
}
