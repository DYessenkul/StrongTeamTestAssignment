//
//  CountryDetailsTableViewCell.swift
//  StrongTeamTest
//
//  Created by Дархан Есенкул on 14.05.2023.
//

import UIKit

class CountryDetailsTableViewCell: UITableViewCell {
    
    static let identifier = "DetailsCell"
    
    @IBOutlet weak var titleOfData: UILabel!
    @IBOutlet weak var dataValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(title: String, data: String){
        titleOfData.text = "\(title)"
        dataValue.text = "\(data)"
    }
    
    
    
}
