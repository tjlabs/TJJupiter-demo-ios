import UIKit
import TJJupiterSDK

class MainViewController: UIViewController, JupiterServiceManagerDelegate {
    func onJupiterSuccess(_ isSuccess: Bool, _ code: JupiterErrorCode?) {
        print("(MainVC) onJupiterSuccess : \(isSuccess)")
        DispatchQueue.main.async {
            let codeText = code.map { String(describing: $0) } ?? "nil"
            self.serviceStatusLabel.text = "service : \(isSuccess ? "SUCCESS" : "FAIL") (code: \(codeText))"
        }
    }
    
    func onJupiterReport(_ code: JupiterServiceCode, _ msg: String) {
        print("(MainVC) onJupiterReport : \(code), \(msg)")
    }
    
    func onJupiterResult(_ result: JupiterResult) {
        let buildingName = result.building_name
        let levelName = result.level_name
        let index = result.index
        let x = result.jupiter_pos.x
        let y = result.jupiter_pos.y
        let heading = result.jupiter_pos.heading
        DispatchQueue.main.async {
            self.buildingLabel.text = "building : \(buildingName)"
            self.levelLabel.text = "level : \(levelName)"
            self.xLabel.text = String(format: "x : %.2f", x)
            self.yLabel.text = String(format: "y : %.2f", y)
            self.headingLabel.text = String(format: "heading : %.2f", heading)
            self.serviceStatusLabel.text = "service : RUNNING (index: \(index))"
        }
    }
    
    func isJupiterInOutStateChanged(_ state: InOutState) {
        print("(MainVC) isJupiterInOutStateChanged : \(state)")
    }
    
    func isUserGuidanceOut() {
        // TODD
    }
    
    func isNavigationRouteChanged(_ routes: [(String, String, Int, Float, Float)]) {
        // TODO
    }
    
    func isNavigationRouteFailed() {
        // TODO
    }
    
    func isWaypointChanged(_ waypoints: [[Double]]) {
        // TODO
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = UIColor(hex: "#E47325")
        button.layer.cornerRadius = 8
        button.isUserInteractionEnabled = false
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(startServiceTapped), for: .touchUpInside)
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중지", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = UIColor.systemGray2
        button.layer.cornerRadius = 8
        button.isUserInteractionEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(stopServiceTapped), for: .touchUpInside)
        return button
    }()
    
    private let serviceStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "NONE"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let buildingLabel: UILabel = {
        let label = UILabel()
        label.text = "building : NONE"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.text = "level : NONE"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let xLabel: UILabel = {
        let label = UILabel()
        label.text = "x : NONE"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let yLabel: UILabel = {
        let label = UILabel()
        label.text = "y : NONE"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let headingLabel: UILabel = {
        let label = UILabel()
        label.text = "heading : NONE"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        initialize()
        doAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    var serviceManager: JupiterServiceManager?
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        title = "TJJupiter Sample"
        
        view.addSubview(containerView)
        containerView.addSubview(rootStackView)
        
        rootStackView.addArrangedSubview(buttonStackView)
        rootStackView.addArrangedSubview(infoStackView)
        
        buttonStackView.addArrangedSubview(startButton)
        buttonStackView.addArrangedSubview(stopButton)
        
        infoStackView.addArrangedSubview(serviceStatusLabel)
        infoStackView.addArrangedSubview(buildingLabel)
        infoStackView.addArrangedSubview(levelLabel)
        infoStackView.addArrangedSubview(xLabel)
        infoStackView.addArrangedSubview(yLabel)
        infoStackView.addArrangedSubview(headingLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            
            rootStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
            
            startButton.heightAnchor.constraint(equalToConstant: 52),
            stopButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    func doAuth() {
        TJJupiterAuth.shared.auth(accessKey: "AK_-xVNF3MeRzQMhBIVLU5GQ", secretAccessKey: "SK1nVeBlJldifxC7z8vD8ZeercMgrSqmzNzz5RItSrDaM", completion: { [self] statusCode, success in
            let successRange = 200..<300
            if successRange.contains(statusCode) {
                self.startButton.isUserInteractionEnabled = true
            }
        })
    }
    
    func initialize() {
        let userId = "sample-test"
        serviceManager = JupiterServiceManager(id: userId)
        serviceManager?.delegate = self
    }
    
    func startService() {
        let sectorId = 20
        let mode: UserMode = .MODE_VEHICLE
//        serviceManager?.setMockingMode()
        serviceManager?.setSimulationMode(flag: true, rfdFileName: "Rfd1.json", uvdFileName: "Uvd1.json", eventFileName: "Event1.json")
        serviceManager?.startService(sectorId: sectorId, mode: mode, debugOption: true)
    }
    
    func stopService(completion: @escaping (Bool, String) -> Void) {
        serviceManager?.stopService(completion: completion)
    }
    
    func mockingMode() {
        serviceManager?.setMockingMode()
    }
    
    @objc func startServiceTapped() {
        startButton.isUserInteractionEnabled = false
        stopButton.isUserInteractionEnabled = true
        startButton.alpha = 0.5
        stopButton.alpha = 1.0
        startService()
    }
    
    @objc func stopServiceTapped() {
        stopService(completion: { [self] isSuccess, msg in
            print("(MainVC) stopService : \(isSuccess) , \(msg)")
            if isSuccess {
                startButton.isUserInteractionEnabled = true
                stopButton.isUserInteractionEnabled = false
                self.startButton.alpha = 1.0
                self.stopButton.alpha = 0.5
                self.serviceStatusLabel.text = "service : STOPPED"
            }
        })
    }
}
