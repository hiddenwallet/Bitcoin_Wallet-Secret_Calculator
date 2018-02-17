import Foundation

class PercentButtonHandler: ButtonHandler {
    func handle(context: inout Context, tag: Int, ui: Internal) {
        if context.isError{
            hapticError()
        } else {
            if context.result == ""{
                if context.rightOperand == "0"{
                    hapticError()
                } else {
                    context.rightOperand = String(Double(context.rightOperand)! / 100)
                    ui.displayResult(string: normalize(stringValue: context.rightOperand))
                    context.isPercent = true
                    hapticSuccess()
                }
            } else{
                if context.result == "0"{
                    hapticError()
                } else {
                    context.result  = String(Double(context.result)! / 100)
                    ui.displayResult(string: normalize(stringValue: context.result))
                    context.isPercent = true
                    hapticSuccess()
                }
                
            }
        }
    }
    
}
