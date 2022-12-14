//
//  ScheduleView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 22.05.2022.
//

import SwiftUI

struct ScheduleView: View {
    
    @State var day: String = "monday"
    
    
    var body: some View {
        NavigationView {
            VStack {
                DayRowView(selectedDay: $day)
                    //.padding(8)
                FilteredList(filter: day)
                
                Spacer()
                MonthlyProgressView()
                    .padding()
            }
            .padding()
            .frame(maxWidth: .infinity)
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
        ForEach(schedules) { schedule in
            ScheduleRowItem(title: schedule.plan?.title ?? "none", time: schedule.time ?? Date.now)
        }.listRowBackground(Color.lighterGrey)
    }
}

struct ScheduleRowItem: View {
    var title: String
    var time: Date
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title3.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(timeFormatter.string(from: time))
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
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
        .frame(maxWidth: .infinity)
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
                        .foregroundColor(Color.darkerOrange)
                        .frame(width: 48, height: 48)
                }
                Text(dayLabel)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}

struct MonthlyProgressView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutLog.date, ascending: false)],
        animation: .default)
    private var workoutLogs: FetchedResults<WorkoutLog>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Schedule.time, ascending: false)],
        animation: .default)
    private var schedules: FetchedResults<Schedule>
    
    @State private var monthlyCompletion: Double = 0
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack {
            Text("Monthly completion")
                .font(.title.bold())
            HStack {
                Spacer()
                HStack {
                    Button {
                        switchToPreviousMonth()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.lighterOrange)
                            .font(.title.bold())
                    }
                    VStack {
                        Text(selectedDate.month)
                            .font(.body.bold())
                        Text(selectedDate.year)
                            .font(.body.bold())
                    }
                    .frame(width: 120)
                    Button {
                        switchToNextMonth()
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.lighterOrange)
                            .font(.title.bold())
                    }
                }
            }
            .padding()
            ZStack {
                Circle()
                    .stroke(lineWidth: 20.0)
                    .opacity(0.20)
                    .foregroundColor(.gray)
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(Double(monthlyCompletion), 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.lighterGreen)
                    .rotationEffect(Angle(degrees: 270))
                    .animation(.easeOut, value: 5)
                Text("\(Int(monthlyCompletion*100)) %")
                    .font(.title.bold())
            }
            .frame(width: 210, height: 210)
            .onAppear {
                monthlyCompletion = getMonthlyCompletion()
            }
        }
    }
    
    func switchToNextMonth() {
        selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? Date()
        monthlyCompletion = getMonthlyCompletion()
    }
    
    func switchToPreviousMonth() {
        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? Date()
        monthlyCompletion = getMonthlyCompletion()
    }
    
    func getMonthlyCompletion() -> Double {

        var numbersOfDays: [String:Int] = [:]
        
        let calendar = Calendar.current

        let interval = calendar.dateInterval(of: .month, for: selectedDate)!
        //print(interval)

        // Compute difference in days:
        //let days = calendar.dateComponents([.weekday], from: interval.start, to: interval.end).weekday!
        
        let dayDurationInSeconds: TimeInterval = 60*60*24
        for dat in stride(from: interval.start, to: interval.end, by: dayDurationInSeconds) {
           // print(date.dayOfTheWeek(day: dat))
            numbersOfDays[selectedDate.dayOfTheWeek(day: dat), default: 0] += 1
        }
        
        var numberOfSchedules: Int = 0
        for schedule in schedules {
            numberOfSchedules += numbersOfDays[schedule.day ?? "none"] ?? 0
        }
        
        let filteredLog = workoutLogs.filter { $0.date?.month == selectedDate.month && $0.date?.year == selectedDate.year}
        
        if numberOfSchedules != 0 {
            return Double(filteredLog.count)/Double(numberOfSchedules)
        } else {
                return 0.0
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
