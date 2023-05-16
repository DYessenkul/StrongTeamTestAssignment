//
//  CountryDetailsViewController.swift
//  StrongTeamTest
//
//  Created by Дархан Есенкул on 14.05.2023.
//

import UIKit
import Kingfisher


class CountryDetailsViewController: UIViewController, CountryDetailsNetworkManagerDelegate {

    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var countryName: UILabel!
    
    var networkManager = NetworkManager()
    var countryCode = ""
    var country = CountryModel(name: Name(common: nil),cca2: nil,currencies: nil, capital: nil,region: nil, latlng: nil,area: nil, maps: StreetMaps(openStreetMaps: nil), population: nil, timezones: nil,continents: nil, capitalInfo: nil,flags: ImageType(png: nil))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        networkManager.countryDetailsDelegate = self
        networkManager.getCountryDetails(cca2: countryCode)
       
    }
    
    func didUpdateCountryDetails(with country: CountryModel) {
        self.country = country
        if let urlString = country.flags.png, let url = URL(string: urlString) {
            countryFlag.kf.setImage(with: url)
        }
        countryName.text = country.name.common
        DispatchQueue.main.async {
            self.detailsTableView.reloadData()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton){
        dismiss(animated: true)
    }
}

//MARK: CountryDetailsTableView

extension CountryDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: CountryDetailsTableViewCell.identifier, for: indexPath) as! CountryDetailsTableViewCell
        if indexPath.section == 0{
            if let subregion = country.region{
                cell.configure(title: "Region:", data: "\(subregion)")}
        }
        else if indexPath.section == 1{
            if let capital = country.capital{
                cell.configure(title: "Capital:", data: "\(capital[0])")
            }
        }
        else if indexPath.section == 2{
            if let capitalCoordinates = country.capitalInfo?.latlng{
                cell.configure(title: "Capital coordinates:", data: "\(capitalCoordinates[0])', \(capitalCoordinates[1])'")
            }
        }
        else if indexPath.section == 3{
            if let population = country.population{
                if population / 1000000 < 1{
                    cell.configure(title: "Population:", data: "\(population / 1000) thousand")
                }
                else{
                    cell.configure(title: "Population:", data: "\(population / 1000000) mln")
                }
            }
        }
        else if indexPath.section == 4{
            if let area = country.area{
                let superscriptTwo = "\u{00B2}"
                cell.configure(title: "Area:", data: "\(area) km"+superscriptTwo)
            }
            
        } else if indexPath.section == 5{
            if let currency = country.currencies{
                var currencies = ""
                for currencyCode in currency.keys{
                    if let currencySymbol = country.currencies?[currencyCode]?.symbol,
                       let currencyName = country.currencies?[currencyCode]?.name{
                        currencies+="\(currencyName) (\(currencySymbol)) (\(currencyCode))"
                        currencies+="\n"
                    }
                }
                cell.configure(title: "Currency", data: currencies)
            }
        }
        else if indexPath.section == 6{
            if let timezones = country.timezones{
                var time = ""
                for timezone in timezones{
                    time+=timezone
                    time+="\n"
                }
                cell.configure(title: "Timezones:", data: time)
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
              if let openStreetMapsURL = country.maps.openStreetMaps,
                 let url = URL(string: openStreetMapsURL) {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
              }
          }
          tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
