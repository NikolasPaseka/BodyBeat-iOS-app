//
//  NewPlanView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 06.05.2022.
//

import SwiftUI

struct NewPlanView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var exercises: [Exercise] = []
    
    @State var title: String
    @State var exerciseTimerMinutes: Int
    @State var exerciseTimerSeconds: Int
    @State var seriesTimerMinutes: Int
    @State var seriesTimerSeconds: Int
    
    @Binding var isNewPlanVisible: Bool
    @State var isPlanExercisesVisible: Bool = false
    
    init(isNewPlanVisible: Binding<Bool>) {
        title = ""
        exerciseTimerMinutes = 0
        exerciseTimerSeconds = 0
        seriesTimerMinutes = 0
        seriesTimerSeconds = 0
        self._isNewPlanVisible = isNewPlanVisible
    }
    
    
    func savePlan() {
        let plan = Plan(context: viewContext)
        
        plan.title = title
        plan.timerExercise = Int16(exerciseTimerMinutes*60 + exerciseTimerSeconds)
        plan.timerSeries = Int16(seriesTimerMinutes*60 + seriesTimerSeconds)
        
        for exercise in exercises {
            plan.addToExercises(exercise)
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    
    var body: some View {
        ScrollView {
            VStack {
                RoundedTextField(placeHolder: "Workout plan title", value: $title)
                    
                LabelTimerView(label: "Exercise timer", minutes: $exerciseTimerMinutes, seconds: $exerciseTimerSeconds)
                LabelTimerView(label: "Series timer", minutes: $seriesTimerMinutes, seconds: $seriesTimerSeconds)
                
                NavigationLink(destination: ExerciseListView(exercises: $exercises), isActive: $isPlanExercisesVisible){
                    Button {
                        isPlanExercisesVisible = true
                    } label: {
                        ConfirmButtonView(buttonLabel: "Manage exercises: \(exercises.count)")
                    }.padding()
                }
            
            }
            .navigationTitle("New workout plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savePlan()
                        isNewPlanVisible = false
                    }
                }
            }.padding()
            
            SpacerLabelView(label: "Schedule")
        }.background(Color("backgroundGrey"))
    }
}

struct NewPlanView_Previews: PreviewProvider {
    static var previews: some View {
        NewPlanView(isNewPlanVisible: .constant(false))
            .preferredColorScheme(.dark)
    }
}
