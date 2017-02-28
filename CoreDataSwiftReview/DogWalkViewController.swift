//
//  DogWalkViewController.swift
//  CoreDataSwiftReview
//
//  Created by KrishnaChaitanya Amjuri on 27/02/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//

import UIKit
import CoreData

class DogWalkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentDog: Dog!
    
    @IBAction func addNewWalk(_ sender: Any) {
    
        self.insertWalkEntity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.insertInitialDogEntity()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.tableHeaderView = { () -> UIView in
            let label: UILabel = UILabel(frame: CGRect(x:0, y:0, width:self.view.bounds.size.width, height:40))
            label.text = "List of walks"
            label.textColor = UIColor.blue
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = NSTextAlignment.center
            return label
        }()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CoreData related functions
    
    func insertInitialDogEntity() {
        
        let dogName = "Puppy"
        
        let fetchReq: NSFetchRequest = NSFetchRequest<Dog>(entityName: "Dog")
        fetchReq.predicate = NSPredicate(format: "%K == %@", "name", dogName)
        
        var entityExists: Bool = false
        
        do {
            let result:NSAsynchronousFetchResult<Dog> = try CoreDataStack.sharedManager.context.execute(fetchReq) as! NSAsynchronousFetchResult<Dog>
            if let dogs:[Dog] = result.finalResult {
                if dogs.count == 0 {
                    entityExists = false
                }else {
                    self.currentDog = dogs.last!
                    entityExists = true
                }
            }
        }catch {
            entityExists = false
        }
        
        let dogEntityDesc: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Dog", in: CoreDataStack.sharedManager.context)!
        
        if !entityExists {
            let dog: Dog = Dog(entity: dogEntityDesc, insertInto: CoreDataStack.sharedManager.context)
            dog.name = dogName
            do {
                try CoreDataStack.sharedManager.context.save()
            }catch {
                
            }
        }
    }
    
    func insertWalkEntity() {
        
        let walkEntityDesc: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Walk", in: CoreDataStack.sharedManager.context)!
        
        let walk: Walk = Walk(entity: walkEntityDesc, insertInto: CoreDataStack.sharedManager.context)
        walk.date = NSDate()
        
        let walks = self.currentDog.walk?.mutableCopy() as! NSMutableOrderedSet
        walks.add(walk)
        
        walk.dog = self.currentDog
        
        do {
            try CoreDataStack.sharedManager.context.save()
            self.tableView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteEntity() {
        
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numRows = 0
        
        if let dog: Dog = self.currentDog {
            if let walks: NSOrderedSet = dog.walk {
                numRows = walks.count
            }
        }
        
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        
        if let walks = self.currentDog.walk {
            let walk: Walk = walks[indexPath.row] as! Walk
            cell.textLabel?.text = dateFormatter.string(from: walk.date! as Date)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let walks: NSMutableOrderedSet = (self.currentDog.walk?.mutableCopy() as? NSMutableOrderedSet)!
            
            let walkToDelete: Walk = walks[indexPath.row] as! Walk
            
            walks.removeObject(at: indexPath.row)
            
            self.currentDog.walk = walks
            
            CoreDataStack.sharedManager.context.delete(walkToDelete)
            
            do {
                try CoreDataStack.sharedManager.context.save()
                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            }catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
