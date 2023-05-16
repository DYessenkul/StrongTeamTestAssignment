//
//  NetworkManager.swift
//  StrongTeamTest
//
//  Created by Дархан Есенкул on 13.05.2023.
//

import Foundation
import Alamofire


protocol CountriesListNetworkManagerDelegate{
    func didUpdateCountries(with countries: [CountryModel])
}

protocol CountryDetailsNetworkManagerDelegate{
    func didUpdateCountryDetails(with country: CountryModel)
}


class NetworkManager{
    var countriesDelegate: CountriesListNetworkManagerDelegate?
    var countryDetailsDelegate: CountryDetailsNetworkManagerDelegate?
    
    func getCountries(){
        let urlString = "https://restcountries.com/v3.1/all"
        guard let url = URL(string:urlString) else {
            print("Invalid URL")
            return
        }
        AF.request(url).responseDecodable(of: [CountryModel].self) { response in
            switch response.result{
            case.success(let countries):
                self.countriesDelegate?.didUpdateCountries(with: countries)
            case.failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    func getCountryDetails(cca2: String) {
        guard let encodedCCA2 = cca2.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            print("Failed to encode cca2")
            return
        }
        
        guard let url = URL(string: "https://restcountries.com/v3.1/alpha/\(encodedCCA2)") else {
            print("Invalid URL")
            return
        }
        
        let request = AF.request(url)
        request.validate().responseDecodable(of: [CountryModel].self) { response in
            switch response.result {
            case .success(let country):
                self.countryDetailsDelegate?.didUpdateCountryDetails(with: country[0])
            case .failure(let error):
                print("Request failed with error: \(error.localizedDescription)")
            }
        }
    }

    
}
