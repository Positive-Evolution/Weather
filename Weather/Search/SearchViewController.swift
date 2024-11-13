import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func citySelectedByUser(model: SearchModel)
}

class SearchViewController: UIViewController {
    
    weak var delegate: SearchViewControllerDelegate?
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a city or airport"
        searchController.searchBar.backgroundColor = .systemCyan
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
        table.backgroundColor = .systemCyan
        return table
    }()
    
    private lazy var closeButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Close", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        self.viewModel.getSearchData()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        viewModel.delegate = self
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesBackButton = true
        navigationItem.title = "Weather"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(showMenu))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .systemCyan
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func showMenu() {
        print("Show Menu")
    }
}

// MARK: UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getInfoData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CityTableViewCell
        else { return UITableViewCell() }
        cell.setup(model: viewModel.getInfoData()[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoModel = viewModel.getInfoData()[indexPath.row]
        delegate?.citySelectedByUser(model: infoModel)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        viewModel.searchedData(data: searchBar.text ?? "")
    }
}

// MARK: UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchedData(data: searchController.searchBar.text ?? "")
    }
}

// MARK: SearchViewModelDelegate
extension SearchViewController: SearchViewModelDelegate {
    func dataLoaded() {
        tableView.reloadData()
    }
}
