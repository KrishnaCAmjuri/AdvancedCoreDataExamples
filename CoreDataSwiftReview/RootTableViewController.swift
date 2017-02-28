//
//  RootTableViewController.swift
//  CoreDataSwiftReview
//
//  Created by KrishnaChaitanya Amjuri on 26/02/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//

import UIKit
import CoreData

class RootTableViewController: UITableViewController {

    var people: [NSManagedObject] = []
    var names: [String] = []
    
    @IBAction func addName(_ sender: Any) {
     
        var alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if let textField:UITextField = alert.textFields?[0] {
                if let text = textField.text {
                    if text.characters.count > 0 {
                        self.saveName(name: text)
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        
        alert.addTextField { (textField) in
            
        }
     
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveName(name: String) {
        
        if let appDelegate:AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            let managedObjContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            
            guard let entity:NSEntityDescription = NSEntityDescription.entity(forEntityName: "Person", in: managedObjContext) else {
                return
            }
            
            let person:NSManagedObject = NSManagedObject(entity: entity, insertInto: managedObjContext)
            
            person.setValue(name, forKey: "name")
            
            do {
                try managedObjContext.save()
                people.append(person)
            }catch {
                
            }
        }
    }
    
    func fetchAllObjects() {
        
        if let appDelegate:AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            let managedObjContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext

            let fetchRequest:NSFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
            
            do {
                guard let fetchedResults:NSAsynchronousFetchResult<NSManagedObject> = try managedObjContext.execute(fetchRequest as NSPersistentStoreRequest) as? NSAsynchronousFetchResult<NSManagedObject> else {
                    return
                }
                if let results:[NSManagedObject] = fetchedResults.finalResult {
                    self.people = results
                    self.tableView.reloadData()
                }
            }catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fetchAllObjects()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let person = people[indexPath.row]
        
        cell.textLabel?.text = person.value(forKey: "name") as? String

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
