//
//  DataManager.swift
//  AccountBook
//
//  Created by 정창규 on 2020/11/16.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
    static let shared = DataManager()
    private init() {
        
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var dataList = [DataInfo]()
    var budgetInfo = [BudgetInfo]()
    
    func fetchData(year: String, month: String) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let date = df.date(from: "\(year)-\(month)-01")!
        
        let request1: NSFetchRequest<DataInfo> = DataInfo.fetchRequest()
        let request2: NSFetchRequest<BudgetInfo> = BudgetInfo.fetchRequest()
        
        let sortByDateDesc = NSSortDescriptor(key: "date", ascending: false)
        request1.sortDescriptors = [sortByDateDesc]
        
        let startDate = date as CVarArg
        let endDate = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: date)! as CVarArg
        
        var pred = NSPredicate(format: "date >= %@ && date <= %@", startDate, endDate)
        request1.predicate = pred
        
        pred = NSPredicate(format: "date == \(year)\(month)")
        request2.predicate = pred
        
        do {
            dataList =  try context.fetch(request1)
            budgetInfo =  try context.fetch(request2)
        } catch {
            print(error)
        }
        
    }
    
    func addData(_ date: Date, _ amount: Int, _ category: String, _ contents: String?) {
        let newData = DataInfo(context: context)
        
        newData.date = date
        newData.amount = Int64(amount)
        newData.category = category
        newData.contents = contents
        saveContext()
    }
    
    func deleteData(_ data: DataInfo?) {
        guard let data = data else {
            return
        }
        context.delete(data)
        saveContext()
    }
    
    func setBudget(_ date:String,_ budget: Int) {
        
        let request: NSFetchRequest<BudgetInfo> = BudgetInfo.fetchRequest()
        request.predicate = NSPredicate(format: "date == \(date)")
        
        do {
            let temp = try context.fetch(request)
            
            if(temp.count > 0) {
                temp[0].boudget = Int64(budget)
            }else {
                let newBudget = BudgetInfo(context: context)
                newBudget.date = date
                newBudget.boudget = Int64(budget)
            }
            saveContext()
        } catch {
            print(error)
        }
        
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
