import Foundation

private func GraphQLJSONString(arrayOrDictionary: AnyObject) -> String? {
    do {
        let data = try NSJSONSerialization.dataWithJSONObject(arrayOrDictionary, options: NSJSONWritingOptions())
        return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
    } catch {
        return nil
    }
}

// MARK: - String Rendering Helpers

internal func renderDocument(operations: [GraphQLQueryType]) -> String {
    let operationsList = operations.reduce([]) { $0 + [$1.queryString] }
    
    if !operationsList.isEmpty {
        return "{ \(operationsList.joinWithSeparator("\n")) }"
    }
    
    return ""
}

internal func renderArgumentsList(arguments: [String: AnyObject] = [:]) -> String {
    let argumentsList = arguments.reduce([String]()) { value, argument in
        let argumentKey = argument.0
        var argumentValue = argument.1
        
        switch argumentValue {
        case is NSArray:
            argumentValue = GraphQLJSONString(argumentValue) ?? "[]"
        case is NSDictionary:
            argumentValue = GraphQLJSONString(argumentValue) ?? "{}"
        case is NSString:
            // The argument value should only be wrapped if it's not prefixed by "$" (a variable).
            // TODO: This doesn't consider passing in the type. i.e. String! vs "String!"
            if argumentValue.substringToIndex(1) != "$" {
                argumentValue = "\"\(argumentValue)\""
            }
        case is GraphQL.InputValueType:
            argumentValue = "\((argumentValue as! GraphQL.InputValueType).description)"
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
