//
//  MMTableViewCellNote.swift
//  Memeteo
//
//  Created by ingouackaz on 16/11/2021.
//

import UIKit
import MemeteoClient

class MMTableViewCellNote: UITableViewCell {

    
    static let identifier : String = "cell.note"

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(note:Note){
        
        let date = note.dt
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "E, d MMM y"

        // Convert Date to String
        let dateStr =  dateFormatter.string(from: date)
        
        
        
        self.labelText.text = note.text
        self.labelTitle.text =  dateStr + " | " + note.city.name
        
    }

}
