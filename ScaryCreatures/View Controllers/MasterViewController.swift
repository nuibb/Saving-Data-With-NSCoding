//
//  AppDelegate.swift
//  ScaryCreatures
//
//  Created by Steve JobsOne on 4/30/19.
//  Copyright © 2019 MobioApp Limited. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
  var creatures: [ScaryCreatureDoc] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = editButtonItem
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped(_:)))
    navigationItem.rightBarButtonItem = addButton
    
    title = "Scary Creatures"
    
    //Loading creatures from in memory
    //loadCreatures()
    
    //Loading creatures from database
    creatures = ScaryCreatureDatabase.loadScaryCreatureDocs()
  }
  
  // MARK: - Segues
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let object = creatures[indexPath.row]
        let controller = segue.destination as! DetailViewController
        controller.detailItem = object
      }
    }
  }
  
  override func didMove(toParent parent: UIViewController?) {
    tableView.reloadData()
  }
  
  // MARK: - Preloading Data
  
  func loadCreatures() {
    let creature1 = ScaryCreatureDoc(title: "Ghost", rating: 5, thumbImage: #imageLiteral(resourceName: "ghostThumb"), fullImage: #imageLiteral(resourceName: "ghost"))
    let creature2 = ScaryCreatureDoc(title: "Monster", rating: 5, thumbImage: #imageLiteral(resourceName: "monsterThumb"), fullImage: #imageLiteral(resourceName: "monster"))
    let creature3 = ScaryCreatureDoc(title: "Panda", rating: 1, thumbImage: #imageLiteral(resourceName: "pandaThumb"), fullImage: #imageLiteral(resourceName: "panda"))
    let creature4 = ScaryCreatureDoc(title: "Red Bug", rating: 3, thumbImage: #imageLiteral(resourceName: "redBugThumb"), fullImage: #imageLiteral(resourceName: "redBug"))
    let creature5 = ScaryCreatureDoc(title: "Slug", rating: 4, thumbImage: #imageLiteral(resourceName: "slugThumb"), fullImage: #imageLiteral(resourceName: "slug"))
    let creature6 = ScaryCreatureDoc(title: "Spider", rating: 3, thumbImage: #imageLiteral(resourceName: "spiderThumb"), fullImage: #imageLiteral(resourceName: "spider"))
    let creature7 = ScaryCreatureDoc(title: "Yeti", rating: 3, thumbImage: #imageLiteral(resourceName: "yetiThumb"), fullImage: #imageLiteral(resourceName: "yeti"))

    creatures = [creature1, creature2, creature3, creature4, creature5, creature6, creature7]
  }
  
  // MARK: - Table View
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return creatures.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MyBasicCell", for: indexPath)
    
    let creature = creatures[indexPath.row]
    cell.textLabel!.text = creature.data?.title
    cell.imageView!.image = creature.thumbImage
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        let creatureToDelete = creatures.remove(at: indexPath.row)
        print(creatureToDelete)
        creatureToDelete.deleteDoc()
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
  
  // MARK: IBActions
  
  @objc func addTapped(_ sender: Any) {
    let newDoc = ScaryCreatureDoc(title: "New Creature", rating: 0, thumbImage: nil, fullImage: nil)
    creatures.append(newDoc)
    
    let newIndexPath = IndexPath(row: creatures.count-1, section: 0)
    tableView.insertRows(at: [newIndexPath], with: .automatic)
    tableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .middle)
    performSegue(withIdentifier: "showDetail", sender: self)
  }
}

