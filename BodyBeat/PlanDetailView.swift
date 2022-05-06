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
    
    var body: some View {
            VStack {
                Text("exercise: \(plan.timerExercise) seconds")
                Text("series: \(plan.timerSeries) seconds")
                List {
                    ForEach(exercises) { exercise in
                        Text(exercise.title ?? "no title")
                    }
                }
            }
        .navigationTitle(plan.title ?? "empty")
    }
}

struct PlanDetailView_Previews: PreviewProvider {
    static var plan = Plan()
    
    static var previews: some View {
        PlanDetailView(plan: plan)
    }
}
