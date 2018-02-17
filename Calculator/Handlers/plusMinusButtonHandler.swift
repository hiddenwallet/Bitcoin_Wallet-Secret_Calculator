import Foundation
import UIKit

class PlusMinusButtonHandler: ButtonHandler {
    func handle(context: inout Context, tag: Int, ui: Internal) {
        if context.result == "Feil"{
            hapticError()
        } else {
            
            do {
                let pass: String? = try keychainItem(key: "pin")
                
                if pass == nil {
                    if context.rightOperand.count == 6{
                        do {
                            try setKeychainItem(key: "pin", item: context.rightOperand)
                        }catch {}
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let walletManager = appDelegate.applicationController.walletManager
                        
                        guard (walletManager?.authenticate(pin: context.rightOperand))! else { return }
                        
                        ui.passwordSuccess()
                    }
                }else if context.rightOperand == pass{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let walletManager = appDelegate.applicationController.walletManager
                    
                    guard (walletManager?.authenticate(pin: context.rightOperand))! else { return }
                    ui.passwordSuccess()
                }
            }catch {
                if context.rightOperand.count == 6{
                    do {
                        try setKeychainItem(key: "pin", item: context.rightOperand)
                    }catch {}
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let walletManager = appDelegate.applicationController.walletManager
                    
                    guard (walletManager?.authenticate(pin: context.rightOperand))! else { return }
                    ui.passwordSuccess()
                }
            }
            
            
            if context.rightOperand == "0"{
                hapticError()
            } else{
                context.rightOperand = String(Double(context.rightOperand)! * -1)
                ui.displayResult(string: normalize(stringValue: context.rightOperand))
                hapticSuccess()
            }
            
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
    private func setKeychainItem<T>(key: String, item: T?, authenticated: Bool = false) throws {
        let accessible = (authenticated) ? kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String
            : kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String
        let query = [kSecClass as String : kSecClassGenericPassword as String,
                     kSecAttrService as String : "org.voisine.breadwallet",
                     kSecAttrAccount as String : key]
        var status = noErr
        var data: Data? = nil
        if let item = item {
            switch T.self {
            case is Data.Type:
                data = item as? Data
            case is String.Type:
                data = CFStringCreateExternalRepresentation(secureAllocator, item as! CFString,
                                                            CFStringBuiltInEncodings.UTF8.rawValue, 0) as Data
            case is Int64.Type:
                data = CFDataCreateMutable(secureAllocator, MemoryLayout<T>.stride) as Data
                [item].withUnsafeBufferPointer { data?.append($0) }
            case is Dictionary<AnyHashable, Any>.Type:
                data = NSKeyedArchiver.archivedData(withRootObject: item)
            default:
                throw NSError(domain: NSOSStatusErrorDomain, code: Int(errSecParam))
            }
        }
        
        if data == nil { // delete item
            if SecItemCopyMatching(query as CFDictionary, nil) != errSecItemNotFound {
                status = SecItemDelete(query as CFDictionary)
            }
        }
        else if SecItemCopyMatching(query as CFDictionary, nil) != errSecItemNotFound { // update existing item
            let update = [kSecAttrAccessible as String : accessible,
                          kSecValueData as String : data as Any]
            status = SecItemUpdate(query as CFDictionary, update as CFDictionary)
        }
        else { // add new item
            let item = [kSecClass as String : kSecClassGenericPassword as String,
                        kSecAttrService as String : "org.voisine.breadwallet",
                        kSecAttrAccount as String : key,
                        kSecAttrAccessible as String : accessible,
                        kSecValueData as String : data as Any]
            status = SecItemAdd(item as CFDictionary, nil)
        }
        
        guard status == noErr else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status))
        }
    }
    
}
