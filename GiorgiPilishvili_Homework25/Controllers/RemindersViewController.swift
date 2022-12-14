//
//  RemindersViewController.swift
//  GiorgiPilishvili_Homework25
//
//  Created by GIORGI PILISSHVILI on 23.08.22.
//

import UIKit

class RemindersViewController: UIViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var tableViewReminders: UITableView!
    
    let manager = FileManager.default
    
    let searchController = UISearchController()
    var arrayOfReminders = [Reminder]()
    var filteredReminders = [Reminder]()

    var category: Category!
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNavigationItem()
        configureTableView()
        loadReminders()
    }
    
    // MARK: - Functions
    
    func configureNavigationItem() {
        title = category.name
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func configureTableView() {
        tableViewReminders.delegate = self
        tableViewReminders.dataSource = self
        tableViewReminders.register(UINib(nibName: ReminderCell.identifer, bundle: nil), forCellReuseIdentifier: ReminderCell.identifer)
    }
    
    func loadReminders() {
        
        let documentsDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let documentsDirectory = documentsDirectory else { return }

        let categoriesDirectory = documentsDirectory.appendingPathComponent("Categories")
        let currentCategoryDirectory = categoriesDirectory.appendingPathComponent(category.name)

        
        let subPaths = manager.subpaths(atPath: currentCategoryDirectory.path)
        guard let subPaths = subPaths else { return }
        
        arrayOfReminders.removeAll()
        
        for subPath in subPaths {
            let currentReminder = Reminder(fileName: (subPath as NSString).deletingPathExtension)
            arrayOfReminders.append(currentReminder)
        }

        filteredReminders = arrayOfReminders
        tableViewReminders.reloadData()
        
    }
    
    // MARK: Actions
    
    @IBAction func actionAddFile(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Create new reminder", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Title"
        }
        alert.addTextField { textField in
            textField.placeholder = "Note"
        }
                
        let action = UIAlertAction(title: "Create", style: .default) { [weak alert] _ in
            
            let textFieldTitle = alert?.textFields?.first
            let textFieldContent = alert?.textFields?.last
            
            let reminderTitle = textFieldTitle?.text
            let reminderContent = textFieldContent?.text
            
            guard let reminderTitle = reminderTitle else { return }
            guard let reminderContent = reminderContent else { return }

            if !reminderTitle.isEmpty && !reminderContent.isEmpty {
                self.showDatePicker(reminderTitle: reminderTitle, reminderContent: reminderContent)
            }
            
        }

        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(action)
        alert.addAction(actionCancel)

        present(alert, animated: true)
    }
    
    // MARK: - Other functions
    
    func createReminder(title: String, content: String, date: Date) {
        
        let documentsDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let documentsDirectory = documentsDirectory else { return }
        
        let categoriesDirectory = documentsDirectory.appendingPathComponent("Categories")
        
        let currentCategoryDirectory = categoriesDirectory.appendingPathComponent(category.name)
        print(currentCategoryDirectory.path)
        
        let file = currentCategoryDirectory.appendingPathComponent("\(title).txt").path
        
        manager.createFile(
            atPath: file,
            contents: content.data(using: .utf8),
            attributes: [.creationDate : Date.now])
        
        let notification = Notification(id: UUID().uuidString, title: title, message: content)
        
        NotificationManager.shared.register(notification: notification, userInfo: [:], date: date, repeats: false)
        
        loadReminders()
        
    }
    
    func showDatePicker(reminderTitle: String, reminderContent: String) {
        let myDatePicker: UIDatePicker = UIDatePicker()
        myDatePicker.timeZone = .current
        myDatePicker.preferredDatePickerStyle = .wheels
        myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        alertController.view.addSubview(myDatePicker)
        let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.createReminder(title: reminderTitle, content: reminderContent, date: myDatePicker.date)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

}
