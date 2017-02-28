//
//  CoreDataStack.swift
//  CoreDataSwiftReview
//
//  Created by KrishnaChaitanya Amjuri on 27/02/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//

import CoreData

class CoreDataStack {

    var context: NSManagedObjectContext!
    var storeCoordinator: NSPersistentStoreCoordinator!
    var model: NSManagedObjectModel!
    var store: NSPersistentStore!
    
    let dogWalkModelStr: String = "DogWalkModel"
    let bubbleTeaModelStr: String = "BubbleTeaModel"
    
    static let sharedManager: CoreDataStack = CoreDataStack()
    
    init() {
        
        let bundle = Bundle.main
        
        guard let modelUrl = bundle.url(forResource: bubbleTeaModelStr, withExtension: "momd") else { return}
        
        model = NSManagedObjectModel(contentsOf: modelUrl)!
        
        storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = storeCoordinator
        
        let documentsUrl: URL = applicationsDocumentUrl()
        let storeUrl: URL = documentsUrl.appendingPathComponent(bubbleTeaModelStr)
        
        let options = [NSMigratePersistentStoresAutomaticallyOption: true]
        
        do {
            store = try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: options)
            self.importJSONSeedDataIfNeeded()
        }catch let error {
            assert(false, "Failed due to reason:-\n\(error.localizedDescription)")
        }
    }
    
    func saveContext() {
        
        if self.context.hasChanges {
            do {
                try self.context.save()
            }catch {
                
            }
        }
    }
    
    func applicationsDocumentUrl() -> URL {
        
        let fileManager = FileManager()
        let urls:[URL] = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }
    
    func importJSONSeedDataIfNeeded() {
        
        let fetchRequest = NSFetchRequest<Venue>(entityName: "Venue")
        
        do {
            let resultCount:Int = try self.context.count(for: fetchRequest)
            if resultCount == 0 {
                importJSONSeedData()
            }
        }catch {
            print("exception")
        }
    }
    
    func importJSONSeedData() {
        
        let jsonURL = Bundle.main.url(forResource: "seed", withExtension: "json")
        
        do {
            let jsonData = try Data(contentsOf: jsonURL!)
            let jsonObj = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
            
            let venueEntity = NSEntityDescription.entity(forEntityName: "Venue", in: self.context)
            let locationEntity = NSEntityDescription.entity(forEntityName: "Location", in: self.context)
            let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in: self.context)
            let priceEntity = NSEntityDescription.entity(forEntityName: "PriceInfo", in: self.context)
            let statsEntity = NSEntityDescription.entity(forEntityName: "Stats", in: self.context)
            
            if let jsonDict = jsonObj as? NSDictionary {
                
                if let jsonArray = jsonDict.value(forKeyPath: "response.venues") as? NSArray {
                    
                    for eachObj in jsonArray {
                        
                        if let jsonDictionary:NSDictionary = eachObj as? NSDictionary {
                            
                            let venueName = jsonDictionary["name"] as! String
                            let venuePhone = jsonDictionary.value(forKeyPath: "contact.phone") as! String
                            let specialCount = jsonDictionary.value(forKeyPath: "specials.count") as! Int32
                            
                            let locationDict = jsonDictionary["location"] as! NSDictionary
                            let priceDict = jsonDictionary["price"] as! NSDictionary
                            let statsDict = jsonDictionary["stats"] as! NSDictionary
                            
                            let location = Location(entity: locationEntity!, insertInto: self.context)
                            location.address = locationDict["address"] as! String
                            location.city = locationDict["city"] as! String
                            location.state = locationDict["state"] as! String
                            location.zipcode = locationDict["postalCode"] as! String
                            location.distance = locationDict["distance"] as! Float
                            
                            let category = Category(entity: categoryEntity!, insertInto: self.context)
                            
                            let priceInfo = PriceInfo(entity: priceEntity!, insertInto: self.context)
                            priceInfo.priceCategory = priceDict["currency"] as! String
                            
                            let stats = Stats(entity: statsEntity!, insertInto: self.context)
                            stats.checkinsCount = statsDict["checkinsCount"] as! Int32
                            stats.usersCount = statsDict["usersCount"] as! Int32
                            stats.tipCount = statsDict["tipCount"] as! Int32
                            
                            let venue = Venue(entity: venueEntity!, insertInto: self.context)
                            venue.name = venueName
                            venue.phone = venuePhone
                            venue.specialCount = specialCount
                            venue.location = location
                            venue.category = category
                            venue.priceInfo = priceInfo
                            venue.stats = stats
                        }
                    }
                }
            }
        }catch let error {
            
            print(error.localizedDescription)
        }
        
        do {
            try self.context.save()
        }catch {
            
        }
    }
}
