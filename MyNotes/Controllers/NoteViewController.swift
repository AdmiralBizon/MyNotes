//
//  NoteViewController.swift
//  MyNotes
//
//  Created by Ilya on 06.04.2022.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var note: Note!
    weak var notesUpdateDelegate: NotesUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = note?.text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK:- Operations with notes
    
    private func updateNote() {
        note.lastUpdated = Date()
        CoreDataManager.shared.save()
        notesUpdateDelegate?.refreshNotes()
    }
    
    private func deleteNote() {
        if let noteId = note.id {
            CoreDataManager.shared.deleteNote(note)
            notesUpdateDelegate?.deleteNote(with: noteId)
        }
    }
}

// MARK:- UITextView Delegate

extension NoteViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note?.text = textView.text
        if note?.text?.isEmpty ?? true {
            deleteNote()
        } else {
            updateNote()
        }
    }
}
