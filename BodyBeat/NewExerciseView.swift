//
//  NewExerciseView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 06.05.2022.
//

import SwiftUI

struct NewExerciseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var exercises: [Exercise]
    @State var title: String = "empty"
    @State var sets: Int = 0
    @State var repeats: Int = 0
    
    @Binding var isNewExerciseVisible: Bool
    
    func saveExercise() {
        let exercise = Exercise(context: viewContext)
        exercise.title = title
        exercise.sets = Int16(sets)
        exercise.repeats = Int16(repeats)
        exercises.append(exercise)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Title", text: $title)
                HStack {
                    NumberPickerView(label: "Sets", maxInputRange: 10, selectedNumber: $sets)
                    Text("x")
                    NumberPickerView(label: "Repeats", maxInputRange: 50, selectedNumber: $repeats)
                }
            }
            .navigationTitle("Add exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isNewExerciseVisible = false
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        saveExercise()
                        isNewExerciseVisible = false
                    }) {
                        Text("Save")
                    }
                }
            }
        }
    }
}

struct NewExerciseView_Previews: PreviewProvider {
    static var exercises: [Exercise] = []
    
    static var previews: some View {
        NewExerciseView(exercises: .constant(exercises), isNewExerciseVisible: .constant(false))
    }
}
