//
//  ViewController.swift
//  CoreDataPractice1
//
//  Created by PAVIT KALRA on 2023-01-22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //STEP 1 REFERENCE TO MANAGED OBJECT CONTEXT
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    //data for the table
    var items: [Person]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        //get items from coredata
        fetchPeople()
        
    }

    
    func fetchPeople(){
        
        do{
            
            self.items = try context.fetch(Person.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            
        }
        
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Person", message: "What is their name?", preferredStyle: .alert)
        alert.addTextField()
        
        let submitButton = UIAlertAction(title: "Add", style: .default) {(action) in
            
            
            let textField = alert.textFields![0]
            
            //CREATE NEW PERSON OBJECT
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text
            newPerson.age = 20
            newPerson.gender = "Male"
            
            
            
            //SAVE THE DATA
            do{
                try self.context.save()
                
            }
            catch{
                
            }
            
            
            //REFETCH THE DATA
            self.fetchPeople()
        }
        alert.addAction(submitButton)
        
        self.present(alert, animated: true)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        let person = self.items![indexPath.row]
        
        
        cell.textLabel?.text = person.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //SELECTED PERSON
        let person = self.items![indexPath.row]
        
        
        //CREATE ALERT
        let alert = UIAlertController(title: "Edit Person", message: "Edit Name", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields![0]
        textField.text = person.name
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            let textField = alert.textFields![0]
            
            
            //edit name property of person object
            person.name = textField.text
            
            //save the data
            do{
                try self.context.save()
            }
            catch{
                
            }
            
            //refetch data
            self.fetchPeople()
            
        }
        //add action
        alert.addAction(saveButton)
        
        //show alert
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            
            //which person to remove
            let personToRemove = self.items![indexPath.row]
            
            //remove the person
            self.context.delete(personToRemove)
            
            //save the data
            do{
                try self.context.save()
            }
            catch{
                
            }
            
            //refetch the data
            self.fetchPeople()
            
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    

}


