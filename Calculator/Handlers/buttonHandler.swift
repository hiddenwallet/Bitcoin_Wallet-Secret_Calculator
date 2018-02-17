import Foundation

protocol ButtonHandler {
    func handle(context: inout Context, tag: Int, ui: Internal)
}

