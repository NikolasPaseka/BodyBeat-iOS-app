//
//  AddScheduleView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 21.05.2022.
//

import SwiftUI

struct AddScheduleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var days: [String] = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    @State var selectedDay: Int = 0
    @State var selectedTime: Date = Date.now
    
    @Binding var schedules: [Schedule]
    
    @Binding var isAddScheduleVisible: Bool
    
    func saveSchedule() {
        let schedule = Schedule(context: viewContext)
        schedule.time = selectedTime
        schedule.day = days[selectedDay]
        schedules.append(schedule)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Select time of schedule")
                    .font(.title)
                HStack {
                    Picker("Day", selection: $selectedDay) {
                        ForEach(0..<days.count) { i in
                            Text(days[i])
                        }
                    }.id(days)
                    
                    DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                }
                
                .navigationTitle("Add to schedule")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            isAddScheduleVisible = false
                        } label: {
                            Text("Cancel")
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            saveSchedule()
                            isAddScheduleVisible = false
                        } label: {
                            Text("Save")
                        }
                    }
                }
            }
        }
    }
}

struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AddScheduleView(schedules: .constant([]),isAddScheduleVisible: .constant(false))
            .preferredColorScheme(.dark)
    }
}
