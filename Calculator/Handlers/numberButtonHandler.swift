import Foundation

class NumberButtonHandler: ButtonHandler {
    func handle(context: inout Context, tag: Int, ui: Internal) {
        if context.performMath == true{
            context.rightOperand = String(tag)
            ui.displayResult(string: context.rightOperand)
            ui.makeOrange(tag: context.operation)
            context.performMath = false
        }
        else {
            if context.isPercent{
                context.rightOperand = String(tag)
                context.isPercent = false
                ui.displayResult(string: context.rightOperand)
            } else{
                if context.rightOperand != "0"{
                    if context.operation == 0 {
                        context.rightOperand += String(tag)
                    } else {
                        context.rightOperand = context.rightOperand + String(tag)
                        
                    }
                    ui.displayResult(string: context.rightOperand)
                    
                } else{
                    if !context.hasInput{
                        context.isAC = false
                        ui.changeClearButton(isAC: context.isAC)
                        context.hasInput = true;
                    }
                    context.rightOperand = String(tag)
                    ui.displayResult(string: context.rightOperand)
                }
            }
            
        }
    }
}
