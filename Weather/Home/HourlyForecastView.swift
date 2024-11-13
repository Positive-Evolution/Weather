import UIKit

class HourlyForecastView: UIView {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    private var hourlyTemperatures: [(time: String, temp: Int)] = []

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }

    func configure(with data: [(time: String, temp: Int)]) {
        self.hourlyTemperatures = data
        updateStackView()
    }

    private func updateStackView() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for data in hourlyTemperatures {
            let hourView = createHourView(time: data.time, temperature: data.temp)
            stackView.addArrangedSubview(hourView)
        }
    }

    private func createHourView(time: String, temperature: Int) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let timeLabel = UILabel()
        timeLabel.text = time
        timeLabel.textColor = .white
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        
        let tempLabel = UILabel()
        tempLabel.text = "\(temperature)°"
        tempLabel.textColor = .white
        tempLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        let stack = UIStackView(arrangedSubviews: [timeLabel, tempLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            view.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        return view
    }
}
