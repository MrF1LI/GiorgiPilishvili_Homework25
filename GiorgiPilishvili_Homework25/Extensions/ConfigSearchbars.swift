//
//  ConfigSearchbar.swift
//  GiorgiPilishvili_Homework25
//
//  Created by GIORGI PILISSHVILI on 23.08.22.
//

import UIKit

extension ViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for seaarchController: UISearchController) {
        let searchText = (searchController.searchBar.text ?? "")
            .lowercased()
            .trimmingCharacters(in: .whitespaces)
        
        filteredCategories = []
        
        if searchText.isEmpty {
            filteredCategories = arrayOfCategories
        }
        
        for category in arrayOfCategories {
            if category.name.lowercased().contains(searchText) {
                filteredCategories.append(category)
            }
        }
        
        self.tableViewCategories.reloadData()
    }
        
}

extension RemindersViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = (searchController.searchBar.text ?? "")
            .lowercased()
            .trimmingCharacters(in: .whitespaces)
        
        filteredReminders = []
        
        if searchText.isEmpty {
            filteredReminders = arrayOfReminders
        }
        
        for reminder in arrayOfReminders {
            if reminder.fileName.lowercased().contains(searchText) {
                filteredReminders.append(reminder)
            }
        }
        
        self.tableViewReminders.reloadData()
    }
    
}
