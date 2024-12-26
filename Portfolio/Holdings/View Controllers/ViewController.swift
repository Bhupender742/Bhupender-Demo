//
//  ViewController.swift
//  Upstox
//
//  Created by Lucifer on 24/12/24.
//

import UIKit

class ViewController: UIViewController {
    private lazy var holdingsButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .black
        button.setTitle("Show Holdings", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(showHoldings), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Private
private extension ViewController {
    func setupViews() {
        view.addSubview(holdingsButton)
        NSLayoutConstraint.activate([
            holdingsButton.heightAnchor.constraint(equalToConstant: 56),
            holdingsButton.widthAnchor.constraint(equalToConstant: 224),
            holdingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            holdingsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func showHoldings() {
        let holdingsVC = HoldingsViewController(viewModel: HoldingsViewModel())
        holdingsVC.modalPresentationStyle = .fullScreen
        present(holdingsVC, animated: true)
    }
}

