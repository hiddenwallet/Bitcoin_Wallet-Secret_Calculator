import Foundation

class OperatorButtonHandler: ButtonHandler {
    func handle(context: inout Context, tag: Int, ui: Internal) {
        context.leftOperand = ui.getDisplayValue()
        context.hasComma = false;
        ui.makeOrange(tag: AppConstants.KEY_DIVIDE)
        ui.makeOrange(tag: AppConstants.KEY_MULTIPLY)
        ui.makeOrange(tag: AppConstants.KEY_SUBTRACT)
        ui.makeOrange(tag: AppConstants.KEY_ADD)
        ui.makeWhite(tag: tag)
        context.operation = tag;
        context.performMath = true;
    }
}
