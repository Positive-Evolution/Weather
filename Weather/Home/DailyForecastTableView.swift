import UIKit

class DailyForecastTableView: UITableView, UITableViewDataSource {
    
    private var dailyForecasts: [(day: String, icon: UIImage?, tempRange: String, progress: Float, precipitation: String?)] = []
    
    init() {
        super.init(frame: .zero, style: .plain)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        backgroundColor = .clear
        separatorStyle = .none
        translatesAutoresizingMaskIntoConstraints = false
        dataSource = self
        register(DailyForecastCell.self, forCellReuseIdentifier: DailyForecastCell.identifier)
    }
    
    func configure(with data: [(day: String, icon: UIImage?, tempRange: String, progress: Float, precipitation: String?)]) {
        dailyForecasts = data
        reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastCell.identifier, for: indexPath) as? DailyForecastCell else {
            return UITableViewCell()
        }
        let forecast = dailyForecasts[indexPath.row]
        cell.configure(
            day: forecast.day,
            icon: forecast.icon,
            tempRange: forecast.tempRange,
            progress: forecast.progress,
            precipitation: forecast.precipitation
        )
        return cell
    }
}
