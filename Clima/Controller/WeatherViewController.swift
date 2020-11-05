//
//  ViewController.swift
//  Clima
//
//  Created by MAC on 01.11.2020.
//  Copyright © 2020 Litmax. All rights reserved.
//

import UIKit

protocol UpdateWeatherProtocol {
    func didUpdateWeather(_ network: Network, weather: WeatherModel)
    func didFaleWithError(error: Error)
}

class WeatherViewController: UIViewController {

    var network = Network()
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network.delegate = self
        weatherTextField.delegate = self
    }
}

extension WeatherViewController: UpdateWeatherProtocol {
    
    func didUpdateWeather(_ network: Network, weather: WeatherModel) {

        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage.init(systemName: weather.conditionName)
        }
    }
    
    func didFaleWithError(error: Error) {
        print(error.localizedDescription)
    }
}

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        textFieldConfig()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldConfig()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.weatherTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            weatherTextField.placeholder = "Write something"
            return false
        }
    }
    
    func textFieldConfig () {
        network.fetchWeather(city: weatherTextField.text!)
        self.weatherTextField.endEditing(true)
    }
}

