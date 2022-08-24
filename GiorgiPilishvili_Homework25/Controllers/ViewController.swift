//
//  ViewController.swift
//  GiorgiPilishvili_Homework25
//
//  Created by GIORGI PILISSHVILI on 23.08.22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var tableViewCategories: UITableView!
    
    private let manager = FileManager.default
            
    let searchController = UISearchController()
    
    var arrayOfCategories = [Category]()
    var filteredCategories = [Category]()
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNavigationItem()
        configureTableView()
        loadCategories()
    }
    
    // MARK: - Initial Functions
    
    func configureNavigationItem() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func configureTableView() {
        tableViewCategories.delegate = self
        tableViewCategories.dataSource = self
        tableViewCategories.register(UINib(nibName: CategoryCell.identifer, bundle: nil), forCellReuseIdentifier: CategoryCell.identifer)
    }
    
    func loadCategories() {
        
        let documentsDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let documentsDirectory = documentsDirectory else { return }

        let categoriesDirectory = documentsDirectory.appendingPathComponent("Categories")
        
        let exists = manager.fileExists(atPath: categoriesDirectory.path)
        if exists {
            
            do {
                let names = try categoriesDirectory.subDirectoriesNames()
                
                arrayOfCategories.removeAll()

                for subName in names {
                    let content = manager.subpaths(atPath: categoriesDirectory.appendingPathComponent(subName).path)
                    
                    let currentCategory = Category(name: subName, itemCount: content?.count ?? 0)
                    arrayOfCategories.append(currentCategory)
                }

                filteredCategories = arrayOfCategories
                tableViewCategories.reloadData()
                
            } catch {
                print(error)
            }
            
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func actionAddCategory(_ sender: UIButton) {
        showAlert()
    }
    
    // MARK: - Other functions
    
    func showAlert() {
        let alert = UIAlertController(title: "Enter category name", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let action = UIAlertAction(title: "Create", style: .default) { [weak alert] _ in
            let categoryName = alert?.textFields!.first?.text
            guard let categoryName = categoryName else { return }
            self.createDirectory(with: categoryName)
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(action)
        alert.addAction(actionCancel)

        present(alert, animated: true)
    }
    
    func createDirectory(with name: String) {
        
        let documentsDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let documentsDirectory = documentsDirectory else { return }

        let categoriesDirectory = documentsDirectory.appendingPathComponent("Categories")
        
        do {
            try manager.createDirectory(
                at: categoriesDirectory.appendingPathComponent(name),
                withIntermediateDirectories: true, attributes: [.creationDate: Date()])
        } catch {
            print(error)
        }
    
        loadCategories()
        
    }

}
