//
//  ExpandedTableViewCell.swift
//  Upstox
//
//  Created by Lucifer on 25/12/24.
//

import UIKit

class ExpandedTableViewCell: UITableViewCell {
    private lazy var investmentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helper
extension ExpandedTableViewCell {
    func setupViews() {
        contentView.addSubview(investmentLabel)
        NSLayoutConstraint.activate([
            investmentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            investmentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        contentView.addSubview(amountLabel)
        NSLayoutConstraint.activate([
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(investment: String, amount: Double, showColoredText: Bool = false) {
        investmentLabel.text = investment
        amountLabel.text = String(format: Utility.currencyFormat, amount)

        let priceType = Utility.getPriceType(for: amount)
        if priceType == .neutral || !showColoredText {
            amountLabel.textColor = .gray
            return
        }

        amountLabel.textColor = priceType == .profit ? .green: .red
    }
}
