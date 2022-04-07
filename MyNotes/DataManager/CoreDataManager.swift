//
//  CoreDataManager.swift
//  MyNotes
//
//  Created by Ilya on 06.04.2022.
//

import Foundation
import CoreData

class CoreDataManager {
   
    static let shared = CoreDataManager(modelName: "Notes")
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {fatalError(error!.localizedDescription)}
            completion?()
        }
    }
    
    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print ("An error ocurred while saving data: \(error.localizedDescription)")
            }
        }
    }
}

extension CoreDataManager {
    
    func fetchNotes(predicate: NSPredicate? = nil) -> [Note] {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        
        if let searchPredicate = predicate {
            request.predicate = searchPredicate
        }
        
        let sortDescriptor = NSSortDescriptor(keyPath: \Note.lastUpdated,
                                              ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print ("An error ocurred while fetching data: \(error.localizedDescription)")
            return []
        }
        
    }
    
    func createNote() -> Note {
        let note = Note(context: viewContext)
        note.id = UUID()
        note.text = ""
        note.lastUpdated = Date()
        save()
        return note
    }
    
    func deleteNote(_ note: Note) {
        viewContext.delete(note)
        save()
    }
    
    func searchNotes(by text: String) -> [Note] {
        let searchPredicate = NSPredicate(format: "text contains[cd] %@", text)
        return fetchNotes(predicate: searchPredicate)
    }
    
}
