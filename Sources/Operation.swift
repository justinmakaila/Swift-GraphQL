import Foundation

// MARK: - GraphQL.Operation Extensions

extension GraphQL.Operation: GraphQLQueryType, CustomStringConvertible, CustomDebugStringConvertible {
    public var queryString: String {
        return description
    }
    
    public var description: String {
        let operationName = name.isEmpty ? "" : " \(name)"
        
        return "\(type)\(operationName)\(renderArgumentsList(arguments))\(renderSelectionSet(selectionSet))"
    }
    
    public var debugDescription: String {
        return "GraphQL.Operation(\(description))"
    }
}
