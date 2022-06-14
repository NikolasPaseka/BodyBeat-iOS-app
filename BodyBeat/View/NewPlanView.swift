//
//  NewPlanView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 06.05.2022.
//

import SwiftUI
import HalfASheet

struct NewPlanView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var plan: Plan?
    
    @State var exercises: [Exercise] = []
    @State var schedules: [Schedule] = []
    
    @State var title: String = ""
    @State var exerciseTimerMinutes: Int = 0
    @State var exerciseTimerSeconds: Int = 0
    @State var seriesTimerMinutes: Int = 0
    @State var seriesTimerSeconds: Int = 0
    
    @State var isTimerSheetVisible: Bool = false
    @State var isTimerSheetExercise: Bool = false
    
    @Binding var isNewPlanVisible: Bool
    @State var isPlanExercisesVisible: Bool = false
    @State var isAddScheduleVisible: Bool = false
    
    init(plan: Plan?, isNewPlanVisible: Binding<Bool>) {
        self.plan = plan
        self._isNewPlanVisible = isNewPlanVisible
    }
    
    
    func savePlan() {
        if plan == nil {
            plan = Plan(context: viewContext)
        }
        //let plan = Plan(context: viewContext)
        
        plan?.planId = HashGenerator().getRandomHash()
        plan?.title = title
        plan?.timerExercise = Int16(exerciseTimerMinutes*60 + exerciseTimerSeconds)
        plan?.timerSeries = Int16(seriesTimerMinutes*60 + seriesTimerSeconds)
        
        if let p = self.plan {
            p.exercises = NSSet(array: exercises)
            p.schedules = NSSet(array: schedules)
        } else {
            for exercise in exercises {
                plan?.addToExercises(exercise)
            }
            for schedule in schedules {
                plan?.addToSchedules(schedule)
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    RoundedTextField(placeHolder: "Workout plan title", value: $title)
                    
                    HStack {
                        Text("Exercise Timer")
                            .frame(width: 130, alignment: .leading)
                        Button {
                            isTimerSheetExercise = true
                            isTimerSheetVisible = true
                        } label: {
                            TimerButtonView(minutes: exerciseTimerMinutes, seconds: exerciseTimerSeconds)
                        }
                        Spacer()
                    }.padding()
                    HStack {
                        Text("Series Timer")
                            .frame(width: 130, alignment: .leading)
                        Button {
                            isTimerSheetExercise = false
                            isTimerSheetVisible = true
                        } label: {
                            TimerButtonView(minutes: seriesTimerMinutes, seconds: seriesTimerSeconds)
                        }
                        Spacer()
                    }.padding()
                    
                    NavigationLink(destination: ExerciseListView(exercises: $exercises), isActive: $isPlanExercisesVisible){
                        Button {
                            isPlanExercisesVisible = true
                        } label: {
                            ConfirmButtonView(buttonLabel: "Manage exercises: \(exercises.count)")
                        }
                    }.padding()
                }.padding()
                
                VStack {
                    SpacerLabelView(label: "Schedule")

                    List {
                        ForEach(schedules) { schedule in
                            HStack {
                                Text("\(schedule.day ?? "none") \(timeFormatter.string(from: schedule.time ?? Date.now))")
                                Spacer()
                                Button {
                                    schedules.remove(at: schedules.firstIndex { $0 == schedule } ?? 0)
                                } label: {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }.listRowBackground(Color.lighterGrey)
                        
                        Button {
                            isAddScheduleVisible = true
                        } label: {
                            Label("Add to schedule", systemImage: "plus.circle.fill")
                        }.listRowBackground(Color.lighterGrey)
                    }
                    .padding(.top, -20)
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
//                .halfSheet(showSheet: $isAddScheduleVisible) {
//                    AddScheduleView(schedules: $schedules, isAddScheduleVisible: $isAddScheduleVisible)
//                        .foregroundColor(.white)
//                        .background(.blue)
//                        .preferredColorScheme(.dark)
//                }
                .halfSheet(showSheet: $isTimerSheetVisible) {
                    if (isTimerSheetExercise) {
                        TimerSelectionView(header: "Time between exercises", minutes: $exerciseTimerMinutes, seconds: $exerciseTimerSeconds)
                            .foregroundColor(.white)
                            .background(.white)
                    } else {
                        TimerSelectionView(header: "Time between series", minutes: $seriesTimerMinutes, seconds: $seriesTimerSeconds)
                            .foregroundColor(.white)
                            .background(.white)
                    }
                }
                
            }
            HalfASheet(isPresented: $isAddScheduleVisible) {
                AddScheduleView(schedules: $schedules, isAddScheduleVisible: $isAddScheduleVisible)
            }
            .height(.fixed(400))
        }
        .background(Color.backgroundColor)
        .task {
            if let plan = plan {
                guard title == "" else { return }
                exercises = plan.exercises?.allObjects as? [Exercise] ?? []
                schedules = plan.schedules?.allObjects as? [Schedule] ?? []
                
                title = plan.title ?? ""
                exerciseTimerMinutes = Int(plan.timerExercise) / 60
                exerciseTimerSeconds = Int(plan.timerExercise) % 60
                seriesTimerMinutes = Int(plan.timerSeries) / 60
                seriesTimerSeconds = Int(plan.timerSeries) % 60
            }
        }
    }
}

struct TimerSelectionView: View {
    let header: String
    @Binding var minutes: Int
    @Binding var seconds: Int
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack {
                Text(header)
                    .font(.title.bold())
                    .padding()
                HStack {
                    NumberPickerView(label: "Minutes", maxInputRange: 5, selectedNumber: $minutes)
                    NumberPickerView(label: "Seconds", maxInputRange: 60, selectedNumber: $seconds)
                }
                Spacer()
            }
        }
    }
}

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

struct NewPlanView_Previews: PreviewProvider {
    static var previews: some View {
        NewPlanView(plan: nil, isNewPlanVisible: .constant(false))
            .preferredColorScheme(.dark)
    }
}
