//
//  NoteTableViewCell.swift
//  MyNotes
//
//  Created by Ilya on 05.04.2022.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var note: Note! {
        didSet {
            configureCell()
        }
    }
    
    var backgroundColorIndex = 0
    
    let backgroundColorNames = [0: "CustomBlue",
                                1: "CustomGreen",
                                2: "CustomOrange",
                                3: "CustomPurple",
                                4: "CustomSkin"]
    
    func configureCell() {
        
        descriptionLabel.text = note.text
        if let lastUpdated = note.lastUpdated {
            dateLabel.text = getFormattedDate(date: lastUpdated)
        }
        
        noteView.layer.cornerRadius = 8.0
        noteView.layer.masksToBounds = true
        
        if let colorName = backgroundColorNames[backgroundColorIndex] {
            noteView.backgroundColor = UIColor(named: colorName)
        }
    }

    func getFormattedDate(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM-dd-yyyy"
        
        if dateformatter.string(from: date) == dateformatter.string(from: Date()) {
            dateformatter.dateFormat = "HH:mm"
        } else {
            dateformatter.dateFormat = "MM-dd-yyyy HH:mm"
        }
        
        return dateformatter.string(from: date)
    }

}
