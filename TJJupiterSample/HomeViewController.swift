import UIKit
import TJJupiterSDK

class HomeViewController: UIViewController {

    private enum AuthStage {
        case authenticating
        case authorized
        case failed
    }

    private let singleSectorIds = [20]
    private let multiSectorIds = [20, 112]

    private var authStage: AuthStage = .authenticating {
        didSet {
            updateButtonStates()
        }
    }

    private let authStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "auth : AUTHENTICATING"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        return stackView
    }()

    private let singleSectorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("단일 섹터", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()

    private let multiSectorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다중 섹터", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor.systemIndigo
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        updateButtonStates()
        doAuth()
    }

    private func setupLayout() {
        view.backgroundColor = .systemBackground
        title = "TJJupiter Sample"

        singleSectorButton.addTarget(self, action: #selector(singleSectorTapped), for: .touchUpInside)
        multiSectorButton.addTarget(self, action: #selector(multiSectorTapped), for: .touchUpInside)

        view.addSubview(buttonStackView)
        view.addSubview(authStatusLabel)

        buttonStackView.addArrangedSubview(singleSectorButton)
        buttonStackView.addArrangedSubview(multiSectorButton)

        NSLayoutConstraint.activate([
            buttonStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 52),

            authStatusLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -24),
            authStatusLabel.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor),
            authStatusLabel.trailingAnchor.constraint(equalTo: buttonStackView.trailingAnchor)
        ])
    }

    func doAuth() {
        authStage = .authenticating
        authStatusLabel.text = "auth : AUTHENTICATING"
        TJJupiterAuth.shared.auth(accessKey: "", secretAccessKey: "", completion: { [weak self] statusCode, success in
            let successRange = 200..<300
            DispatchQueue.main.async {
                guard let self else { return }
                if success, successRange.contains(statusCode) {
                    self.authStage = .authorized
                    self.authStatusLabel.text = "auth : AUTHORIZED"
                } else {
                    self.authStage = .failed
                    self.authStatusLabel.text = "auth : AUTH FAIL (\(statusCode))"
                }
            }
        })
    }

    private func updateButtonStates() {
        let isEnabled = authStage == .authorized
        setButtonState(singleSectorButton, isEnabled: isEnabled, activeColor: .systemBlue)
        setButtonState(multiSectorButton, isEnabled: isEnabled, activeColor: .systemIndigo)
    }

    private func setButtonState(_ button: UIButton, isEnabled: Bool, activeColor: UIColor) {
        button.isEnabled = isEnabled
        button.alpha = isEnabled ? 1.0 : 0.5
        button.backgroundColor = isEnabled ? activeColor : .systemGray2
    }

    @objc func singleSectorTapped() {
        pushMainViewController(sectorIds: singleSectorIds, title: "단일 섹터")
    }

    @objc func multiSectorTapped() {
        pushMainViewController(sectorIds: multiSectorIds, title: "다중 섹터")
    }

    private func pushMainViewController(sectorIds: [Int], title: String) {
        let mainViewController = MainViewController(sectorIds: sectorIds)
        mainViewController.title = title
        navigationController?.pushViewController(mainViewController, animated: true)
    }
}
