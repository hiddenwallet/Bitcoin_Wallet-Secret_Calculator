import Foundation


struct Context{
    
    var rightOperand = ""
    var leftOperand = ""
    var performMath = false;
    var operation = 0;
    var result = ""
    var isError = false;
    var isAC = true;
    var hasInput = false;
    var hasComma = false;
    var isPercent = false
    
    mutating func reset(){
        rightOperand = ""
        leftOperand = ""
        performMath = false;
        operation = 0;
        result = ""
        isError = false;
    }
}
