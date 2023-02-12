//
//  GameTableViewController.swift
//  PlaytoPlay
//
//  Created by Humberto Rodrigues on 16/12/22.
//

import UIKit
import CoreData

class GameTableViewController: UITableViewController {
    
    var fetchedViewController: NSFetchedResultsController<Game>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGames()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameViewSegue" {
            let vc = segue.destination as! GameViewController
            vc.game = fetchedViewController.fetchedObjects![tableView.indexPathForSelectedRow!.row]
        }
    }
    
    func loadGames() {
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedViewController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedViewController.delegate = self
        
        do {
            try fetchedViewController.performFetch()
        } catch {
            print (error)
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedViewController.fetchedObjects!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameInfoTableViewCell
        
        let game = fetchedViewController.fetchedObjects![indexPath.row]
        
        cell.prepare(game: game)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let game = fetchedViewController.fetchedObjects?[indexPath.row] else {return}
            context.delete(game)
            
            do{
                try context.save()
            } catch {
                print (error)
            }
        }
    }
    
}

extension GameTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        default:
            tableView.reloadData()
        }
    }
}
