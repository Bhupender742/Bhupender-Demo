//
//  HoldingTableViewCell.swift
//  Upstox
//
//  Created by Lucifer on 24/12/24.
//

import UIKit

final class HoldingTableViewCell: UITableViewCell {
    private lazy var symbolName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var ltpLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var profitOrLossLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
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
extension HoldingTableViewCell {
    func configure(_ holding: UserHolding) {
        setupQtyLabel(for: holding.quantity)
        setupLTPLabel(for: holding.ltp)
        setupProfitOrLossLabel(for: holding)
        symbolName.text = holding.symbol.uppercased()
    }
}

// MARK: - Private
private extension HoldingTableViewCell {
    func setupViews() {
        contentView.addSubview(symbolName)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(ltpLabel)
        contentView.addSubview(profitOrLossLabel)
        
        NSLayoutConstraint.activate([
            symbolName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            symbolName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            
            quantityLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            quantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            
            ltpLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            ltpLabel.leadingAnchor.constraint(equalTo: symbolName.trailingAnchor, constant: 16),
            ltpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            profitOrLossLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            profitOrLossLabel.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 16),
            profitOrLossLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32)
        ])
    }

    func setupQtyLabel(for qty: Int) {
        let quantityString = NSMutableAttributedString(
            string: "NET QTY: ",
            attributes: [.foregroundColor: UIColor.gray,
                         .font: UIFont.systemFont(ofSize: 12, weight: .semibold)])
        
        quantityString.append(
            NSAttributedString(
                string: "\(qty)",
                attributes: [.foregroundColor: UIColor.black,
                             .font: UIFont.systemFont(ofSize: 15, weight: .semibold)]
            )
        )

        quantityLabel.attributedText = quantityString
    }

    func setupLTPLabel(for ltp: Double) {
        let ltpString = NSMutableAttributedString(
            string: "LTP: ",
            attributes: [.foregroundColor: UIColor.gray,
                         .font: UIFont.systemFont(ofSize: 12, weight: .semibold)])

        ltpString.append(
            NSAttributedString(
                string: String(format: Utility.currencyFormat, ltp),
                attributes: [.foregroundColor: UIColor.black,
                             .font: UIFont.systemFont(ofSize: 15, weight: .semibold)]
            )
        )

        ltpLabel.attributedText = ltpString
    }
    
    func setupProfitOrLossLabel(for holding: UserHolding) {
        var foregroundColor: UIColor = .black
        
        if holding.priceType != .neutral {
            foregroundColor = holding.priceType == .profit ? .green: .red
        }

        let profitOrLossString = NSMutableAttributedString(
            string: "P&L: ",
            attributes: [.foregroundColor: UIColor.gray,
                         .font: UIFont.systemFont(ofSize: 12, weight: .semibold)])
        
        profitOrLossString.append(
            NSAttributedString(
                string: String(format: Utility.currencyFormat, holding.profitOrLoss),
                attributes: [.foregroundColor: foregroundColor,
                             .font: UIFont.systemFont(ofSize: 15, weight: .semibold)]
            )
        )

        profitOrLossLabel.attributedText = profitOrLossString
    }
}
