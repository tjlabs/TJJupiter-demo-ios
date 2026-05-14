import UIKit
import TJJupiterSDK

class MainViewController: UIViewController, JupiterServiceManagerDelegate {
    private enum ServiceLifecycleStage {
        case authenticating
        case readyToInitialize
        case initializing
        case initialized
        case starting
        case running
        case stopping
    }
    
    private let userId = "sample-test"
    private let region: JupiterRegion = .KOREA
    private let sectorId = 20
    private let debugOption = false
    private let userMode: UserMode = .MODE_VEHICLE
    
    private var lifecycleStage: ServiceLifecycleStage = .authenticating {
        didSet {
            updateButtonStates()
        }
    }
    
    var serviceManager: JupiterServiceManager?
    
    func onInitSuccess(_ isSuccess: Bool, _ code: InitErrorCode?) {
        print("(MainVC) onInitSuccess : \(isSuccess)")
        DispatchQueue.main.async {
            let codeText = code.map { String(describing: $0) } ?? "nil"
            if isSuccess {
                self.lifecycleStage = .initialized
                self.serviceStatusLabel.text = "service : INITIALIZED (code: \(codeText))"
            } else {
                self.serviceManager = nil
                self.lifecycleStage = .readyToInitialize
                self.serviceStatusLabel.text = "service : INIT FAIL (code: \(codeText))"
            }
        }
    }
    
    func onJupiterSuccess(_ isSuccess: Bool, _ code: JupiterErrorCode?) {
        print("(MainVC) onJupiterSuccess : \(isSuccess)")
        DispatchQueue.main.async {
            let codeText = code.map { String(describing: $0) } ?? "nil"
            self.lifecycleStage = isSuccess ? .running : .initialized
            self.serviceStatusLabel.text = "service : \(isSuccess ? "RUNNING" : "START FAIL") (code: \(codeText))"
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
            guard self.shouldRenderJupiterResults else { return }
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
        // TODO
    }
    
    func isUserArrived() {
        // TODO
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
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private let initializeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("초기화", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor(hex: "#E47325")
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중지", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor.systemRed
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.alpha = 0.5
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
        serviceStatusLabel.text = "service : AUTHENTICATING"
        updateButtonStates()
        doAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        title = "TJJupiter Sample"
        
        initializeButton.addTarget(self, action: #selector(initializeTapped), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startServiceTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopServiceTapped), for: .touchUpInside)
        
        view.addSubview(containerView)
        containerView.addSubview(rootStackView)
        
        rootStackView.addArrangedSubview(buttonStackView)
        rootStackView.addArrangedSubview(infoStackView)
        
        buttonStackView.addArrangedSubview(initializeButton)
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
            
            initializeButton.heightAnchor.constraint(equalToConstant: 52),
            startButton.heightAnchor.constraint(equalToConstant: 52),
            stopButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    func doAuth() {
        TJJupiterAuth.shared.auth(accessKey: "", secretAccessKey: "", completion: { [weak self] statusCode, success in
            let successRange = 200..<300
            DispatchQueue.main.async {
                guard let self else { return }
                if success, successRange.contains(statusCode) {
                    self.lifecycleStage = .readyToInitialize
                    self.serviceStatusLabel.text = "service : AUTHORIZED"
                } else {
                    self.lifecycleStage = .authenticating
                    self.serviceStatusLabel.text = "service : AUTH FAIL (\(statusCode))"
                }
            }
        })
    }
    
    func initialize() {
        serviceManager = JupiterServiceManager(
            id: userId,
            region: region.rawValue,
            sectorId: sectorId,
            debugOption: debugOption
        )
        serviceManager?.delegate = self
        serviceManager?.setMockingMode()
    }
    
    func startService() {
        serviceManager?.startService(mode: userMode)
    }
    
    func stopService(completion: @escaping (Bool, String) -> Void) {
        serviceManager?.stopService(completion: completion)
    }
    
    private func updateButtonStates() {
        switch lifecycleStage {
        case .authenticating:
            setButtonState(initializeButton, isEnabled: false, activeColor: .systemBlue)
            setButtonState(startButton, isEnabled: false, activeColor: UIColor(hex: "#E47325"))
            setButtonState(stopButton, isEnabled: false, activeColor: .systemRed)
        case .readyToInitialize:
            setButtonState(initializeButton, isEnabled: true, activeColor: .systemBlue)
            setButtonState(startButton, isEnabled: false, activeColor: UIColor(hex: "#E47325"))
            setButtonState(stopButton, isEnabled: false, activeColor: .systemRed)
        case .initializing:
            setButtonState(initializeButton, isEnabled: false, activeColor: .systemBlue)
            setButtonState(startButton, isEnabled: false, activeColor: UIColor(hex: "#E47325"))
            setButtonState(stopButton, isEnabled: false, activeColor: .systemRed)
        case .initialized:
            setButtonState(initializeButton, isEnabled: false, activeColor: .systemBlue)
            setButtonState(startButton, isEnabled: true, activeColor: UIColor(hex: "#E47325"))
            setButtonState(stopButton, isEnabled: false, activeColor: .systemRed)
        case .starting:
            setButtonState(initializeButton, isEnabled: false, activeColor: .systemBlue)
            setButtonState(startButton, isEnabled: false, activeColor: UIColor(hex: "#E47325"))
            setButtonState(stopButton, isEnabled: false, activeColor: .systemRed)
        case .running:
            setButtonState(initializeButton, isEnabled: false, activeColor: .systemBlue)
            setButtonState(startButton, isEnabled: false, activeColor: UIColor(hex: "#E47325"))
            setButtonState(stopButton, isEnabled: true, activeColor: .systemRed)
        case .stopping:
            setButtonState(initializeButton, isEnabled: false, activeColor: .systemBlue)
            setButtonState(startButton, isEnabled: false, activeColor: UIColor(hex: "#E47325"))
            setButtonState(stopButton, isEnabled: false, activeColor: .systemRed)
        }
    }
    
    private func setButtonState(_ button: UIButton, isEnabled: Bool, activeColor: UIColor) {
        button.isEnabled = isEnabled
        button.alpha = isEnabled ? 1.0 : 0.5
        button.backgroundColor = isEnabled ? activeColor : .systemGray2
    }

    private var shouldRenderJupiterResults: Bool {
        switch lifecycleStage {
        case .starting, .running:
            return true
        default:
            return false
        }
    }
    
    private func resetResultLabels() {
        buildingLabel.text = "building : NONE"
        levelLabel.text = "level : NONE"
        xLabel.text = "x : NONE"
        yLabel.text = "y : NONE"
        headingLabel.text = "heading : NONE"
    }
    
    @objc func initializeTapped() {
        lifecycleStage = .initializing
        serviceStatusLabel.text = "service : INITIALIZING"
        resetResultLabels()
        initialize()
    }
    
    @objc func startServiceTapped() {
        lifecycleStage = .starting
        serviceStatusLabel.text = "service : STARTING"
        startService()
    }
    
    @objc func stopServiceTapped() {
        lifecycleStage = .stopping
        serviceStatusLabel.text = "service : STOPPING"
        resetResultLabels()
        stopService(completion: { [weak self] isSuccess, msg in
            print("(MainVC) stopService : \(isSuccess) , \(msg)")
            DispatchQueue.main.async {
                guard let self else { return }
                self.lifecycleStage = isSuccess ? .initialized : .running
                if isSuccess {
                    self.resetResultLabels()
                }
                self.serviceStatusLabel.text = "service : \(isSuccess ? "STOPPED" : "STOP FAIL")"
            }
        })
    }
}
