//
//  MMTableViewCellNote.swift
//  Memeteo
//
//  Created by ingouackaz on 16/11/2021.
//

import UIKit

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

}
