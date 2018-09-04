import Foundation
import UIKit
import PlaygroundSupport

class ViewController: UIViewController {

    // MARK: - Properties
    
    let rect = CGRect(x: 170, y: 300, width: 50, height: 50)
    lazy var customView = UIView(frame: rect)
    
    lazy var nextButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 140, y: 500, width: 110, height: 44))
        button.setTitle("Next Screen", for: .normal)
        button.backgroundColor = .lightGray
        
        button.addTarget(self, action: #selector(ViewController.handleNextViewController(_:)), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController loaded: " , #function)
        
        view.backgroundColor = .white
        title = "Root"
        
        // Custom view will initialized here, where the first time it was accessed
        customView.backgroundColor = .red
        
        view.addSubview(customView)
        
        // Next button UIButton controll will be lazyly created here for the first time
        view.addSubview(nextButton)
    }
    
    // MARK: - Actions
    
    @objc func handleNextViewController(_ button: UIButton) {
        let nextViewController = NextViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

class NextViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var label: UILabel = prepareMessage()
    
    // MARK: - Private methods
    
    private func prepareMessage() -> UILabel {
        let label = UILabel(frame: CGRect(x: 100, y: 300, width: 250, height: 56))
        label.text = "Hello Next View Controller!"
        label.textColor = .black
        label.alpha = 0.0
        
        // This method will be called each time the view controller is pushed and the setup for UILabel will be delayed
        print("NextViewController loaded: ", #function)
        
        return label
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("NextViewController loaded: ", #function)
        
        title = "Next View Controller"
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("NextViewController loaded: ", #function)

        // The view controller's viewDidLoad is called first, then the above print will be outputed to the console, and finally UILabel with the message will be created and animated
        view.addSubview(label)
        
        UIView.animate(withDuration: 2.0) {
            self.label.alpha = 1.0
        }
        
    }
}


let viewController = ViewController()
let navigation = UINavigationController(rootViewController: viewController)

PlaygroundPage.current.liveView = navigation
PlaygroundPage.current.needsIndefiniteExecution = true
