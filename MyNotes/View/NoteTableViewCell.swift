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
    
    let backgroundColorNames = [0: "CustomBlue",
                                1: "CustomGreen",
                                2: "CustomOrange",
                                3: "CustomPurple",
                                4: "CustomSkin"]
    
    func configureCell() {
        descriptionLabel.text = note.text
        //dateLabel.text = DateFormatter().string(from: note.date)
        dateLabel.text = "April 5, 2022"
        
        noteView.layer.cornerRadius = 8.0
        noteView.layer.masksToBounds = true
        
        // Try to get custom color from assets
        
        if let colorName = backgroundColorNames[Int.random(in: 0...4)] {
            noteView.backgroundColor = UIColor(named: colorName)
        }
        
    }

}
