//
//  MMTableViewCellCity.swift
//  Memeteo
//
//  Created by ingouackaz on 12/11/2021.
//

import UIKit

class MMTableViewCellCity: UITableViewCell {

    static let identifier : String = "cell.city"

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTemp: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
