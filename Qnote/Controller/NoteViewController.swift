//
//  NoteViewController.swift
//  Qnote
//
//  Created by Jose Antonio on 15/10/23.
//

import UIKit
import RealmSwift

class NoteViewController: UIViewController {
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var titleTextView: UITextField!
    let realm = try! Realm()
    
    var note: Note?

   

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTextField()
    }
    
    private func reloadTextField(){
        noteTextView.text = note?.text ?? ""
        titleTextView.text = note?.title ?? ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        do{
            try realm.write{
                note?.text = noteTextView.text ?? ""
                note?.title = titleTextView.text ?? ""
            }
        }catch{
            print("Error al save los datos: \(error)")
        }
    }

}
