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
    @State var schedules: [Schedule] = []
    
    @State var title: String = ""
    @State var exerciseTimerMinutes: Int = 0
    @State var exerciseTimerSeconds: Int = 0
    @State var seriesTimerMinutes: Int = 0
    @State var seriesTimerSeconds: Int = 0
    
    @Binding var isNewPlanVisible: Bool
    @State var isPlanExercisesVisible: Bool = false
    @State var isAddScheduleVisible: Bool = false
    
    init(isNewPlanVisible: Binding<Bool>) {
//        title = ""
//        exerciseTimerMinutes = 0
//        exerciseTimerSeconds = 0
//        seriesTimerMinutes = 0
//        seriesTimerSeconds = 0
//        wakeUp = Date.now
        self._isNewPlanVisible = isNewPlanVisible
    }
    
    
    func savePlan() {
        let plan = Plan(context: viewContext)
        
        plan.planId = HashGenerator().getRandomHash()
        plan.title = title
        plan.timerExercise = Int16(exerciseTimerMinutes*60 + exerciseTimerSeconds)
        plan.timerSeries = Int16(seriesTimerMinutes*60 + seriesTimerSeconds)
        
        for exercise in exercises {
            plan.addToExercises(exercise)
        }
        for schedule in schedules {
            plan.addToSchedules(schedule)
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    
    var body: some View {
        VStack {
            VStack {
                RoundedTextField(placeHolder: "Workout plan title", value: $title)
                    
                LabelTimerView(label: "Exercise timer", minutes: $exerciseTimerMinutes, seconds: $exerciseTimerSeconds)
                LabelTimerView(label: "Series timer", minutes: $seriesTimerMinutes, seconds: $seriesTimerSeconds)
                
                NavigationLink(destination: ExerciseListView(exercises: $exercises), isActive: $isPlanExercisesVisible){
                    Button {
                        isPlanExercisesVisible = true
                    } label: {
                        ConfirmButtonView(buttonLabel: "Manage exercises: \(exercises.count)")
                    }
                }
            }.padding()
            
            VStack {
                SpacerLabelView(label: "Schedule")

                List {
                    ForEach(schedules) { schedule in
                        Text("\(schedule.day ?? "none") \(timeFormatter.string(from: schedule.time ?? Date.now))")
                    }.listRowBackground(Color.lighterGrey)
                    
                    Button {
                        isAddScheduleVisible = true
                    } label: {
                        HStack {
                            //Image(.systemName("plus.circle.fill"))
                            Text("Add to schedule")
                        }
                    }.listRowBackground(Color.lighterGrey)
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
            }
            .sheet(isPresented: $isAddScheduleVisible) {
                AddScheduleView(schedules: $schedules, isAddScheduleVisible: $isAddScheduleVisible)
            }
            
        }.background(Color.backgroundColor)
    }
}

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

struct NewPlanView_Previews: PreviewProvider {
    static var previews: some View {
        NewPlanView(isNewPlanVisible: .constant(false))
            .preferredColorScheme(.dark)
    }
}
