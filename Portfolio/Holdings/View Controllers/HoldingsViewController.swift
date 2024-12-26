//
//  HoldingsViewController.swift
//  Upstox
//
//  Created by Lucifer on 24/12/24.
//

import UIKit

final class HoldingsViewController: UIViewController {
    private lazy var holdingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Holdings"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var bottomView: BottomInvestmentView = {
        let view = BottomInvestmentView(frame: .zero)
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = .gray
        button.setImage(UIImage(systemName: Constants.ImageName.backArrow), for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var bottomViewHeight: NSLayoutConstraint?
    
    private var viewModel: HoldingsViewModel

    init(viewModel: HoldingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchHoldings()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCells()
    }
}

// MARK: - Private
private extension HoldingsViewController {
    func registerCells() {
        tableView.register(HoldingTableViewCell.self,
                           forCellReuseIdentifier: String(describing: HoldingTableViewCell.self))
    }

    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(dismissButton)
        view.addSubview(holdingsLabel)
        view.addSubview(tableView)
        view.addSubview(bottomView)

        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 48),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),

            holdingsLabel.topAnchor.constraint(equalTo: dismissButton.topAnchor, constant: 32),
            holdingsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            holdingsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            tableView.topAnchor.constraint(equalTo: holdingsLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])

        bottomViewHeight = bottomView.heightAnchor.constraint(equalToConstant: Constants.HeightConstant.shrinkedBottomViewHeight)
        bottomViewHeight?.isActive = true
    }

    func setupBottomView(){
        guard let investment = viewModel.investment else { return }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.bottomView.bindDataToExpandedView(for: investment)
        }
        
        bottomView.animateBottomView = { isExpanded in
            UIView.animate(withDuration: 0.4) {
                if (isExpanded) {
                    self.bottomViewHeight?.constant = Constants.HeightConstant.expandedBottomViewHeight
                    self.bottomView.investmentTableViewHeight?.constant = Constants.HeightConstant.expandedBottomTableViewHeight
                } else {
                    self.bottomViewHeight?.constant = Constants.HeightConstant.shrinkedBottomViewHeight
                    self.bottomView.investmentTableViewHeight?.constant = 0
                }
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func dismissView() {
        dismiss(animated: true)
    }
}

// MARK: - Table View Data Source
extension HoldingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.holdings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HoldingTableViewCell.self), for: indexPath) as? HoldingTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(viewModel.holdings[indexPath.row])
        return cell
    }
}

// MARK: - Table View Delegate
extension HoldingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }
}

// MARK: - Holdings Delegate
extension HoldingsViewController: HoldingsDelegate {
    func reloadTableView() {
        setupBottomView()
    }
}
