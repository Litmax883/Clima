//
//  Network.swift
//  Clima
//
//  Created by MAC on 01.11.2020.
//  Copyright © 2020 Litmax. All rights reserved.
//

import Foundation

struct Network {

    let urlWeather = "https://api.openweathermap.org/data/2.5/weather?appid=8036710296d91453aaa3a990480c76d6&units=metric"
    var delegate: UpdateWeatherProtocol?
    
    func fetchWeather(city: String) {
        let urlString = "\(urlWeather)&q=\(city)"
        
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                delegate?.didFaleWithError(error: error!)
                return
            }
            
            if let data = data {
                if let weather = self.parseJSON(data) {
                    delegate?.didUpdateWeather(self, weather: weather)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let id = decodedData.weather.first!.id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFaleWithError(error: error)
            return nil
        }
    }
    

    
}
