//
//  PlanListView.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 21.05.2022.
//

import SwiftUI
import CoreData

struct PlanListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Plan.title, ascending: true)],
        animation: .default)
    private var plans: FetchedResults<Plan>
    
    @State var isNewPlanVisible: Bool = false

    var body: some View {
        NavigationView {
            List {
                ForEach(plans) { plan in
                    NavigationLink(destination: PlanDetailView(plan: plan)) {
                        Text("\(plan.title!) \(plan.exercises?.count ?? 0)")
                    }
                }
                .onDelete(perform: deleteItems)
                .listRowBackground(Color("lighterGrey"))
            }
            .background(Color.backgroundColor.ignoresSafeArea())
            .navigationTitle("Workout plans")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    NavigationLink(destination: NewPlanView(plan: nil, isNewPlanVisible: $isNewPlanVisible),
                                   isActive: $isNewPlanVisible) {
                        Button(action: {
                            isNewPlanVisible = true
                        }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newPlan = Plan(context: viewContext)
            newPlan.title = "Test"

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { plans[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct PlanListView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
