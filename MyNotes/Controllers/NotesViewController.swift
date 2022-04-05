//
//  NotesViewController.swift
//  MyNotes
//
//  Created by Ilya on 05.04.2022.
//

import UIKit

class NotesViewController: UITableViewController {
    
    var notes = [
        Note(text: "The Psylogy Principles Every UI/UX Designer Needs To Know", date: Date.now),
        Note(text: "13 Things You Should Give Up If You Want To Be a Succesful UX Designer", date: Date.now),
        Note(text: "10 UI & UX Lessons from Designing My Own Product", date: Date.now),
        Note(text: "52 Research Terms you need to know as a UX Designer", date: Date.now)
    ]
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        
        cell.note = notes[indexPath.row]
        
        return cell
    }
    
}
