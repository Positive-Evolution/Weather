import UIKit

class HourlyForecastView: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.2)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    private var hourlyTemperatures: [(time: String, temp: Int, icon: UIImage?)] = []

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(containerView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor), // Убедитесь, что эта строка есть
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor), // Добавляем высоту, если её нет
            
            // Убедитесь, что ширина stackView >= scrollView
            stackView.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.widthAnchor)
        ])
    }

    func configure(with data: [(time: String, temp: Int, icon: UIImage?)]) {
        self.hourlyTemperatures = data
        updateStackView()
    }

    private func updateStackView() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for data in hourlyTemperatures {
            let hourView = createHourView(time: data.time, temperature: data.temp, icon: data.icon)
            stackView.addArrangedSubview(hourView)
        }
    }

    private func createHourView(time: String, temperature: Int, icon: UIImage?) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let timeLabel = UILabel()
        timeLabel.text = time
        timeLabel.textColor = .white
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        
        let tempLabel = UILabel()
        tempLabel.text = "\(temperature)°"
        tempLabel.textColor = .white
        tempLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let iconImageView = UIImageView()
        iconImageView.image = icon?.withRenderingMode(.alwaysTemplate) // Устанавливаем режим рендеринга
        iconImageView.tintColor = .white // Устанавливаем цвет
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: [timeLabel, iconImageView, tempLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            view.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        return view
    }
}
