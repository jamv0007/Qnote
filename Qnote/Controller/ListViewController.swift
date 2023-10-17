//
//  ViewController.swift
//  Qnote
//
//  Created by Jose Antonio on 15/10/23.
//

import UIKit
import RealmSwift

class ListViewController: UITableViewController {
    
    var notes: Results<Note>?
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Se registra el nib de la celda para usarla en la table view
        tableView.register(UINib(nibName: Constants.noteCell, bundle: nil), forCellReuseIdentifier: Constants.noteCellId)
        
        //Se cargan los datos
        loadData()
    }
    
    
    // MARK: - Añadir nuevo elemento
    //Añade nueva nota vacia
    @IBAction func addNote(_ sender: UIBarButtonItem) {
        let note: Note = Note()
        note.title = "Nueva nota"
        note.text = ""
        self.saveData(note: note)
        tableView.reloadData()
    }
    
    //MARK: - Funciones Table view
    //Celda a motrar
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.noteCellId, for: indexPath) as! NoteCellView
        
        cell.textLabelShow.text = notes?[indexPath.row].text ?? "No hay notas añadidas"
        cell.textLabelShow.regulateTextTam(size: 30)
        cell.titleLabel.text = notes?[indexPath.row].title ?? "No hay notas añadidas"
        cell.titleLabel.regulateTextTam(size: 30)
        return cell
    }
    
    //Al interactuar con la celda
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.fromNotesToEdit, sender: self)
    }
    
    //Numero de celdas de la table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 1
    }
    
    //Modificacion del estilo para borrar
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let delete = notes?[indexPath.row]{
                do{
                    try realm.write{
                        realm.delete(delete)
                    }
                }catch{
                    print("Error al eliminar Realm: \(error)")
                }
                
                tableView.reloadData()
            }
        }
    }
    
    //Se modifican los datos
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        tableView.reloadData()
    }
    
    
    
    //MARK: - Funcion envio de datos por el segue
    //Prepara para enviar los datos a la siguiente vista
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.fromNotesToEdit {
            if let dest = segue.destination as? NoteViewController{
                if let ind = tableView.indexPathForSelectedRow {
                    dest.note = notes?[ind.row]
                }
            }
        }
    }
    
    //MARK: - Funciones carga y obtencion de datos
    func loadData(){
        notes = realm.objects(Note.self)
        tableView.reloadData()
    }
    
    func saveData(note: Note){
        do{
            try realm.write(){
                realm.add(note)
            }
            
            tableView.reloadData()
            
        }catch{
            print("Error al guardar los datos: \(error)")
        }
    }
    
}


//MARK: - Extension para busqueda

extension ListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        notes = notes?.filter("(title CONTAINS[cd] %@) OR (text CONTAINS[cd] %@)", searchBar.text!,searchBar.text!)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}

//MARK: - Extensiones para funcionamiento del mostrado de texto
extension String{
    
    func getFirstSubstring(size: Int) -> String{
        var cade = ""
        var cont = 0
        for charac in self{
            if cont >= size {
                break
            }
            
            cade.append(charac)
            cont += 1
        }
        
        return cade
    }
}

extension UILabel{
    func regulateTextTam(size: Int){
        if(size > 3){
            if self.text?.count ?? 0 > size {
                let newText = (self.text?.getFirstSubstring(size:size-3))
                self.text? = "\(newText!)..."
            }
        }
    }
}
