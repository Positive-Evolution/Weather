import UIKit
import AVFoundation

class CityView: UIView {
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    private lazy var cityNamelabel: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        name.text = "" // Установите текст позже
        name.textColor = .white
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private lazy var cityTimelabel: UILabel = {
        let time = UILabel()
        time.text = ""
        time.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        time.textColor = .white.withAlphaComponent(0.8)
        time.translatesAutoresizingMaskIntoConstraints = false
        return time
    }()
    
    private lazy var cityDescriptionlabel: UILabel = {
        let description = UILabel()
        description.text = ""
        description.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        description.textColor = .white.withAlphaComponent(0.8)
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    
    private lazy var cityTemperaturelabel: UILabel = {
        let temperature = UILabel()
        temperature.font = UIFont.systemFont(ofSize: 42)
        temperature.text = ""
        temperature.textColor = .white
        temperature.translatesAutoresizingMaskIntoConstraints = false
        return temperature
    }()
    
    private lazy var cityHighTemperaturelabel: UILabel = {
        let highTemperature = UILabel()
        highTemperature.text = ""
        highTemperature.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        highTemperature.textColor = .white
        highTemperature.translatesAutoresizingMaskIntoConstraints = false
        return highTemperature
    }()
    
    private lazy var cityLowTemperaturelabel: UILabel = {
        let lowTemperature = UILabel()
        lowTemperature.text = ""
        lowTemperature.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        lowTemperature.textColor = .white
        lowTemperature.translatesAutoresizingMaskIntoConstraints = false
        return lowTemperature
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor(red: 35/255.0, green: 78/255.0, blue: 119/255.0, alpha: 1.0)
        layer.cornerRadius = 20
        layer.masksToBounds = true
        setupVideoLayer()
        setupSubViews()
        setupConstraints()
    }
    
    private func setupVideoLayer() {
        playerLayer = AVPlayerLayer()
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = playerLayer {
            layer.insertSublayer(playerLayer, at: 0)
        }
    }
    
    private func setupSubViews() {
        self.addSubview(cityNamelabel)
        self.addSubview(cityTimelabel)
        self.addSubview(cityDescriptionlabel)
        self.addSubview(cityTemperaturelabel)
        self.addSubview(cityLowTemperaturelabel)
        self.addSubview(cityHighTemperaturelabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cityNamelabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            cityNamelabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            
            cityTimelabel.leadingAnchor.constraint(equalTo: cityNamelabel.leadingAnchor),
            cityTimelabel.topAnchor.constraint(equalTo: cityNamelabel.bottomAnchor, constant: 2),
            
            cityDescriptionlabel.leadingAnchor.constraint(equalTo: cityNamelabel.leadingAnchor),
            cityDescriptionlabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            cityTemperaturelabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            cityTemperaturelabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            
            cityLowTemperaturelabel.trailingAnchor.constraint(equalTo: cityTemperaturelabel.trailingAnchor),
            cityLowTemperaturelabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            cityHighTemperaturelabel.trailingAnchor.constraint(equalTo: cityLowTemperaturelabel.trailingAnchor, constant: -40),
            cityHighTemperaturelabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
    
    func setup(model: SearchModel) {
        cityNamelabel.text = model.city
        cityTimelabel.text = model.time
        cityDescriptionlabel.text = model.description
        cityTemperaturelabel.text = "\(model.temperature)°"
        cityHighTemperaturelabel.text = "H: \(model.highTemperature)°"
        cityLowTemperaturelabel.text = "L: \(model.lowTemperature)°"
        updateBackgroundVideo(for: model.description)
    }
    
    private func updateBackgroundVideo(for condition: String) {
        let videoName: String
        switch condition.lowercased() {
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
        
        guard let path = Bundle.main.path(forResource: videoName, ofType: "mp4") else {
            print("Видео не найдено: \(videoName)")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let playerItem = AVPlayerItem(url: url)
        
        if player == nil {
            player = AVPlayer(playerItem: playerItem)
            playerLayer?.player = player
        } else {
            player?.replaceCurrentItem(with: playerItem)
        }
        
        // Подписка на окончание видео
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        player?.play()
    }
    
    @objc private func videoDidEnd() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    func stopVideoPlayback() {
        player?.pause()
        NotificationCenter.default.removeObserver(self)
    }
}
