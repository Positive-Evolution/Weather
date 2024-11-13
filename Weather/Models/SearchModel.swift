import Foundation

struct SearchModel: Codable {
    
    
    
    let city: String
    let time: String
    let description: String
    let temperature: Int
    let highTemperature: Int
    let lowTemperature: Int
    var hourlyWeather: [String] = []
}
