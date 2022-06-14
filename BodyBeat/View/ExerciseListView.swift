//
//  ExerciseListView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 06.05.2022.
//

import SwiftUI

struct ExerciseListView: View {
    
    @Binding var exercises: [Exercise]
    @State var isNewExerciseVisible: Bool = false
    
    var body: some View {
        List {
            ForEach(exercises) { exercise in
                VStack {
                    Text(exercise.title ?? "no title")
                    Text("\(exercise.sets) x \(exercise.repeats)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .onDelete(perform: delete)
            .listRowBackground(Color.lighterGrey)
        }
        .background(Color.backgroundColor)
        .navigationTitle("Manage exercises")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    isNewExerciseVisible = true
                }) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isNewExerciseVisible) {
            NewExerciseView(exercises: $exercises, isNewExerciseVisible: $isNewExerciseVisible)
        }
    }
    
    func delete(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }
}

struct ExerciseListView_Previews: PreviewProvider {
    
    static var previews: some View {
        ExerciseListView(exercises: .constant([]))
    }
}
