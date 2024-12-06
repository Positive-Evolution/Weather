import UIKit

class HomeWeatherView: UIView {
    
    private var cityNameLabel: UILabel = {
        let name = UILabel()
        name.text = ""
        name.textColor = .white
        name.font = UIFont.systemFont(ofSize: 34)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private var tempLabel: UILabel = {
        let temp = UILabel()
        temp.text = ""
        temp.textColor = .white
        temp.font = UIFont.systemFont(ofSize: 100, weight: .regular)
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    private var descriptionLabel: UILabel = {
        let description = UILabel()
        description.text = ""
        description.textColor = UIColor.white.withAlphaComponent(0.8)
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    
    private var maxMinTempLabel: UILabel = {
        let maxmintemp = UILabel()
        maxmintemp.text = ""
        maxmintemp.textColor = .white
        maxmintemp.translatesAutoresizingMaskIntoConstraints = false
        return maxmintemp
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        setupSubViews()
        setupConstraints()
    }
    
    private func setupSubViews() {
        addSubview(cityNameLabel)
        addSubview(tempLabel)
        addSubview(descriptionLabel)
        addSubview(maxMinTempLabel)
    }
    
    func setupData(model: SearchModel) {
        cityNameLabel.text = model.city
        tempLabel.text = "\(model.temperature)°"
        descriptionLabel.text = model.description
        maxMinTempLabel.text = "H:\(model.highTemperature)° L:\(model.lowTemperature)°"
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            cityNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tempLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 2),
            tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 2),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            maxMinTempLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 2),
            maxMinTempLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
