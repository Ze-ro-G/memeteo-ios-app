//
//  MMTableViewCellWeatherHourly.swift
//  Memeteo
//
//  Created by ingouackaz on 05/11/2021.
//

import UIKit

class MMTableViewCellWeatherHourly: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        collectionView.delegate = self
      //  collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(){
        
        collectionView.reloadData()
    }
}


extension MMTableViewCellWeatherHourly : UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MMCollectionViewCellWeatherDay.identifier, for: indexPath)
        return cell
    }
    
}


extension MMTableViewCellWeatherHourly : UICollectionViewDelegate{
    
    
}
