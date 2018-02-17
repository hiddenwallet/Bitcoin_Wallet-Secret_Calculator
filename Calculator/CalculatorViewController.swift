import UIKit

class CalculatorViewController: UIViewController,Internal {
    
    var context = Context();
    
    @IBOutlet weak var numbersDisplay: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    
    var newPassword = false
    
    var numberButtonHandler = NumberButtonHandler();
    var operatorButtonHandler = OperatorButtonHandler();
    var equalButtonHandler = EqualButtonHandler();
    var clearButtonHandler = ClearButtonHandler();
    var plusMinusButtonHandler = PlusMinusButtonHandler();
    var percentButtonHandler = PercentButtonHandler();
    var commaButtonHandler = CommaButtonHandler();
    
    var handlers: Dictionary = [Int: ButtonHandler]()

    
    @IBAction func numbersButton(_ sender: UIButton){
        let tag = sender.tag <= 10 ? sender.tag-1 : sender.tag
        
//        print(sender.tag)
        let handler = handlers[tag]
        handler?.handle(context: &context, tag: tag, ui: self)
        
    }

    @IBOutlet weak var divideButton: roundButton!
    @IBOutlet weak var multiplyButton: roundButton!
    @IBOutlet weak var subtractButton: roundButton!
    @IBOutlet weak var addButton: roundButton!
    @IBOutlet weak var clearButton: roundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numbersDisplay.numberOfLines = 1
        
        numbersDisplay.adjustsFontSizeToFitWidth = true
        
        numbersDisplay.minimumScaleFactor = 0.65
        
        context.rightOperand = "0";
        
        instructionLabel.text = NSLocalizedString("Calculator.setPin", value:"Enter new passcode and tap \"+/-\"", comment: "1 of 3")
        
        handlers[AppConstants.KEY_ZERO] = numberButtonHandler
        handlers[AppConstants.KEY_ONE] = numberButtonHandler
        handlers[AppConstants.KEY_TWO] = numberButtonHandler
        handlers[AppConstants.KEY_THREE] = numberButtonHandler
        handlers[AppConstants.KEY_FOUR] = numberButtonHandler
        handlers[AppConstants.KEY_FIVE] = numberButtonHandler
        handlers[AppConstants.KEY_SIX] = numberButtonHandler
        handlers[AppConstants.KEY_SEVEN] = numberButtonHandler
        handlers[AppConstants.KEY_EIGHT] = numberButtonHandler
        handlers[AppConstants.KEY_NINE] = numberButtonHandler
        handlers[AppConstants.KEY_AC] = clearButtonHandler
        handlers[AppConstants.KEY_PLUSMINUS] = plusMinusButtonHandler
        handlers[AppConstants.KEY_PERCENT] = percentButtonHandler
        handlers[AppConstants.KEY_DIVIDE] = operatorButtonHandler
        handlers[AppConstants.KEY_MULTIPLY] = operatorButtonHandler
        handlers[AppConstants.KEY_SUBTRACT] = operatorButtonHandler
        handlers[AppConstants.KEY_ADD] = operatorButtonHandler
        handlers[AppConstants.KEY_EQUAL] = equalButtonHandler
        handlers[AppConstants.KEY_COMMA] = commaButtonHandler
        
        
         do {
            let pass: String? = try keychainItem(key: "pin")
            if pass?.count == 6 {
                instructionLabel.isHidden = true
            }
        }catch {  }
        
        if newPassword{
            instructionLabel.text = "Insert old pin then press +/- button"
            instructionLabel.isHidden = false
        }
        
    }
    
    private func keychainItem<T>(key: String) throws -> T? {
        let query = [kSecClass as String : kSecClassGenericPassword as String,
                     kSecAttrService as String : "org.voisine.breadwallet",
                     kSecAttrAccount as String : key,
                     kSecReturnData as String : true as Any]
        var result: CFTypeRef? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &result);
        guard status == noErr || status == errSecItemNotFound else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status))
        }
        guard let data = result as? Data else { return nil }
        
        switch T.self {
        case is Data.Type:
            return data as? T
        case is String.Type:
            return CFStringCreateFromExternalRepresentation(secureAllocator, data as CFData,
                                                            CFStringBuiltInEncodings.UTF8.rawValue) as? T
        case is Int64.Type:
            guard data.count == MemoryLayout<T>.stride else { return nil }
            return data.withUnsafeBytes { $0.pointee }
        case is Dictionary<AnyHashable, Any>.Type:
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? T
        default:
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(errSecParam))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayResult(string: String) {
        numbersDisplay.text = string
    }
    
    func passwordSuccess() {
        if newPassword{
            newPassword = false
          //  instructionLabel.text = "Make a 6 character pin then press +/- button"
            
            instructionLabel.text = NSLocalizedString("Calculator.setPin", value:"Enter new passcode and tap \"+/-\"", comment: "1 of 3")
            UserDefaults.standard.removeObject(forKey: "password")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.context.leftOperand = ""
                self.context.operation = 0
                self.context.hasInput = false;
                self.displayResult(string: "0")
                self.context.rightOperand = "0"
                self.context.hasComma = false;
                self.context.result = ""
                self.makeOrange(tag: AppConstants.KEY_DIVIDE)
                self.makeOrange(tag: AppConstants.KEY_MULTIPLY)
                self.makeOrange(tag: AppConstants.KEY_SUBTRACT)
                self.makeOrange(tag: AppConstants.KEY_ADD)
            }
            
           // self.dismiss(animated: true, completion: {
           //     let appdelegate = UIApplication.shared.delegate as! AppDelegate
           //     appdelegate.lockWallet()
           // })
            return
        }
        
        UIApplication.shared.keyWindow?.rootViewController = nil
        UIApplication.shared.keyWindow?.isHidden = true
        self.dismiss(animated: true, completion: nil)
        print("password success")
    }
    
    func changeClearButton(isAC: Bool){
        let buttonText = isAC ? "AC" : "C"
        clearButton.setTitle(buttonText, for: .normal)
    }
    
    func makeOrange(tag: Int) {
        switch tag {
        case AppConstants.KEY_DIVIDE:
            breadwallet.makeOrange(button: divideButton)
        case AppConstants.KEY_MULTIPLY:
            breadwallet.makeOrange(button: multiplyButton)
        case AppConstants.KEY_SUBTRACT:
            breadwallet.makeOrange(button: subtractButton)
        case AppConstants.KEY_ADD:
            breadwallet.makeOrange(button: addButton)
        default: ()
        }
    }
    
    func makeWhite(tag: Int) {
        switch tag {
        case AppConstants.KEY_DIVIDE:
            breadwallet.makeWhite(button: divideButton)
        case AppConstants.KEY_MULTIPLY:
            breadwallet.makeWhite(button: multiplyButton)
        case AppConstants.KEY_SUBTRACT:
            breadwallet.makeWhite(button: subtractButton)
        case AppConstants.KEY_ADD:
            breadwallet.makeWhite(button: addButton)
        default: ()
        }
    }
    
    func getDisplayValue() -> String{
        return numbersDisplay.text!
    }
    
    
}

func hapticSuccess() {
    let feedbackGenerator = UINotificationFeedbackGenerator()
    feedbackGenerator.notificationOccurred(.success)
}

func hapticError() {
    let feedbackGenerator = UINotificationFeedbackGenerator()
    feedbackGenerator.notificationOccurred(.error)
}

func makeOrange(button: UIButton){
  //  button.backgroundColor = UIColor(red: 1, green: 136/255, blue: 2/255, alpha: 1)
    button.alpha = 1.0
    button.setTitleColor(UIColor.white, for: .normal)
}

func makeWhite(button: UIButton){
  //  button.backgroundColor = UIColor.white
    button.alpha = 0.5
    button.setTitleColor(.black, for: .normal)
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
