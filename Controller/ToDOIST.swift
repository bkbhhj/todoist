//
//  ViewController.swift
//  todoist
//
//  Created by Павел Тимофеев on 04.06.2021.
//

import UIKit
import CoreData

class ToDoIstVC: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    var goals: [Goals] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       fetchDataObjects()
        tableView.reloadData()
    }
    
    func fetchDataObjects() {
        self.fetch { complete in
            if complete {
                if goals.count >= 1 {
                    tableView.isHidden = false
                } else {
                    tableView.isHidden = true
                }
            }
        }
    }

    @IBAction func addGoalWasPressed(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else {return}
        
presentDetail(viewControllerToPresent: createGoalVC)
    }
    
    
    
    
}

extension ToDoIstVC: UITabBarDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else { return UITableViewCell() }
        
        
        let goal = goals[indexPath.row]
        
        cell.configureCell(goal: goal)
        return cell
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            self.removeGoal(atIndexPath: indexPath)
            self.fetchDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return [deleteAction]
    }
}
 


extension ToDoIstVC {
    func removeGoal(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        managedContext.delete(goals[indexPath.row])
        
        do {
            try managedContext.save()
            print("Успешно")
 
        } catch {
            debugPrint("Ошибка - \(error)")
        }
    }
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let fetchRequest = NSFetchRequest<Goals>(entityName: "Goals")
        
        
        do {
            goals = try managedContext.fetch(fetchRequest)
            print("Успешно")
            tableView.reloadData()

            completion(true)
    }
        catch {
            debugPrint("Ошибка - \(error)")
            completion(false)

        }
}

}
