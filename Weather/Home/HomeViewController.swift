import UIKit
import AVFoundation

class HomeViewController: UIViewController, SearchViewControllerDelegate {

    // MARK: - UI Elements

    private var player = AVPlayer()
    private var playerLayer: AVPlayerLayer?

    private lazy var weatherView: HomeWeatherView = {
        let weatherView = HomeWeatherView()
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        return weatherView
    }()

    private lazy var hourlyForecastView: HourlyForecastView = {
        let forecastView = HourlyForecastView()
        forecastView.translatesAutoresizingMaskIntoConstraints = false
        return forecastView
    }()
    
    private lazy var dailyForecastTableView: DailyForecastTableView = {
        let tableView = DailyForecastTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var mapButton: UIButton = {
        let btn = UIButton(type: .custom)
        let symbolImage = UIImage(systemName: "map")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 28))
        btn.setImage(symbolImage, for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(mapAction), for: .touchUpInside)
        return btn
    }()

    private lazy var searchButton: UIButton = {
        let btn = UIButton(type: .custom)
        let symbolImage = UIImage(systemName: "list.bullet")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 28))
        btn.setImage(symbolImage, for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        return btn
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
        configureVideoBackground()
        loadSavedCity()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.addSubview(weatherView)
        view.addSubview(hourlyForecastView)
        view.addSubview(dailyForecastTableView)
        view.addSubview(mapButton)
        view.addSubview(searchButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            weatherView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hourlyForecastView.topAnchor.constraint(equalTo: weatherView.bottomAnchor, constant: 260),
            hourlyForecastView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            hourlyForecastView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            hourlyForecastView.heightAnchor.constraint(equalToConstant: 100), // Высота для предсказания
            
            dailyForecastTableView.topAnchor.constraint(equalTo: hourlyForecastView.bottomAnchor, constant: 20),
            dailyForecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dailyForecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dailyForecastTableView.heightAnchor.constraint(equalToConstant: 250), // Высота таблицы
            
            mapButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            mapButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configureVideoBackground() {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = view.bounds
        view.layer.insertSublayer(playerLayer, at: 0)
        self.playerLayer = playerLayer
    }

    private func playVideo(named videoName: String) {
        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
            print("Видео \(videoName) не найдено")
            return
        }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()

        // Перезапуск видео при завершении
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
    }

    @objc private func videoDidEnd() {
        player.seek(to: .zero)
        player.play()
    }

    // MARK: - Actions

    @objc private func mapAction() {
        let mapVC = MapViewController()
        present(mapVC, animated: true)
    }

    @objc private func searchAction() {
        let networkConnection = Networkconnect()
        let viewModel = SearchViewModel(networkconnect: networkConnection)
        let searchVC = SearchViewController(viewModel: viewModel)
        searchVC.delegate = self
        navigationController?.pushViewController(searchVC, animated: true)
    }

    // MARK: - SearchViewControllerDelegate

    func citySelectedByUser(model: SearchModel) {
        // Обновляем данные в weatherView
        weatherView.setupData(model: model)

        // Сохраняем город
        saveCity(model: model)

        // Обновляем видеофон в зависимости от погоды
        let videoName: String
        switch model.description.lowercased() {
        case "rain":
            videoName = "rain"
        case "cloudy":
            videoName = "cloudy"
        case "clear":
            videoName = "clear"
        case "snow":
            videoName = "snow"
        default:
            videoName = "default"
        }
        playVideo(named: videoName)

        // Обновляем данные в hourlyForecastView
        let hourlyData = [
            (time: "08:00", temp: 18, icon: UIImage(systemName: "sun.max.fill")),
            (time: "09:00", temp: 20, icon: UIImage(systemName: "cloud.sun.fill")),
            (time: "10:00", temp: 18, icon: UIImage(systemName: "cloud.sun.bolt.fill")),
            (time: "11:00", temp: 20, icon: UIImage(systemName: "cloud.bolt.fill")),
            (time: "12:00", temp: 22, icon: UIImage(systemName: "snowflake")),
            (time: "13:00", temp: 22, icon: UIImage(systemName: "wind.snow"))
        ]
        hourlyForecastView.configure(with: hourlyData)
        
        let dailyData = [
            (day: "Today", icon: UIImage(systemName: "cloud.rain.fill"), tempRange: "1° - 5°", progress: Float(0.7), precipitation: "70%"),
            (day: "Sun", icon: UIImage(systemName: "cloud.fill"), tempRange: "-1° - 5°", progress: Float(0.6), precipitation: nil),
            (day: "Mon", icon: UIImage(systemName: "cloud.rain.fill"), tempRange: "1° - 7°", progress: Float(0.8), precipitation: "40%"),
            (day: "Tue", icon: UIImage(systemName: "cloud.rain.fill"), tempRange: "3° - 8°", progress: Float(1.0), precipitation: "70%"),
            (day: "Wed", icon: UIImage(systemName: "cloud.fill"), tempRange: "2° - 8°", progress: Float(0.9), precipitation: "60%"),
            (day: "Thu", icon: UIImage(systemName: "sun.max.fill"), tempRange: "-1° - 4°", progress: Float(0.5), precipitation: nil)
        ]
        dailyForecastTableView.configure(with: dailyData)
    }

    // MARK: - Save and Load City

    private func saveCity(model: SearchModel) {
        let defaults = UserDefaults.standard
        defaults.set(model.city, forKey: "savedCity")
        defaults.set(model.description, forKey: "savedDescription")
        defaults.set(model.temperature, forKey: "savedTemperature")
        defaults.set(model.highTemperature, forKey: "savedHighTemperature")
        defaults.set(model.lowTemperature, forKey: "savedLowTemperature")
    }

    private func loadSavedCity() {
        let defaults = UserDefaults.standard
        guard let city = defaults.string(forKey: "savedCity"),
              let description = defaults.string(forKey: "savedDescription") else {
            return
        }

        let temperature = defaults.integer(forKey: "savedTemperature")
        let highTemperature = defaults.integer(forKey: "savedHighTemperature")
        let lowTemperature = defaults.integer(forKey: "savedLowTemperature")

        let savedModel = SearchModel(
            city: city,
            time: "N/A", // Здесь можно загрузить сохранённое время, если нужно
            description: description,
            temperature: temperature,
            highTemperature: highTemperature,
            lowTemperature: lowTemperature
        )

        weatherView.setupData(model: savedModel)
        updateBackgroundVideo(for: description)

        // Устанавливаем прогноз
        updateBackgroundVideo(for: description)

        let hourlyData = [
            (time: "08:00", temp: 18, icon: UIImage(systemName: "sun.max.fill")),
            (time: "09:00", temp: 20, icon: UIImage(systemName: "cloud.sun.fill")),
            (time: "10:00", temp: 18, icon: UIImage(systemName: "cloud.sun.bolt.fill")),
            (time: "11:00", temp: 20, icon: UIImage(systemName: "cloud.bolt.fill")),
            (time: "12:00", temp: 22, icon: UIImage(systemName: "snowflake")),
            (time: "13:00", temp: 22, icon: UIImage(systemName: "wind.snow"))
        ]
        
        hourlyForecastView.configure(with: hourlyData)
        
        let dailyData = [
            (day: "Today", icon: UIImage(systemName: "cloud.rain.fill"), tempRange: "1° - 5°", progress: Float(0.7), precipitation: "70%"),
            (day: "Sun", icon: UIImage(systemName: "cloud.fill"), tempRange: "-1° - 5°", progress: Float(0.6), precipitation: nil),
            (day: "Mon", icon: UIImage(systemName: "cloud.rain.fill"), tempRange: "1° - 7°", progress: Float(0.8), precipitation: "40%"),
            (day: "Tue", icon: UIImage(systemName: "cloud.rain.fill"), tempRange: "3° - 8°", progress: Float(1.0), precipitation: "70%"),
            (day: "Wed", icon: UIImage(systemName: "cloud.fill"), tempRange: "2° - 8°", progress: Float(0.9), precipitation: "60%"),
            (day: "Thu", icon: UIImage(systemName: "sun.max.fill"), tempRange: "-1° - 4°", progress: Float(0.5), precipitation: nil)
        ]
        dailyForecastTableView.configure(with: dailyData)
    }

    private func updateBackgroundVideo(for description: String) {
        let videoName: String
        switch description.lowercased() {
        case "rain":
            videoName = "rain"
        case "cloudy":
            videoName = "cloudy"
        case "clear":
            videoName = "clear"
        case "snow":
            videoName = "snow"
        default:
            videoName = "default"
        }
        playVideo(named: videoName)
    }
}

