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
    @State var title: String = ""
    @State var sets: Int = 0
    @State var repeats: Int = 0
    
    @Binding var isNewExerciseVisible: Bool
    
    @State var exercise: Exercise?
    
    func saveExercise() {
        var isEditing = true
        if exercise == nil {
            exercise = Exercise(context: viewContext)
            isEditing = false
        }
        exercise?.title = title
        exercise?.sets = Int16(sets)
        exercise?.repeats = Int16(repeats)
        if !isEditing {
            exercises.append(exercise!)
        }
    }
    
    var body: some View {
        VStack {
            RoundedTextField(placeHolder: "Exercise title", value: $title)
            
            HStack {
                NumberPickerView(label: "Sets", maxInputRange: 10, selectedNumber: $sets)
                Text("x")
                    .padding(.top, 30)
                NumberPickerView(label: "Repeats", maxInputRange: 50, selectedNumber: $repeats)
            }
            .padding()
            Spacer()
        }
        .task {
            if let exercise = exercise {
                title = exercise.title ?? "none"
                sets = Int(exercise.sets)
                repeats = Int(exercise.repeats)
            }
        }
        .padding()
        .background(Color.backgroundColor)
        .navigationTitle("Add exercise")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
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

struct NewExerciseView_Previews: PreviewProvider {
    static var exercises: [Exercise] = []
    
    static var previews: some View {
        NewExerciseView(exercises: .constant(exercises), isNewExerciseVisible: .constant(false))
            .preferredColorScheme(.dark)
    }
}
