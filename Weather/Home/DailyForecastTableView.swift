import UIKit

class DailyForecastTableView: UIView {

    private let tableView = UITableView()

    private var dailyForecast: [(day: String, minTemp: Int, maxTemp: Int, chanceOfRain: String?)] = []

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WeatherDayCell.self, forCellReuseIdentifier: "WeatherDayCell")
        tableView.dataSource = self
        tableView.rowHeight = 60

        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with data: [(day: String, minTemp: Int, maxTemp: Int, chanceOfRain: String?)]) {
        self.dailyForecast = data
        tableView.reloadData()
    }
}

extension DailyForecastTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecast.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDayCell", for: indexPath) as? WeatherDayCell else {
            return UITableViewCell()
        }
        
        let data = dailyForecast[indexPath.row]
        cell.configure(day: data.day, minTemp: data.minTemp, maxTemp: data.maxTemp, chanceOfRain: data.chanceOfRain)
        return cell
    }
}

class WeatherDayCell: UITableViewCell {
    private let dayLabel = UILabel()
    private let minMaxTempLabel = UILabel()
    private let rainChanceLabel = UILabel()
    private let gradientView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        minMaxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        rainChanceLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(gradientView)
        contentView.addSubview(dayLabel)
        contentView.addSubview(minMaxTempLabel)
        contentView.addSubview(rainChanceLabel)

        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 8),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rainChanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rainChanceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            minMaxTempLabel.trailingAnchor.constraint(equalTo: rainChanceLabel.leadingAnchor, constant: -8),
            minMaxTempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    func configure(day: String, minTemp: Int, maxTemp: Int, chanceOfRain: String?) {
        dayLabel.text = day
        minMaxTempLabel.text = "H: \(maxTemp)° L: \(minTemp)°"
        rainChanceLabel.text = chanceOfRain ?? ""
        applyGradient(for: maxTemp)
    }

    private func applyGradient(for temp: Int) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.red.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
    }
}
