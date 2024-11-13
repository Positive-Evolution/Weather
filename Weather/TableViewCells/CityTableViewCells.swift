import UIKit

class CityTableViewCell: UITableViewCell {
    
    private var cityView: CityView = {
        let city = CityView()
        city.translatesAutoresizingMaskIntoConstraints = false
        return city
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        selectionStyle = .none
        contentView.backgroundColor = .systemCyan
        setupSubViews()
        setupConstraints()
    }
    
    private func setupSubViews() {
        contentView.addSubview(cityView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cityView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cityView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cityView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            cityView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func setup(model: SearchModel) {
        cityView.setup(model: model)
        updateBackground(for: model.description)
    }
    
    private func updateBackground(for condition: String) {
        let imageName: String
        
        switch condition.lowercased() {
        case "rain":
            imageName = "rain_background"
        case "cloudy":
            imageName = "cloudy_background"
        case "mostly clear", "clear":
            imageName = "clear_background"
        case "snow":
            imageName = "snow_background"
        case "fog":
            imageName = "fog_background"
        default:
            cityView.backgroundColor = UIColor(red: 35/255.0, green: 78/255.0, blue: 119/255.0, alpha: 1.0) // Default background
            return
        }
        
        if let image = UIImage(named: imageName) {
            cityView.backgroundColor = UIColor(patternImage: image)
        } else {
            print("Error: Image \(imageName) not found.")
            cityView.backgroundColor = UIColor(red: 35/255.0, green: 78/255.0, blue: 119/255.0, alpha: 1.0) // Default background
        }
    }
}
