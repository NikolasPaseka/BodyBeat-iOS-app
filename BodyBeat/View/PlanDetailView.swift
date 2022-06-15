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
    
    @State var isEditVisible: Bool = false
    
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
        var arr = exercises.map { $0.self }
        if (arr.count > 0) {
            arr.removeFirst()
        }
        return arr
    }
    
    func getFirstExercise() -> Exercise {
        var arr = exercises.map { $0.self }
        if (arr.count > 0) {
            return arr.removeFirst()
        } else {
            return Exercise()
        }
    }
    
    func getTimerLabel(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        if seconds < 10 {
            return "\(minutes):0\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
    }
    
    var body: some View {
        VStack {
            Text(plan.title ?? "no title")
                .font(.title.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            HStack {
                Image(systemName: "timer")
                    .padding()
                    .font(.title2)
                VStack {
                    Text("Between exercises: \(getTimerLabel(seconds: Int(plan.timerExercise)))")
                    Text("Between series: \(getTimerLabel(seconds: Int(plan.timerSeries)))")
                }
            }
            
            NavigationLink(destination: PlanProgressView(plan: plan,
                                                         exercises: getExercisesArr(),
                                                         currentExercise: getFirstExercise()), isActive: $isPlanProgressVisible) {
                Button {
                    isPlanProgressVisible = true
                } label: {
                    ConfirmButtonView(buttonLabel: "Start Workout")
                }
            }        //.navigationBarTitleDisplayMode(.inline)
            
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
            .navigationBarTitleDisplayMode(.inline)
            Spacer()
        }
        .background(Color.backgroundColor)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink(destination: NewPlanView(plan: plan, isNewPlanVisible: $isEditVisible)) {
                   Text("Edit")
                }
            }
        }
    }
}

struct PlanDetailView_Previews: PreviewProvider {
    static var plan = Plan()
    
    static var previews: some View {
        PlanDetailView(plan: plan)
    }
}
