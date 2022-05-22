//
//  ScheduleView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 22.05.2022.
//

import SwiftUI

struct ScheduleView: View {
    
    @State var day: String = "monday"
    
    
//    func updateSchedules() {
//        self._schedules = FetchRequest(
//            entity: Schedule.entity(),
//            sortDescriptors: [
//                NSSortDescriptor(keyPath: \Schedule.day, ascending: true)
//            ],
//            predicate: NSPredicate(format: "day ==%@", day)
//        )
//    }
    
    var body: some View {
        NavigationView {
            VStack {
                DayRowView(selectedDay: $day)
                    .padding()
                FilteredList(filter: day)
            }
            .navigationTitle("Schedule")
            .background(Color.backgroundColor)
        }
    }
}

struct FilteredList: View {
    
    @FetchRequest var schedules: FetchedResults<Schedule>
    
    init(filter: String) {
        _schedules = FetchRequest(
            entity: Schedule.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Schedule.day, ascending: true)
            ],
            predicate: NSPredicate(format: "day ==%@", filter)
        )
    }
    
    var body: some View {
        List {
            ForEach(schedules) { schedule in
                ScheduleRowItem(title: schedule.plan?.title ?? "none", time: schedule.time ?? Date.now)
            }.listRowBackground(Color.lighterGrey)
        }
    }
}

struct ScheduleRowItem: View {
    var title: String
    var time: Date
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Text(timeFormatter.string(from: time))
                .font(.subheadline)
        }
    }
}

struct DayRowView: View {
    @State var daysSelection: [Bool] = [true, false, false, false, false, false, false]
    @Binding var selectedDay: String
    
    var body: some View {
        HStack {
            DayPickerView(dayLabel: "MON", day: "monday", isCircleVisible: $daysSelection, index: 0, selectedDay: $selectedDay)
            DayPickerView(dayLabel: "TUE", day: "tuesday", isCircleVisible: $daysSelection, index: 1, selectedDay: $selectedDay)
            DayPickerView(dayLabel: "WEN", day: "wednesday", isCircleVisible: $daysSelection, index: 2, selectedDay: $selectedDay)
            DayPickerView(dayLabel: "THU", day: "thursday", isCircleVisible: $daysSelection, index: 3, selectedDay: $selectedDay)
            DayPickerView(dayLabel: "FRI", day: "friday", isCircleVisible: $daysSelection, index: 4, selectedDay: $selectedDay)
            DayPickerView(dayLabel: "SAT", day: "saturday", isCircleVisible: $daysSelection, index: 5, selectedDay: $selectedDay)
            DayPickerView(dayLabel: "SUN", day: "sunday", isCircleVisible: $daysSelection, index: 6, selectedDay: $selectedDay)
        }
    }
}

struct DayPickerView: View {
    var dayLabel: String
    var day: String
    @Binding var isCircleVisible: [Bool]
    var index: Int
    @Binding var selectedDay: String
    
    func switchDay() {
        for i in 0..<isCircleVisible.count {
            isCircleVisible[i] = false
        }
        isCircleVisible[index] = true
        selectedDay = day
    }
    
    var body: some View {
        Button {
            switchDay()
        } label: {
            ZStack {
                if (isCircleVisible[index]) {
                    Circle()
                        //.foregroundColor(Color("lighterOrange"))
                        .foregroundColor(Color.lighterOrange)
                        .frame(width: 48, height: 48)
                }
                Text(dayLabel)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
            .preferredColorScheme(.dark)
    }
}
