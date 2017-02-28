//
//  BowTieRootViewController.swift
//  CoreDataSwiftReview
//
//  Created by KrishnaChaitanya Amjuri on 26/02/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//

import UIKit
import CoreData

class BowTieRootViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var timesWorn: UILabel!
    
    @IBOutlet weak var lastWornLabel: UILabel!
    
    @IBOutlet weak var favouriteLabel: UILabel!
    
    @IBAction func wearButtonTapped(_ sender: Any) {
    
        if let current_bowtie: BowTie = self.currentBowTie {
            current_bowtie.lastWorn = NSDate()
            current_bowtie.timesWorn = current_bowtie.timesWorn + 1
            do {
                try self.managedObjectContext.save()
            }catch let error {
                print(error.localizedDescription)
            }
            self.populateBowTie(bowTie: current_bowtie)
        }
    }
    
    @IBAction func rateButtonTapped(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "Rate", message: "Please rate the tie", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if let textField:UITextField = alert.textFields?[0] {
                if let text = textField.text {
                    if text.characters.count > 0 {
                        if let ratingNumStr: NSString = text as? NSString {
                            if ratingNumStr.doubleValue != nil {
                                if let current_bowtie: BowTie = self.currentBowTie {
                                    current_bowtie.rating = ratingNumStr.doubleValue
                                    do {
                                        try self.managedObjectContext.save()
                                        self.populateBowTie(bowTie: current_bowtie)
                                    }catch let error {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        if let segmentControl: UISegmentedControl = sender as? UISegmentedControl {
            print(segmentControl.selectedSegmentIndex)
            self.fetchData()
        }
    }
    
    var managedObjectContext: NSManagedObjectContext {
        get {
            let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
            return appDelegate.persistentContainer.viewContext
        }
    }
    
    var currentBowTie: BowTie?
    
    func insertSampleData() {
        
        let fetchReq:NSFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BowTie")
        
        let predicate:NSPredicate = NSPredicate(format: "%K != nil", argumentArray: ["searchKey"])
        fetchReq.predicate = predicate
        
        do {
            let count = try managedObjectContext.count(for: fetchReq)
            
            if count == 0 {
                
                guard let path:String = Bundle.main.path(forResource: "SampleData", ofType: "plist") else { return}
                
                if let dataArray:NSArray = NSArray(contentsOfFile: path) {
                    
                    for dict in dataArray {
                    
                        if let entityDescription = NSEntityDescription.entity(forEntityName: "BowTie", in: managedObjectContext) {
                        
                            let bowTie = BowTie(entity: entityDescription, insertInto: managedObjectContext)
                            
                            if let dataDict: [String : AnyObject] = dict as? [String : AnyObject] {
                                
                                bowTie.name = dataDict["name"] as? String
                                bowTie.searchKey = dataDict["searchKey"] as? String
                                bowTie.rating = dataDict["rating"] as! Double
                                
                                let tintColorDict = dataDict["tintColor"] as! [String: Any]
                                
                                if let tintColor = colorFromDict(colorDict: tintColorDict) {
                                    bowTie.tintColor = tintColor
                                }
                                
                                let imageName = dataDict["imageName"] as! String
                                let image: UIImage = UIImage(named: imageName)!
                                if let photoData = UIImageJPEGRepresentation(image, 1.0) {
                                    bowTie.photoData = photoData as NSData
                                }
                                
                                bowTie.lastWorn = dataDict["lastWorn"] as? NSDate
                                bowTie.timesWorn = (dataDict["timesWorn"] as! NSNumber).int64Value
                                bowTie.isFavourite = dataDict["isFavorite"] as! Bool
                            }
                            
                            do {
                                try managedObjectContext.save()
                            }catch let error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }catch {
            return
        }
    }
    
    func colorFromDict(colorDict: [String: Any]) -> UIColor? {
        
        guard let red:NSNumber = colorDict["red"] as? NSNumber else {return nil}
        guard let blue:NSNumber = colorDict["blue"] as? NSNumber else {return nil}
        guard let green:NSNumber = colorDict["green"] as? NSNumber else {return nil}
        
        let color:UIColor = UIColor(red: CGFloat(red.doubleValue/255.0), green: CGFloat(blue.doubleValue/255.0), blue: CGFloat(green.doubleValue/255.0), alpha: 1.0)
        return color
    }
    
    func fetchData() {
        
        let currentIndex:Int = self.segmentedControl.selectedSegmentIndex
        let searchKey:String = self.segmentedControl.titleForSegment(at: currentIndex)!
        
        let predicate:NSPredicate = NSPredicate(format: "%K == %@", argumentArray: ["searchKey", searchKey])
        
        let request:NSFetchRequest = NSFetchRequest<BowTie>(entityName: "BowTie")
        request.predicate = predicate
        
        do {
            let results:[BowTie] = try managedObjectContext.fetch(request)
            if results.count == 1 {
                populateBowTie(bowTie: results[0])
            }
        }catch {
            
        }
    }
    
    func populateBowTie(bowTie: BowTie) {
        
        currentBowTie = bowTie
        
        if let photoData:Data = bowTie.photoData as? Data {
            if let image:UIImage = UIImage(data: photoData) {
                imageView.image = image
            }
            nameLabel.text = bowTie.name!
            ratingLabel.text = "\(bowTie.rating)/5"
            timesWorn.text = "\(bowTie.timesWorn)"
            favouriteLabel.text = bowTie.isFavourite ? "♥︎" : "♡"
            let formatter:DateFormatter = DateFormatter()
            formatter.dateFormat = "dd:MM:yyyy"
            lastWornLabel.text = formatter.string(from: bowTie.lastWorn! as Date)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.insertSampleData()
        self.segmentedControl.selectedSegmentIndex = 0
        self.fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
