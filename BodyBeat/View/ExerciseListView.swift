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
    
    @State var selectedExercise: Exercise?
    
    var body: some View {
        List {
            ForEach(exercises) { exercise in
                Button {
                    selectedExercise = exercise
                    isNewExerciseVisible = true
                } label: {
                    HStack {
                        VStack {
                            Text(exercise.title ?? "no title")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(exercise.sets) x \(exercise.repeats)")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    
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
            NewExerciseView(exercises: $exercises, isNewExerciseVisible: $isNewExerciseVisible, exercise: $selectedExercise)
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
