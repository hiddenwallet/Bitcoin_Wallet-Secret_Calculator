import Foundation

class CommaButtonHandler: ButtonHandler {
    func handle(context: inout Context, tag: Int, ui: Internal) {
        if !context.hasComma{
            context.rightOperand += "."
            context.hasComma = true;
            ui.displayResult(string: context.rightOperand)
            
        } else{
            hapticError()
        }
        
    }
}

