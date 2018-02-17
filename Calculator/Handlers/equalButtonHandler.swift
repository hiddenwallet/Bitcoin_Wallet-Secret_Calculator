import Foundation


class EqualButtonHandler: ButtonHandler {
    func handle(context: inout Context, tag: Int, ui: Internal) {
        ui.makeOrange(tag: AppConstants.KEY_DIVIDE)
        ui.makeOrange(tag: AppConstants.KEY_MULTIPLY)
        ui.makeOrange(tag: AppConstants.KEY_SUBTRACT)
        ui.makeOrange(tag: AppConstants.KEY_ADD)
        
        if context.leftOperand != ""{
            if context.operation == AppConstants.KEY_DIVIDE{
                if context.rightOperand == "0" || context.isError{
                    context.isError = true
                    hapticError()
                } else {
                    context.result = String(Double(context.leftOperand)! / Double(context.rightOperand)!)
                    hapticSuccess()
                }
            } else if context.operation == AppConstants.KEY_MULTIPLY{
                if context.isError{
                    hapticError()
                } else {
                    context.result = String(Double(context.leftOperand)! * Double(context.rightOperand)!)
                    hapticSuccess()
                }
                
            } else if context.operation == AppConstants.KEY_SUBTRACT{
                if context.isError{
                    hapticError()
                } else {
                    context.result = String(Double(context.leftOperand)! - Double(context.rightOperand)!)
                    hapticSuccess()
                }
                
            } else if context.operation == AppConstants.KEY_ADD{
                if context.isError{
                    hapticError()
                } else {
                    context.result = String(Double(context.leftOperand)! + Double(context.rightOperand)!)
                    hapticSuccess()
                }
            }
            if !context.isError{
                let roundedResult = Double(context.result)?.rounded(toPlaces: 6)
                context.result = normalize(stringValue: String(roundedResult!))
                context.leftOperand = context.result
            }
            context.rightOperand = "0";
        } else if context.leftOperand == ""{
            context.result = context.rightOperand
            hapticSuccess()
        }
        if context.isError{
            ui.displayResult(string: "Feil")
        } else{
            ui.displayResult(string: context.result)
        }
        context.hasComma = context.result.contains(".") ? true : false
    }
    
}
