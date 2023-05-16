//
//  ViewController.swift
//  StrongTeamTest
//
//  Created by Дархан Есенкул on 13.05.2023.
//

import UIKit

class CountriesListViewController: UIViewController, CountriesListNetworkManagerDelegate {
  
    @IBOutlet weak var tableView: UITableView!
    
    var countriesFromNetwork = [CountryModel]()
    
    var networkManager = NetworkManager()
    
    var europeCountries = [ExpandingCountryModel]()
    var asiaCountries = [ExpandingCountryModel]()
    var africaCountries = [ExpandingCountryModel]()
    var southAmericaCountries = [ExpandingCountryModel]()
    var northAmericaCountries = [ExpandingCountryModel]()
    var oceaniaCountries = [ExpandingCountryModel]()
    
    var allCountries = [ExpandingCountryModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "World countries"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 240
        tableView.rowHeight = UITableView.automaticDimension
        networkManager.countriesDelegate = self
        networkManager.getCountries()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "details" {
               if let destinationVC = segue.destination as? CountryDetailsViewController {
                   if let data = sender as? String{
                       destinationVC.countryCode = data
                   }
               }
           }
       }
    
    func learnMoreButtonTapped(forCell cell: CountriesListTableViewCell, withData data: String) {
            performSegue(withIdentifier: "details", sender: data)
        
        }
    
    func didUpdateCountries(with countries: [CountryModel]) {
        self.countriesFromNetwork = countries
        for country in countriesFromNetwork{
            if country.continents?[0] == "Asia"{
                asiaCountries.append(ExpandingCountryModel(country: country, isOpened: false))
            }
            else if country.continents?[0] == "Europe"{
                europeCountries.append(ExpandingCountryModel(country: country, isOpened: false))
            }
            else if country.continents?[0] == "North America"{
                northAmericaCountries.append(ExpandingCountryModel(country: country, isOpened: false))
            }
            else if country.continents?[0] == "South America"{
                southAmericaCountries.append(ExpandingCountryModel(country: country, isOpened: false))
            }
            else if country.continents?[0] == "Africa"{
                africaCountries.append(ExpandingCountryModel(country: country, isOpened: false))
            }
            else if country.continents?[0] == "Oceania"{
                oceaniaCountries.append(ExpandingCountryModel(country: country, isOpened: false))
            }
        }
        allCountries = asiaCountries + europeCountries + northAmericaCountries + southAmericaCountries + africaCountries + oceaniaCountries
        DispatchQueue.main.async {
             self.tableView.reloadData()
         }
    }
    
}


//MARK: CountriesListTableView

extension CountriesListViewController: UITableViewDelegate, UITableViewDataSource, CountriesListTableViewCellDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allCountries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountriesListTableViewCell.identifier, for: indexPath) as! CountriesListTableViewCell
        cell.delegate = self
        cell.configure(with: allCountries[indexPath.section].country, isOpened: allCountries[indexPath.section].isOpened, code: allCountries[indexPath.section].country.cca2 ?? "KZ")
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{return "ASIA"}
        else if section == asiaCountries.count{return "EUROPE"}
        else if section == asiaCountries.count + europeCountries.count {return "NORTH AMERICA"}
        else if section == asiaCountries.count + europeCountries.count + northAmericaCountries.count{return "SOUTH AMERICA"}
        else if section == asiaCountries.count + africaCountries.count + northAmericaCountries.count + southAmericaCountries.count{return "AFRICA"}
        else if section == asiaCountries.count+africaCountries.count+southAmericaCountries.count+europeCountries.count +  northAmericaCountries.count{return "OCEANIA"}
        return ""
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if allCountries[indexPath.section].isOpened == true{
            return 240
        }
        else{
            return 70
        }
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear

            let titleLabel = UILabel()
            titleLabel.frame = CGRect(x: 15, y: 0, width: tableView.bounds.width, height: 15)
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
            headerView.addSubview(titleLabel)
            return headerView
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          if section == 0 || section == asiaCountries.count
                || section == asiaCountries.count + europeCountries.count
                || section == asiaCountries.count + europeCountries.count + northAmericaCountries.count
                || section == asiaCountries.count + africaCountries.count + northAmericaCountries.count + southAmericaCountries.count
                || section == asiaCountries.count+africaCountries.count + southAmericaCountries.count + europeCountries.count + northAmericaCountries.count{
              return 20
          } else {
              return 0
          }
      }
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allCountries[indexPath.section].isOpened == false{
            allCountries[indexPath.section].isOpened = true
        }
        else{
            allCountries[indexPath.section].isOpened = false
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



