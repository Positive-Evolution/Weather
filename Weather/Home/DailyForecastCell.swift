import UIKit

class DailyForecastCell: UITableViewCell {
    
    static let identifier = "DailyForecastCell"
    
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
        progressView.trackTintColor = UIColor(white: 1.0, alpha: 0.2)
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
        contentView.addSubview(dayLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(tempRangeLabel)
        contentView.addSubview(progressBar)
        contentView.addSubview(precipitationLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            iconImageView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            tempRangeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tempRangeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            progressBar.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: tempRangeLabel.leadingAnchor, constant: -16),
            progressBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
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
