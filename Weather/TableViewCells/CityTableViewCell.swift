import UIKit
import AVFoundation

class CityTableViewCell: UITableViewCell {
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    private lazy var cityView: CityView = {
        let view = CityView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cityView)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        setupConstraints()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cityView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cityView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            cityView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cityView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func setup(model: SearchModel) {
        // Настройка данных через CityView
        cityView.setup(model: model)
        
        // Настройка фона с видео
        //        updateBackgroundVideo(for: model.description)
    }
    
    //    private func updateBackgroundVideo(for condition: String) {
    //        let videoName: String
    //        switch condition.lowercased() {
    //        case "rain":
    //            videoName = "rain"
    //        case "cloudy":
    //            videoName = "cloudy"
    //        case "clear":
    //            videoName = "clear"
    //        case "snow":
    //            videoName = "snow"
    //        default:
    //            videoName = "default"
    //        }
    
    //        guard let path = Bundle.main.path(forResource: videoName, ofType: "mp4") else {
    //            print("Видео не найдено: \(videoName)")
    //            return
    //        }
    //
    //        let url = URL(fileURLWithPath: path)
    //        let playerItem = AVPlayerItem(url: url)
    //
    //        if player == nil {
    //            // Создаем новый плеер и слой
    //            player = AVPlayer(playerItem: playerItem)
    //            playerLayer = AVPlayerLayer(player: player)
    //            playerLayer?.videoGravity = .resizeAspectFill
    //            playerLayer?.frame = contentView.bounds
    //
    //            if let playerLayer = playerLayer {
    //                contentView.layer.insertSublayer(playerLayer, at: 0)
    //            }
    //        } else {
    //            // Заменяем текущий элемент
    //            player?.replaceCurrentItem(with: playerItem)
    //        }
    //
    //        player?.play()
    //    }
    //
    //    override func prepareForReuse() {
    //        super.prepareForReuse()
    //        // Сброс видео при переиспользовании ячейки
    //        player?.pause()
    //        playerLayer?.removeFromSuperlayer()
    //        player = nil
    //        playerLayer = nil
    //    }
    //
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //        playerLayer?.frame = contentView.bounds
    //    }
    //}
}
