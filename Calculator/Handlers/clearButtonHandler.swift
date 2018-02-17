import Foundation

class ClearButtonHandler: ButtonHandler {
    func handle(context: inout Context, tag: Int, ui: Internal) {
        if context.isAC{
            context.leftOperand = ""
            context.operation = 0
            context.hasInput = false;
        } else{
            context.isAC = true;
            ui.changeClearButton(isAC: context.isAC)
        }
        ui.displayResult(string: "0")
        context.rightOperand = "0"
        context.hasComma = false;
        context.result = ""
        ui.makeOrange(tag: AppConstants.KEY_DIVIDE)
        ui.makeOrange(tag: AppConstants.KEY_MULTIPLY)
        ui.makeOrange(tag: AppConstants.KEY_SUBTRACT)
        ui.makeOrange(tag: AppConstants.KEY_ADD)

        
    }
    
}






