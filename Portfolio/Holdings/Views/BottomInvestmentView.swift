//
//  BottomInvestmentView.swift
//  Upstox
//
//  Created by Lucifer on 25/12/24.
//

import UIKit

class BottomInvestmentView: UIView {
    private lazy var profitOrLossLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var profitOrLossValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var expandButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.imageView?.tintColor = .gray
        button.setImage(UIImage(systemName: Constants.ImageName.upTriangleArrow), for: .normal)
        button.addTarget(self, action: #selector(expandBtnClicked), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var investmentTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        tableView.isUserInteractionEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var investment: Investment?
    private var isExpanded: Bool = false
    var investmentTableViewHeight: NSLayoutConstraint?
    
    // This callback will be used to animate the BottomInvestmentView
    var animateBottomView: ((_ isExpanded: Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        registerCells()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Helper
extension BottomInvestmentView {
    func bindDataToExpandedView(for investment: Investment){
        self.investment = investment
        
        expandButton.isHidden = false
        profitOrLossLabel.text = "Profit & Loss:"
        profitOrLossValueLabel.text = String(format: Utility.currencyFormat, investment.totalProfitAndLoss)

        let priceType = Utility.getPriceType(for: investment.totalProfitAndLoss)
        if priceType == .neutral {
            profitOrLossValueLabel.textColor = .gray
        } else {
            profitOrLossValueLabel.textColor = priceType == .profit ? .green: .red
        }

        DispatchQueue.main.async {
            self.investmentTableView.reloadData()
        }
    }
}

// MARK: - Private
private extension BottomInvestmentView {
    func setupViews() {
        addSubview(investmentTableView)
        addSubview(footerView)

        footerView.addSubview(profitOrLossLabel)
        footerView.addSubview(expandButton)
        footerView.addSubview(profitOrLossValueLabel)

        NSLayoutConstraint.activate([
            investmentTableView.topAnchor.constraint(equalTo: topAnchor),
            investmentTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            investmentTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 64),

            profitOrLossLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor,
                                                       constant: 32),
            profitOrLossLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),

            expandButton.leadingAnchor.constraint(equalTo: profitOrLossLabel.trailingAnchor,
                                                  constant: 8),
            expandButton.heightAnchor.constraint(equalToConstant: 24),
            expandButton.widthAnchor.constraint(equalToConstant: 24),
            expandButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),

            profitOrLossValueLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor,
                                                             constant: -32),
            profitOrLossValueLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])

        investmentTableViewHeight = investmentTableView.heightAnchor.constraint(lessThanOrEqualToConstant: Constants.HeightConstant.expandedBottomTableViewHeight)
        investmentTableViewHeight?.constant = 0
        investmentTableViewHeight?.isActive = true
    }

    func registerCells() {
        investmentTableView.register(ExpandedTableViewCell.self,
                                     forCellReuseIdentifier: String(describing: ExpandedTableViewCell.self))
    }

    @objc func expandBtnClicked() {
        isExpanded.toggle()
        expandButton.setImage(
            UIImage(systemName: isExpanded ? Constants.ImageName.downTriangleArrow: Constants.ImageName.upTriangleArrow),
            for: .normal
        )
        animateBottomView?(isExpanded)
    }
}

// MARK: - Table View Data Source
extension BottomInvestmentView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let investment,
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExpandedTableViewCell.self), for: indexPath) as? ExpandedTableViewCell else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            cell.configure(investment: "Current Value:",
                           amount: investment.totalCurrentValue)
        case 1:
            cell.configure(investment: "Total Investment:",
                           amount: investment.totalInvestment)
        case 2:
            cell.configure(investment: "Today's Profit & Loss:",
                           amount: investment.todaysProfitAndLoss, showColoredText: true)
        default:
            print("INVALID - INDEXPATH")
        }
        cell.backgroundColor = .clear
        return  cell
    }
}

// MARK: - Table View Delegate
extension BottomInvestmentView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
