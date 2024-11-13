import UIKit

class HomeViewController: UIViewController {
    
    private lazy var weatherView: HomeWeatherView = {
        let weatherView = HomeWeatherView()
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        return weatherView
    }()
    
    private lazy var nameOfCityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "TEST"
        return label
    }()
    
    private lazy var mapButton: UIButton = {
        let btn = UIButton(type: .custom)
        let symbolImage = UIImage(systemName: "map")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 28))
        btn.setImage(symbolImage, for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var searchButton: UIButton = {
        let btn = UIButton(type: .custom)
        let symbolImage = UIImage(systemName: "list.bullet")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 28))
        btn.setImage(symbolImage, for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemCyan
        
        view.addSubview(backgroundImageView) // Новый фон
        view.addSubview(weatherView)
        view.addSubview(mapButton)
        view.addSubview(searchButton)
        view.addSubview(nameOfCityLabel)
        
        mapButton.addTarget(self, action: #selector(mapAction), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            weatherView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            mapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            mapButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            
            searchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            nameOfCityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameOfCityLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
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
    
    func updateBackground(for condition: String) {  // Новая логика обновления фона
        let imageName: String
        switch condition.lowercased() {
        case "rain":
            imageName = "rain_background"
        case "cloudy":
            imageName = "cloudy_background"
        case "clear":
            imageName = "clear_background"
        default:
            imageName = "default_background"
        }
        backgroundImageView.image = UIImage(named: imageName)
    }
}

extension HomeViewController: SearchViewControllerDelegate {
    func citySelectedByUser(model: SearchModel) {
        nameOfCityLabel.text = model.city
        weatherView.setupData(model: model)
        updateBackground(for: model.description) // Установка фона
    }
}
