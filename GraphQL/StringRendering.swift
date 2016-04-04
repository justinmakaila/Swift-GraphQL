import Foundation

//private func arrayToGraphQLListString(array: NSArray) -> String {
//    let arrayContents = array.reduce([String](), combine: <#T##(T, AnyObject) throws -> T#>)
//}
//
//private func dictionaryToGraphQLObjectString(dictionary: NSDictionary) -> String {
//    let keyValueStrings = dictionary.reduce([], combine: { (array, keyValue) in
//        return array
//    })
//    
//    print(keyValueStrings)
//}

// MARK: - String Rendering Helpers

internal func renderDocument(operations: [GraphQLType]) -> String {
    let operationsList = operations.reduce([]) { $0 + [$1.queryString] }
    
    if !operationsList.isEmpty {
        return "{ \(operationsList.joinWithSeparator("\n")) }"
    }
    
    return ""
}

internal func renderOperationArgumentsList(arguments: [String: AnyObject]) -> String {
    let argumentsList = arguments.reduce([String]()) { $0 + ["\($1.0): \($1.1)"] }
    
    if !argumentsList.isEmpty {
        return "(\(argumentsList.joinWithSeparator(", ")))"
    }
    
    return ""
}

internal func renderArgumentsList(arguments: [String: AnyObject] = [:]) -> String {
    // TODO: If `argument.1` is an array, wrap it in square brackets.
    // TODO: If `argument.1` is a dictionary, wrap it in curly brackets.
    let argumentsList = arguments.reduce([String]()) { value, argument in
        let argumentKey = argument.0
        var argumentValue = argument.1
        
        switch argumentValue {
        case is NSArray:
            print("Value is array. Convert to ListString")
            // argumentValue = arrayToGraphQLListString(argumentValue as! NSArray)
        case is NSDictionary:
            print("Value is dictionary. Convert to ObjectString")
            //argumentValue = dictionaryToGraphQLObjectString(argumentValue as! NSDictionary)
        case is NSString:
            // The argument value should only be set if it's not a variable.
            if argumentValue.substringToIndex(1) != "$" {
                argumentValue = "\"\(argumentValue)\""
            }
        default:
            break
        }
        
        return value + ["\(argumentKey): \(argumentValue)"]
    }
    
    if !argumentsList.isEmpty {
        return "(\(argumentsList.joinWithSeparator(", ")))"
    }
    
    return ""
}

internal func renderSelectionSet(selectionSet: GraphQL.SelectionSet = [], fragments: [GraphQL.InlineFragment] = []) -> String {
    let fieldsList = selectionSet.reduce([]) { $0 + [$1.description] }
    let fragmentsList = fragments.reduce([]) { $0 + [$1.description] }
    
    if !fieldsList.isEmpty || !fragmentsList.isEmpty {
        let selectionList = fieldsList + fragmentsList
        let selectionSet = selectionList.joinWithSeparator(" ")
        return " { \(selectionSet) }"
    }
    
    return ""
}
