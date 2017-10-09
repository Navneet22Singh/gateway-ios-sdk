import UIKit
import MPGSDK

class PaymentViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var expiryMMField: UITextField!
    @IBOutlet weak var expiryYYField: UITextField!
    @IBOutlet weak var cvvField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    var loadingViewController: LoadingViewController!
    
    
    /// The session id provided from the previous view that we desire to update with a payment source.
    var sessionId: String?
    
    // MARK: - Gateway Setup
    // Plug your gateway url and merchant id to create an instance of the gateway interface
    var gateway: Gateway = try! Gateway(url: "<#https://your-gateway-url-com#>", merchantId: "<#your-merchant-id#>")

    // MARK: - Update the session
    // Call the gateway to update the session.
    func updateSession() {
        gateway.updateSession(sessionId!, nameOnCard: nameField.text!, cardNumber: numberField.text!, securityCode: cvvField.text!, expiryMM: expiryMMField.text!, expiryYY: expiryYYField.text!, completion: updateSessionHandler(_:))
    }
    
    // MARK: - Handle the Update Response
    // Call the gateway to update the session.
    fileprivate func updateSessionHandler(_ result: GatewayResult<UpdateSessionRequest.responseType>) {
        DispatchQueue.main.async {
            self.loadingViewController.dismiss(animated: true) {
                switch result {
                case .success(let response):
                    self.performSegue(withIdentifier: "showConfirmation", sender: nil)
                case .error(_):
                    self.showError()
                }
            }
        }
    }
    
    // MARK: - Sample View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingViewController = storyboard!.instantiateViewController(withIdentifier: "loading") as! LoadingViewController
        loadingViewController.localizedTitle = "Please Wait"
        loadingViewController.localizedDescription = "updating session with payment information"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        startAvoidingKeyboard()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopAvoidingKeyboard()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            numberField.becomeFirstResponder()
        case numberField:
            expiryMMField.becomeFirstResponder()
        case expiryMMField:
            expiryYYField.becomeFirstResponder()
        case expiryYYField:
            cvvField.becomeFirstResponder()
        case cvvField:
            cvvField.resignFirstResponder()
            continueAction(textField)
        default:
            return false
        }
        return true
    }
    
    @IBAction func continueAction(_ sender: Any) {
        present(loadingViewController, animated: true) {
            self.updateSession()
        }
    }
    
    fileprivate func showError() {
        let alert = UIAlertController(title: "Error", message: "Unable to update session.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ConfirmationViewController {
            destination.sessionId = sessionId
            destination.maskedPan = maskPan()
        }
    }
    
    fileprivate func maskPan() -> String? {
        guard let number = numberField.text else { return nil }
        let visibleLength = number.count > 8 ? 4 : 0
        let maskLength = number.count - visibleLength
        return String(repeating: "•", count: maskLength) + number.suffix(visibleLength)
    }
    
    
}
