//
//  PlanDetailView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 06.05.2022.
//

import SwiftUI

struct PlanDetailView: View {
    
    var plan: Plan
    
    var body: some View {
        ScrollView {
            Text("exercise: \(plan.timerExercise) seconds")
            Text("series: \(plan.timerSeries) seconds")
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
