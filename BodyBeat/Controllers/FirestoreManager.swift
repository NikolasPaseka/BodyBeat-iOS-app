//
//  FirestoreManager.swift
//  BodyBeat
//
//  Created by Nikolas Paseka on 30.05.2022.
//

import Foundation
import Firebase
import CoreData
import SwiftUI

class FirestoreManager: ObservableObject {
    //@Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Plan.title, ascending: true)],
        animation: .default)
    private var plans: FetchedResults<Plan>
    
    init() {}
    
    func getData(viewContext: NSManagedObjectContext) {
        let db = Firestore.firestore()
        let ref = db.collection("Plan")
        let refExercise = db.collection("Exercise")
        let refSchedule = db.collection("Schedule")
        
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let planId = document.documentID
                    let title = data["title"] as? String ?? "none"
                    let timerSeries = data["timerSeries"] as? Int16 ?? 0
                    let timerExercise = data["timerExercise"] as? Int16 ?? 0
                    
                    let plan = Plan(context: viewContext)
                    plan.title = title
                    plan.timerSeries = timerSeries
                    plan.timerExercise = timerExercise
                    
                    refExercise.getDocuments { snapshot, error in
                        if let snapshot = snapshot {
                            for document in snapshot.documents.filter({$0.data()["planId"] as? String == planId }) {
                                let data = document.data()
                                
                                let exercise = Exercise(context: viewContext)
                                exercise.title = data["title"] as? String
                                exercise.sets = data["sets"] as? Int16 ?? 0
                                exercise.repeats = data["repeats"] as? Int16 ?? 0
                                
                                plan.addToExercises(exercise)
                                
                                do {
                                    try viewContext.save()
                                } catch {
                                    let nsError = error as NSError
                                    print(nsError)
                                    //fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                }
                            }
                        }
                    }
                    
                    refSchedule.getDocuments { snapshot, error in
                        guard error == nil else { return }
                        
                        if let snapshot = snapshot {
                            for document in snapshot.documents.filter({$0.data()["planId"] as? String == planId }) {
                                let data = document.data()
                                
                                let schedule = Schedule(context: viewContext)
                                schedule.day = data["day"] as? String
                                let time: Timestamp? = data["time"] as? Timestamp
                                schedule.time = time?.dateValue()
                                print("\(String(describing: schedule.day)) \(String(describing: schedule.time))")
                                
                                plan.addToSchedules(schedule)
                                
                                do {
                                    try viewContext.save()
                                } catch {
                                    let nsError = error as NSError
                                    print(nsError)
                                    //fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                }
                            }
                        }
                    }
                    
                    //print("data added: \(plan.title!) \(plan.timerSeries) \(plan.timerExercise)")
                    
                    print("data added: \(title) \(timerSeries) \(timerExercise)")

                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        print(nsError)
                        //fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
            }
        }
    }
}
