//
//  NewReminderViewController.swift
//  GiorgiPilishvili_Homework25
//
//  Created by GIORGI PILISSHVILI on 23.08.22.
//

import UIKit

class NewReminderViewController: UIViewController {
    
    @IBOutlet weak var textViewContent: UITextView!
    
    let textFieldTitle = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 22))

    let manager = FileManager.default
    var category: Category!
    var reminder: Reminder!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNavigationItem()
        configure()
    }
    
    func configure() {
        let documentsDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let documentsDirectory = documentsDirectory else { return }
        
        let categoriesDirectory = documentsDirectory.appendingPathComponent("Categories")
        
        let currentCategoryDirectory = categoriesDirectory.appendingPathComponent(category.name)
        let path = currentCategoryDirectory.appendingPathComponent(reminder.fileName).appendingPathExtension("txt").path
        
        let content = try? String(contentsOfFile: path, encoding: .utf8)
        
        textViewContent.text = content
    }
    
    func configureNavigationItem() {
        
        // Title
        
        textFieldTitle.placeholder = "Enter title"
        textFieldTitle.text = reminder.fileName
        textFieldTitle.textColor = .black
        textFieldTitle.font = .boldSystemFont(ofSize: 20)
        textFieldTitle.textAlignment = .center
        self.navigationItem.titleView = textFieldTitle
        
        // Save button
        
        let buttonSave = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveFile))
        navigationItem.setRightBarButton(buttonSave, animated: true)
        
        // Cancel button
        
        let buttonBack = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(actionCancel))
        buttonBack.title = "Cancel"
        buttonBack.tintColor = .systemMint
        
        navigationItem.setLeftBarButton(buttonBack, animated: true)
        
    }
    
    @objc func saveFile() {
        let documentsDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let documentsDirectory = documentsDirectory else { return }

        let categoriesDirectory = documentsDirectory.appendingPathComponent("Categories")

        let currentCategoryDirectory = categoriesDirectory.appendingPathComponent(category.name)

        if let title = textFieldTitle.text,
           let content = textViewContent.text {
            let file = currentCategoryDirectory.appendingPathComponent("\(title).txt")

            try? content.write(to: file, atomically: false, encoding: .utf8)
        }
        
        dismiss(animated: true)
    }

    
    @objc func actionCancel() {
        dismiss(animated: true)
    }

}
