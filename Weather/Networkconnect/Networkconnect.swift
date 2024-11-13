import Foundation

class Networkconnect {
    
    let apiKey = "0243d30fc76cc8453d3cd7015f2dce14"
    
    func geocodingCity(city: String, completionHandler: @escaping (([CityModel], String?) -> Void)) {
        
        let urlString = "http://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=1&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Error URl")
            completionHandler([], "Error URl")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Error Task")
                completionHandler([], error.localizedDescription)
                return
            }
        
            guard let data = data else {
                print("Error Data")
                completionHandler([], "Error Data")
                return
            }
            
            do {
                let cityData = try JSONDecoder().decode([CityModel].self, from: data)
                completionHandler(cityData, nil)
            } catch {
                print("Error JSON")
                completionHandler([], "Error JSON")
            }
        }
        
        task.resume()
    }
}
