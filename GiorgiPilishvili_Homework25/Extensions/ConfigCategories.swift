//
//  ConfigCategories.swift
//  GiorgiPilishvili_Homework25
//
//  Created by GIORGI PILISSHVILI on 23.08.22.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifer, for: indexPath) as? CategoryCell
        guard let cell = cell else { return UITableViewCell() }
        
        let currentCategory = filteredCategories[indexPath.row]
        cell.configure(with: currentCategory)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentCategory = filteredCategories[indexPath.row]
        showReminders(of: currentCategory)
    }
    
    // Other functinos
    
    func showReminders(of category: Category) {
        let categoriesVC = storyboard?.instantiateViewController(withIdentifier: "RemindersViewController") as? RemindersViewController
        guard let categoriesVC = categoriesVC else { return }
        
        categoriesVC.category = category
        navigationController?.pushViewController(categoriesVC, animated: true)
    }
    
}
