    import UIKit

    class CityViewController: UIViewController {
        
        let cityLabel = UILabel()
        
        private let cityModel: SearchModel
        
        init(model: SearchModel) {
            cityModel = model
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 60, height: 100)
            layout.minimumLineSpacing = 16
            
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupUI()
            layoutUI()
            
            let backgroundImage = UIImage(named: "clouds") // "clouds" - name of my picture
            
            let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)  // Create and set UIImageView
            backgroundImageView.image = backgroundImage
            backgroundImageView.contentMode = .scaleAspectFill // Set to full screen
            
            self.view.addSubview(backgroundImageView)  // Add UIImageView to view
            self.view.sendSubviewToBack(backgroundImageView)  // Move UIImageView to back
        }
        
        private func setupUI() {
            view.backgroundColor = .systemBackground
            
            // City label
            cityLabel.text = cityModel.city
            cityLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
            cityLabel.textAlignment = .center
            cityLabel.translatesAutoresizingMaskIntoConstraints = false
            return view.addSubview(cityLabel)
        }
        
        private func layoutUI() {
            NSLayoutConstraint.activate([
                cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
                cityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
                
            ])
        }
    }
