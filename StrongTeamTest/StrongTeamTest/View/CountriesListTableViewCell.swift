//
//  TableViewCell.swift
//  StrongTeamTest
//
//  Created by Дархан Есенкул on 13.05.2023.
//

import UIKit
import Kingfisher

protocol CountriesListTableViewCellDelegate: AnyObject {
    func learnMoreButtonTapped(forCell cell: CountriesListTableViewCell, withData data: String)
}


class CountriesListTableViewCell: UITableViewCell {
    
    static let identifier = "CountriesCell"
    
    @IBOutlet weak var flagImageView:UIImageView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryCapital: UILabel!
    @IBOutlet weak var countryPopulation: UILabel!
    @IBOutlet weak var countryArea: UILabel!
    @IBOutlet weak var countryCurrencies: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var currenciesLabel: UILabel!
    @IBOutlet weak var learnMoreButton: UIButton!
    @IBOutlet weak var chevronImage: UIImageView!
    
    weak var delegate: CountriesListTableViewCellDelegate?
    
    var countryCode = ""
    
    func configure(with country: CountryModel, isOpened: Bool, code: String){
        countryCode = code
        if let url = URL(string: country.flags.png ?? "") {
            flagImageView.kf.setImage(with: url)
        }
        if let name = country.name.common{
            countryName.text = name
        }
        if let capital = country.capital?[0]{
            countryCapital.text = capital
        }
        
        if let population = country.population{
            if population / 1000000 < 1{
                countryPopulation.text = "\(population / 1000) thousand"
            }
            else{
                countryPopulation.text = "\(population / 1000000) mln"
            }
        }
        if let area = country.area{
            let superscriptTwo = "\u{00B2}"
            if area / 1000000 < 1{
                countryArea.text = "\(area / 1000) thousand km" + superscriptTwo
            }
            else{
                countryArea.text = "\(area / 1000000) mln km" + superscriptTwo
            }
            
        }
       
        if let currencyCode = country.currencies?.keys.first,
           let currencySymbol = country.currencies?[currencyCode]?.symbol,
           let currencyName = country.currencies?[currencyCode]?.name{
              countryCurrencies.text = "\(currencyName) (\(currencySymbol)) (\(currencyCode))"
          } else {
              countryCurrencies.text = ""
          }
        if isOpened == false{
            countryPopulation.isHidden = true
            countryArea.isHidden = true
            countryCurrencies.isHidden = true
            populationLabel.isHidden = true
            areaLabel.isHidden = true
            currenciesLabel.isHidden = true
            learnMoreButton.isHidden = true
            chevronImage.image = UIImage(systemName: "chevron.down")
        }
        else{
            countryPopulation.isHidden = false
            countryArea.isHidden = false
            countryCurrencies.isHidden = false
            populationLabel.isHidden = false
            areaLabel.isHidden = false
            currenciesLabel.isHidden = false
            learnMoreButton.isHidden = false
            chevronImage.image = UIImage(systemName: "chevron.up")
        }
    
    }
    
    @IBAction func learnMoreButtonDidTap(_ sender: UIButton){
        delegate?.learnMoreButtonTapped(forCell: self, withData: countryCode)
    }
}

extension UIView{
   @IBInspectable var cornerRadius: CGFloat{
       get {return self.cornerRadius}
        set{
            self.layer.cornerRadius = newValue
        }
    }
}
