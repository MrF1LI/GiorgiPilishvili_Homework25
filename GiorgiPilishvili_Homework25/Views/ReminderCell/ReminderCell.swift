//
//  ReminderCell.swift
//  GiorgiPilishvili_Homework25
//
//  Created by GIORGI PILISSHVILI on 23.08.22.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    @IBOutlet weak var labelFileName: UILabel!
    
    static let identifer = "ReminderCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with reminder: Reminder) {
        labelFileName.text = reminder.fileName
    }
    
}
