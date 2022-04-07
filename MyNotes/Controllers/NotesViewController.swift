//
//  NotesViewController.swift
//  MyNotes
//
//  Created by Ilya on 05.04.2022.
//

import UIKit

protocol NotesUpdateDelegate: AnyObject {
    func refreshNotes()
    func deleteNote()
}

class NotesViewController: UITableViewController {
    
    var notes = [Note]()
    var selectedNoteIndex = 0
    
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        fetchNotes()
    }
    
    @IBAction func createNotePressed(_ sender: UIBarButtonItem) {
        selectedNoteIndex = 0
        goToEditNote(createNote())
    }
    
    // MARK: - Data manipulation methods
    
    private func fetchNotes() {
        notes = CoreDataManager.shared.fetchNotes()
    }
    
    private func searchNotes(by text: String) {
        notes = CoreDataManager.shared.searchNotes(by: text)
        tableView.reloadData()
    }
    
    private func createNote() -> Note {
        let note = CoreDataManager.shared.createNote()

        // Update table
        notes.insert(note, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        return note
    }
    
    private func goToEditNote(_ note: Note) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        controller.note = note
        controller.notesUpdateDelegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func deleteNoteFromStorage(_ note: Note) {
        CoreDataManager.shared.deleteNote(note)
        
        // Update table
        deleteNote()
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        selectedNoteIndex = indexPath.row
        if editingStyle == .delete {
            deleteNoteFromStorage(notes[selectedNoteIndex])
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNoteIndex = indexPath.row
        goToEditNote(notes[selectedNoteIndex])
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // animation
        
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}

// MARK: - UISearchControllerDelegate, UISearchBarDeledate

extension NotesViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    private func configureSearchBar() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count != 0 {
            searchNotes(by: searchBar.text!)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count != 0 {
            refreshNotes()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            refreshNotes()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

// MARK: - NotesUpdateDelegate

extension NotesViewController: NotesUpdateDelegate {
    func refreshNotes() {
        fetchNotes()
        tableView.reloadData()
    }
    
    func deleteNote() {
        notes.remove(at: selectedNoteIndex)
        tableView.deleteRows(at: [IndexPath(row: selectedNoteIndex, section: 0)], with: .automatic)
    }
    
}
