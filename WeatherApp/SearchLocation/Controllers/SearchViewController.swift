//
//  SearchCollectionViewController.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/21/22.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    
    private enum Constants {
        static let editButtonTopAnchorPadding: CGFloat = 10.0
        static let editButtonTrailingAnchorPadding: CGFloat = -30.0
        static let editButtonHeight: CGFloat = 20.0
        static let editButtonWidth: CGFloat = 20.0
        static let okButtonTopAnchorPadding: CGFloat = 10.0
        static let okButtonTrailingAnchorPadding: CGFloat = -30.0
        static let okButtonHeight: CGFloat = 25.0
        static let okButtonWidth: CGFloat = 25.0
        static let titleLabelTopAnchorPadding: CGFloat = 20.0
        static let titleLabelLeadingAnchorPadding: CGFloat = 20.0
        static let titleLabelHeight: CGFloat = 70.0
        static let searchFieldWidthPadding: CGFloat = -50.0
        static let searchFieldHeight: CGFloat = 30.0
        static let searchFieldTopAnchorPadding: CGFloat = 0.0
        static let tableViewTopAnchorPadding: CGFloat = 20.0
        static let tableViewWidthPadding: CGFloat = -10.0
        static let tableViewHeightMultiplier: CGFloat = 0.8
        static let editViewWidth: CGFloat = 150.0
        static let editViewHeight: CGFloat = 150.0
        static let editViewTopAnchorPadding: CGFloat = 10.0
        static let editViewTrailingAnchorPadding: CGFloat = -10.0
    }
    
    // MARK: - Private Properties
    
    weak var weatherDelegate: WeatherDelegate?
    private let searchField: UISearchTextField = {
        let field = UISearchTextField()
        field.placeholder = NSLocalizedString("Search for a city or airport", comment: "Searching string")
        field.backgroundColor = .clear
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = NSLocalizedString("Weather", comment: "Weather title")
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.isScrollEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let editButton: UIButton = {
        let editButton = UIButton()
        editButton.backgroundColor = .clear
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        editButton.tintColor = .white
        editButton.imageView?.contentMode = .scaleAspectFit
        return editButton
    }()
    private let okButton: UIButton = {
        let okButton = UIButton()
        okButton.backgroundColor = .clear
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.tintColor = .white
        okButton.setTitle("OK", for: .normal)
        okButton.isHidden = true
        return okButton
    }()
    private let editView: EditView = {
        let stack = EditView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .clear
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(editButton)
        editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.editButtonTopAnchorPadding).isActive = true
        editButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.editButtonTrailingAnchorPadding).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: Constants.editButtonWidth).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: Constants.editButtonHeight).isActive = true
        editButton.addTarget(self, action: #selector(didPressEdit(_:)), for: .touchUpInside)
        
        view.addSubview(okButton)
        okButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.okButtonTopAnchorPadding).isActive = true
        okButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.editButtonTrailingAnchorPadding).isActive = true
        okButton.widthAnchor.constraint(equalToConstant: Constants.okButtonWidth).isActive = true
        okButton.heightAnchor.constraint(equalToConstant: Constants.editButtonHeight).isActive = true
        okButton.addTarget(self, action: #selector(didPressOk(_:)), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleLabelHeight).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.titleLabelTopAnchorPadding).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.titleLabelLeadingAnchorPadding).isActive = true
        
        view.addSubview(searchField)
        searchField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: Constants.searchFieldWidthPadding).isActive = true
        searchField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        searchField.heightAnchor.constraint(equalToConstant: Constants.searchFieldHeight).isActive = true
        searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.searchFieldTopAnchorPadding).isActive = true
        searchField.addTarget(self, action: #selector(didPressEnter(_:)), for: .editingDidEndOnExit)
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: Constants.tableViewTopAnchorPadding).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: Constants.tableViewWidthPadding).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: Constants.tableViewHeightMultiplier).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true

        view.addSubview(editView)
        editView.delegate = self
        editView.widthAnchor.constraint(equalToConstant: Constants.editViewWidth).isActive = true
        editView.heightAnchor.constraint(equalToConstant: Constants.editViewHeight).isActive = true
        editView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: Constants.editViewTopAnchorPadding).isActive = true
        editView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.editViewTrailingAnchorPadding).isActive = true
        editView.isHidden = true
    }
    
    @objc private func didPressEnter(_ sender: UISearchTextField) {
        guard let address = sender.text else { return }
        weatherDelegate?.addWeatherPage(with: address)
        sender.text = ""
        dismiss(animated: true, completion: nil)
        editView.isHidden = true
        editButton.tintColor = .white
        tableView.isEditing = false
        editButton.isHidden = false
        okButton.isHidden = true
    }
    
    @objc private func didPressEdit(_ sender: UIButton) {
        editView.isHidden.toggle()
        sender.tintColor = editView.isHidden ? .white : .systemGray
    }
    
    @objc private func didPressOk(_ sender: UIButton) {
        sender.isHidden = true
        editButton.isHidden = false
        tableView.isEditing.toggle()
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            weatherDelegate?.selectWeatherPage(at: indexPath.row)
            dismiss(animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 { return false }
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 { return false }
        return tableView.isEditing
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if destinationIndexPath.row == 0 { return }
        weatherDelegate?.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherDelegate?.removePage(at: indexPath.row)
            tableView.reloadData()
        }
     }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfCells = weatherDelegate?.getNumberOfPages() else { return 0 }
        return numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell
        else { return UITableViewCell() }
        guard let data = weatherDelegate?.passData(for: indexPath.row) else { return UITableViewCell() }
        let cityName = data.cityName
        let currentTemp = data.hourlyForecast[0].temp
        let maxTemp = data.temperature.max
        let minTemp = data.temperature.min
        let cellData = SearchTableViewCell.Model(cityName: cityName, temp: currentTemp, maxTemp: maxTemp, minTemp: minTemp)
        cell.passCellData(data: cellData)
        return cell
    }
}

// MARK: - EditDelegate

extension SearchViewController: EditDelegate {
    func startEditing() {
        editButton.tintColor = .white
        editButton.isHidden.toggle()
        editView.isHidden.toggle()
        okButton.isHidden.toggle()
        tableView.isEditing.toggle()
    }
    
    func convertToCelsius() {
        weatherDelegate?.convertToCelsius()
        editButton.tintColor = .white
        editView.isHidden.toggle()
        tableView.reloadData()
    }
    
    func convertToFahrenheit() {
        weatherDelegate?.convertToFahrenheit()
        editButton.tintColor = .white
        editView.isHidden.toggle()
        tableView.reloadData()
    }
}
