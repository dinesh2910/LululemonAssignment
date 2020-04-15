//
//  ViewController.swift
//  LululemonAssignment
//
//  Created by Dinesh Danda on 4/14/20.
//  Copyright © 2020 Dinesh Danda. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, AddGarment {
    
    @IBOutlet weak var choiceSegmentController: UISegmentedControl!
    @IBOutlet weak var garmentsListTV: UITableView!
    
    var garmentsList: [Garments] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        garmentsListTV.delegate = self
        garmentsListTV.dataSource = self
        
        //Get data and load
        retrieveData()
        garmentsList = garmentsList.sorted { $0.garmentName.lowercased() < $1.garmentName.lowercased() }
        garmentsListTV.tableFooterView = UIView()
        garmentsListTV.reloadData()

    }
    
    func addGarment(name: String) {
        garmentsList.append(Garments(garmentName: name))
        saveData(garmentName: name)
        garmentsList = garmentsList.sorted { $0.garmentName.lowercased() < $1.garmentName.lowercased() }
        garmentsListTV.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! GarmentAddViewController
        destinationVC.delegate = self
    }
    
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0){
            garmentsList = garmentsList.sorted { $0.garmentName.lowercased() < $1.garmentName.lowercased() }
        }
        else{
            garmentsList = garmentsList.sorted(by: { $0.addedDate.compare($1.addedDate) == .orderedDescending })
        }
        garmentsListTV.reloadData()
    }
    
}

//MARK:- UITableview Delagte & DataSource Handlers

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return garmentsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "garmentCell", for: indexPath) as? GarmentTVCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = garmentsList[indexPath.row].garmentName
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
}

extension ViewController{
    
    func saveData(garmentName:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "Garment", in: managedContext)!
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(Date(), forKey: "createdDate")
        user.setValue(garmentName, forKey: "garmentName")
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Garment")
        do {
            garmentsList = [Garments]()
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                var garment = Garments()
                garment.garmentName = data.value(forKey: "garmentName") as! String
                garment.addedDate = data.value(forKey: "createdDate") as! Date
                garmentsList.append(garment)
            }
            
        } catch {
            print("Failed")
        }
    }
    
}


struct Garments: Codable {
    var garmentName = ""
    var addedDate = Date()
}
