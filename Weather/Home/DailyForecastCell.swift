import UIKit

class DailyForecastCell: UITableViewCell {
    
    static let identifier = "DailyForecastCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let tempRangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.tintColor = UIColor.systemBlue
        progressView.trackTintColor = UIColor(white: 1.0, alpha: 0.4)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private let precipitationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(dayLabel)
        containerView.addSubview(iconImageView)
        containerView.addSubview(tempRangeLabel)
        containerView.addSubview(progressBar)
        containerView.addSubview(precipitationLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            dayLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            iconImageView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            tempRangeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            tempRangeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            progressBar.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: tempRangeLabel.leadingAnchor, constant: -16),
            progressBar.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            precipitationLabel.trailingAnchor.constraint(equalTo: progressBar.trailingAnchor),
            precipitationLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 4)
        ])
    }
    
    func configure(day: String, icon: UIImage?, tempRange: String, progress: Float, precipitation: String?) {
        dayLabel.text = day
        iconImageView.image = icon
        tempRangeLabel.text = tempRange
        progressBar.progress = progress
        precipitationLabel.text = precipitation
        precipitationLabel.isHidden = (precipitation == nil)
    }
}
