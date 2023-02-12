//
//  ConsoleTableViewController.swift
//  PlaytoPlay
//
//  Created by Humberto Rodrigues on 16/12/22.
//

import UIKit
import CoreData

class ConsoleTableViewController: UITableViewController {
    
    var consoles: [Console] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConsoles()
    }
    
    func loadConsoles () {
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        
        do {
           consoles = try context.fetch(fetchRequest)
        } catch {
            print (error)
        }
        
       tableView.reloadData()
    }
    
    func deleteConsole(index: Int, context: NSManagedObjectContext) {
        let console = consoles[index]
        context.delete(console)
        consoles.remove(at: index)
        tableView.reloadData()
    }
    
    @IBAction func AddConsole(_ sender: UIBarButtonItem) {
        showAlert(console: nil)
    }
    
    func showAlert (console: Console?) {
        let title = console == nil ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: title + "uma Plataforma", message: nil, preferredStyle: .alert)
        alert.addTextField() { (textfield) in
            if let name = console?.name {
                textfield.text = name
            }
        }
        
        alert.addTextField() { (textfield2) in
            if let version = console?.version {
                textfield2.text = version
            }
        }
        
        alert.addAction(UIAlertAction(title: "Adicionar", style: .default, handler: { (action) in
            let console = console ?? Console(context: self.context)
            console.name = alert.textFields?.first?.text
            console.version = alert.textFields?.last?.text
            
            do{
                try self.context.save()
                self.loadConsoles()
                
            } catch {
                print(error)
            }
        }))
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(consoles.count)
        return consoles.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let console = consoles[indexPath.row]
        
        cell.textLabel?.text = console.name
        cell.detailTextLabel?.text = console.version
        
        return cell
    }
}
