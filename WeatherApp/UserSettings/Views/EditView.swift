//
//  EditView.swift
//  WeatherApp
//
//  Created by Corjin, Valentin on 7/25/22.
//

import UIKit

class EditView: UIView {
    private enum Constants {
        static let blurEffectViewCornerRadius: CGFloat = 8.0
        static let editTableTopAnchorPadding: CGFloat = 10.0
        static let cellIdentifier = "cell"
    }
    
    // MARK: - Private Properties
    
    weak var delegate: EditDelegate?
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.layer.cornerRadius = Constants.blurEffectViewCornerRadius
        blurEffectView.clipsToBounds = true
        return blurEffectView
    }()
    private let editTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.isScrollEnabled = false
        return table
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private methods
    
    private func setup() {
        addSubview(blurEffectView)
        blurEffectView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blurEffectView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        addSubview(editTable)
        editTable.delegate = self
        editTable.dataSource = self
        editTable.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        editTable.topAnchor.constraint(equalTo: topAnchor, constant: Constants.editTableTopAnchorPadding).isActive = true
        editTable.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        editTable.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        editTable.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        editTable.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}

// MARK: - UITableViewDelegate

extension EditView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            delegate?.startEditing()
        } else if indexPath.row == 0 {
                delegate?.convertToCelsius()
        } else {
            delegate?.convertToFahrenheit()
        }
    }
}

// MARK: - UITableViewDataSource

extension EditView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = "Edit list"
        } else if indexPath.row == 0 {
            cell.textLabel?.text = "Celsius"
        } else {
            cell.textLabel?.text = "Fahrenheit"
        }
        cell.backgroundColor = .clear
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
}
