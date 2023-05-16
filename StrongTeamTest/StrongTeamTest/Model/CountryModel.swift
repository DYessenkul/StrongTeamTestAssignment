//
//  CountryModel.swift
//  StrongTeamTest
//
//  Created by Дархан Есенкул on 13.05.2023.
//

import Foundation

struct ExpandingCountryModel{
    let country: CountryModel
    var isOpened: Bool
}

struct CountryModel: Decodable{
    let name: Name
    let cca2: String?
    let currencies: [String: Currency]?
    let capital: [String]?
    let region: String?
    let latlng: [Double]?
    let area: Double?
    let maps: StreetMaps
    let population: Int?
    let timezones: [String]?
    let continents: [String]?
    let capitalInfo: Latlng?
    let flags: ImageType
}



struct Name: Decodable{
    let common: String?
}

struct Currency: Decodable{
    let name: String?
    let symbol: String?
}

struct Latlng: Decodable{
    let latlng: [Double]?
}

struct StreetMaps: Decodable{
    let openStreetMaps: String?
}

struct ImageType: Decodable{
    let png: String?
}
