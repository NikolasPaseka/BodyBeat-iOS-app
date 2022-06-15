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
    
    init() {}
    
    func syncData(plans: [Plan], viewContext: NSManagedObjectContext, userId: String, completionHandler: @escaping () -> Void) {
        var plansId: [String] = []
        var logsId: [String] = []
        
        let db = Firestore.firestore()
        let refLog = db.collection("WorkoutLog").whereField("userId", isEqualTo: userId)
        let ref = db.collection("Plan").whereField("userId", isEqualTo: userId)
        let refExercise = db.collection("Exercise")
        let refSchedule = db.collection("Schedule")
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Plan")
        request.returnsObjectsAsFaults = false
        do {
            let result = try viewContext.fetch(request)
            for data in result as! [NSManagedObject] {
                plansId.append(data.value(forKey: "planId") as! String)
            }
        } catch {
            print(error)
        }
        
        let requestLogs = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutLog")
        requestLogs.returnsObjectsAsFaults = false
        do {
            let result = try viewContext.fetch(requestLogs)
            for data in result as! [NSManagedObject] {
                logsId.append(data.value(forKey: "logId") as! String)
            }
        } catch {
            print(error)
        }
        
        refLog.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let logId = document.documentID
                    if !logsId.contains(logId) {
                        let log = WorkoutLog(context: viewContext)
                        let time: Timestamp? = data["date"] as? Timestamp
                        log.date = time?.dateValue()
                        log.logId = logId
                        
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            print(nsError)
                        }
                    }
                }
            }
        }
        
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let planId = document.documentID
                    if !plansId.contains(planId) {
                    
                        let title = data["title"] as? String ?? "none"
                        let timerSeries = data["timerSeries"] as? Int16 ?? 0
                        let timerExercise = data["timerExercise"] as? Int16 ?? 0
                        
                        let plan = Plan(context: viewContext)
                        plan.planId = planId
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
                                    }
                                }
                            }
                        }
                        
                        print("data added: \(title) \(timerSeries) \(timerExercise)")
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            print(nsError)
                        }
                    }
                }
                completionHandler()
            }
        }
        
        uploadData(plans: plans, viewContext: viewContext, userId: userId)
    }
    
    func getUploadedPlansId(completionHandler: @escaping ([String]) -> Void) {
        var plansId: [String] = []
        
        let db = Firestore.firestore()
        let ref = db.collection("Plan")
        
        ref.getDocuments { (snapshot, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    plansId.append(document.documentID)
                    print(document.documentID)
                }
            }
            
            completionHandler(plansId)
        }
    }
    
    func uploadData(plans: [Plan], viewContext: NSManagedObjectContext, userId: String) {
        
        getUploadedPlansId { plansId in
            print(plansId)
            
            let filteredPlans = plans.filter { !plansId.contains($0.planId ?? "none") }
            
            let db = Firestore.firestore()
            for plan in filteredPlans {
                let ref = db.collection("Plan").document(plan.planId ?? "none")
                ref.setData([
                    "title": plan.title ?? "none",
                    "timerSeries": Double(plan.timerSeries),
                    "timerExercise": Double(plan.timerExercise),
                    "userId": userId
                ]) { error in
                    if let error = error {
                        print(error)
                    }
                }
                print("Document added with id: \(ref.documentID)")
                let planId = ref.documentID
                
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
                request.predicate = NSPredicate(format: "plan = %@", plan)
                request.returnsObjectsAsFaults = false
                do {
                    let result = try viewContext.fetch(request)
                    for data in result as! [NSManagedObject] {
                        print(data.value(forKey: "title") as! String)
                        let ref = db.collection("Exercise").addDocument(data: [
                            "title": data.value(forKey: "title") as? String ?? "none",
                            "sets": data.value(forKey: "sets") as? Int16 ?? 0,
                            "repeats": data.value(forKey: "repeats") as? Int16 ?? 0,
                            "planId": planId
                        ]) { error in
                            if let error = error {
                                print(error)
                            }
                        }
                        print("Exercise added with id: \(ref.documentID)")
                    }
                } catch {
                    print(error)
                }
                
                let reqSchedule = NSFetchRequest<NSFetchRequestResult>(entityName: "Schedule")
                reqSchedule.predicate = NSPredicate(format: "plan = %@", plan)
                reqSchedule.returnsObjectsAsFaults = false
                do {
                    let result = try viewContext.fetch(reqSchedule)
                    for data in result as! [NSManagedObject] {
                        print(data.value(forKey: "day") as! String)
                        let time = data.value(forKey: "time") as? Date ?? Date.now
                        let timestamp = time.timeIntervalSince1970
                        let ref = db.collection("Schedule").addDocument(data: [
                            "day": data.value(forKey: "day") as? String ?? "monday",
                            "time": timestamp,
                            "planId": planId
                        ]) { error in
                            if let error = error {
                                print(error)
                            }
                        }
                        print("Schedule added with id: \(ref.documentID)")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func deleteData() {
        let db = Firestore.firestore()
        
        db.collection("Plan").whereField("userId", isEqualTo: "test").getDocuments { (querySnapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
            }
        }
    }
}
