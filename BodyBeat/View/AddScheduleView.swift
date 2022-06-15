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
                    .foregroundColor(.white)
                    .frame(width: 170)
            }
            Spacer()
            Button {
                saveSchedule()
                isAddScheduleVisible = false
            } label: {
                ConfirmButtonView(buttonLabel: "Add to schedule")
            }
            .padding()
            Spacer()
        }
        .padding()
    }
}

struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AddScheduleView(schedules: .constant([]),isAddScheduleVisible: .constant(false))
            .preferredColorScheme(.dark)
    }
}
