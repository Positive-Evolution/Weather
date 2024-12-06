import UIKit
import AVFoundation

protocol SearchViewControllerDelegate: AnyObject {
    func citySelectedByUser(model: SearchModel)
}

class SearchViewController: UIViewController {
    
    weak var delegate: SearchViewControllerDelegate?
    
    private var viewModel: SearchViewModel
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a city or airport"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.backgroundColor = .black
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search for a city or airport",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        searchController.searchBar.searchTextField.textColor = .white
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CityTableViewCell.self, forCellReuseIdentifier: "Cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.rowHeight = 120
        table.separatorStyle = .none
        table.backgroundColor = .black
        return table
    }()
    
    // Инициализация с передачей `SearchViewModel`
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .dark
        setupNavigationBar()
        setupTableView()
        setupSearchController()
        
        viewModel.delegate = self
        viewModel.didLoad()
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black // Цвет фона навигационной панели
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Цвет текста заголовка
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Цвет текста большого заголовка

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Weather"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // Убираем кнопку "Back"
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.searchTextField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search for a city or airport",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getInfoData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }
        let model = viewModel.getInfoData()[indexPath.row]
        cell.setup(model: model)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedModel = viewModel.getInfoData()[indexPath.row]
        delegate?.citySelectedByUser(model: selectedModel)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchedData(data: searchText)
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.searchedData(data: searchText)
    }
}

// MARK: - SearchViewModelDelegate
extension SearchViewController: SearchViewModelDelegate {
    func dataLoaded() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
