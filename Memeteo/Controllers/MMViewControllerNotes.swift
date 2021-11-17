//
//  MMTableViewControllerNextDay.swift
//  Memeteo
//
//  Created by ingouackaz on 16/11/2021.
//

import UIKit
import MemeteoClient


class MMViewControllerNotes: UIViewController {

    
    var notes: [Note] = []
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadData()
        initUI()
    }
    
    
    func initUI(){
        
    }
    
    func loadData(){
        
        
        self.notes = MemeteoClient.shared.notes ?? []
        

        self.tableView.reloadData()
    }
    
    

}


extension MMViewControllerNotes : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: MMTableViewCellNote.identifier, for: indexPath) as? MMTableViewCellNote {
            let note : Note = notes[indexPath.item]
            
            cell.configure(note: note)
            
          //  cell.labelName.text = city.name

            return cell
        }
        
        return UITableViewCell()
    }
}
