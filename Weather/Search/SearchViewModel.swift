import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func dataLoaded()
}

class SearchViewModel {
    
    private var filter = ""  // Фильтр для поиска
    
    weak var delegate: SearchViewModelDelegate?
    private var networkconnect: Networkconnect!
    
    private var infoData: [SearchModel] = [  // Статическая тестовая модель данных
        SearchModel(city: "London", time: "9:41", description: "Rain", temperature: 18, highTemperature: 21, lowTemperature: 10),
        SearchModel(city: "New York", time: "4:41", description: "Cloudy", temperature: 22, highTemperature: 25, lowTemperature: 18),
        SearchModel(city: "Toronto", time: "5:41", description: "Snow", temperature: 3, highTemperature: 28, lowTemperature: 17),
        SearchModel(city: "Paris", time: "10:41", description: "Clear", temperature: 28, highTemperature: 29, lowTemperature: 15),
        SearchModel(city: "Sydney", time: "22:41", description: "Fog", temperature: 7, highTemperature: 14, lowTemperature: 3)
    ]
    
    private var filteredData: [SearchModel] = []  // Отфильтрованные данные
    
    init(networkconnect: Networkconnect) {
        self.networkconnect = networkconnect
    }
    
    func didLoad() {
        getSearchData()
        delegate?.dataLoaded()
    }
    
    func searchedData(data: String) {
        filter = data.lowercased()
        if filter.isEmpty {
            filteredData = []
        } else {
            filteredData = infoData.filter {
                $0.city.lowercased().contains(filter) || $0.description.lowercased().contains(filter)
            }
        }
        delegate?.dataLoaded()
    }
    
    func answerFromSearchData(cityModels: CityModel) {
        saveSearchData(data: filteredData)
        delegate?.dataLoaded()
        getSearchDataBundle()
    }
    
    func getInfoData() -> [SearchModel] {
        return filter.isEmpty ? infoData : filteredData
    }
    
    func codingDataJSON() -> Data? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(filteredData)
            print("Data encoded to JSON")
            return data
        } catch {
            print("Error encoding data: \(error)")
            return nil
        }
    }
    
    func decodingDataJSON(data: Data?) -> [SearchModel]? {
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode([SearchModel].self, from: data)
            return data
        } catch {
            print("Error decoding data: \(error)")
            return nil
        }
    }
    
    func saveSearchData(data: [SearchModel]) {
        let userDefaults = UserDefaults.standard
        guard let encodedData = codingDataJSON() else { return }
        userDefaults.set(encodedData, forKey: "searchData")
    }
    
    func getSearchData() {
        let userDefaults = UserDefaults.standard
        let userData = userDefaults.data(forKey: "searchData")
        if let userDecodedData = decodingDataJSON(data: userData) {
            filteredData = userDecodedData
        }
    }
    
    func getSearchDataBundle() {
        guard let url = Bundle.main.url(forResource: "JSON_test_resp", withExtension: "") else {
            print("Error reading file")
            return
        }
        var dataFromFile: Data?
        do {
            dataFromFile = try Data(contentsOf: url)
        } catch {
            print("Error decoding data: \(error)")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let dataResponse = try decoder.decode([CityModel].self, from: dataFromFile!)
            print(dataResponse)
        } catch {
            print("Error decoding JSON: \(error)")
            return
        }
    }
    
    func getCurrentCity() {
        guard let url = Bundle.main.url(forResource: "JSON_Current", withExtension: "") else {
            print("Error reading file")
            return
        }
        var FromFile: Data?
        do {
            FromFile = try Data(contentsOf: url)
        } catch {
            print("Error decoding data: \(error)")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let dataResponse = try decoder.decode(CurrentModel.self, from: FromFile!)
            print(dataResponse)
        } catch {
            print("Error decoding data: \(error)")
            return
        }
    }
}
