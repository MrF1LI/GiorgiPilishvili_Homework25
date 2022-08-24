//
//  ConfigReminders.swift
//  GiorgiPilishvili_Homework25
//
//  Created by GIORGI PILISSHVILI on 23.08.22.
//

import UIKit

extension RemindersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredReminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReminderCell.identifer, for: indexPath) as? ReminderCell
        guard let cell = cell else { return UITableViewCell() }
        
        let currentReminder = filteredReminders[indexPath.row]
        cell.configure(with: currentReminder)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentReminder = filteredReminders[indexPath.row]
        showDetails(of: currentReminder)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentReminder = filteredReminders[indexPath.row]
            showAlert(reminder: currentReminder)
        }
    }
    
    // Other functions
    
    func showDetails(of reminder: Reminder) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewReminderViewController") as? NewReminderViewController
        guard let vc = vc else { return }
        
        vc.reminder = reminder
        vc.category = category
        
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true)
    }
    
    func showAlert(reminder: Reminder) {
        let alert = UIAlertController(title: "Delete \(reminder.fileName)?", message: nil, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        let actionDelete = UIAlertAction(title: "Yes", style: .default) { action in
            self.delete(reminder: reminder)
        }
        alert.addAction(actionCancel)
        alert.addAction(actionDelete)
        
        present(alert, animated: true)
        
    }
    
    func delete(reminder: Reminder) {
        let documentsDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let documentsDirectory = documentsDirectory else { return }

        let categoriesDirectory = documentsDirectory.appendingPathComponent("Categories")
        let currentCategoryDirectory = categoriesDirectory.appendingPathComponent(category.name)
        
        let fileUrl = currentCategoryDirectory.appendingPathComponent(reminder.fileName).appendingPathExtension("txt")
        
        do {
            try manager.removeItem(atPath: fileUrl.path)
        } catch {
            print(error)
        }
        
        loadReminders()
    }
    
}
