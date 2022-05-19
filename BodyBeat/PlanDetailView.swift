//
//  PlanDetailView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 06.05.2022.
//

import SwiftUI

struct PlanDetailView: View {
    
    var plan: Plan
    @FetchRequest var exercises: FetchedResults<Exercise>
    
    @State var isPlanProgressVisible: Bool = false
    
    init(plan: Plan) {
        self.plan = plan
        self._exercises = FetchRequest(
            entity: Exercise.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Exercise.title, ascending: true)
            ],
            predicate: NSPredicate(format: "plan == %@", plan)
        )
    }
    
    func getExercisesArr() -> [Exercise] {
        return exercises.map { $0.self }
    }
    
    var body: some View {
            VStack {
                Text("exercise: \(plan.timerExercise) seconds")
                Text("series: \(plan.timerSeries) seconds")
                
                NavigationLink(destination: PlanProgressView(plan: plan, exercises: getExercisesArr()), isActive: $isPlanProgressVisible) {
                    Button {
                        isPlanProgressVisible = true
                    } label: {
                        ConfirmButtonView(buttonLabel: "Start Workout")
                    }
                }
                
                SpacerLabelView(label: "Exercises")
                    .padding(.top)
                
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
                
                Spacer()
            }.background(Color("backgroundGrey"))
        .navigationTitle(plan.title ?? "empty")
    }
}

struct PlanDetailView_Previews: PreviewProvider {
    static var plan = Plan()
    
    static var previews: some View {
        PlanDetailView(plan: plan)
    }
}
