import Foundation

// MARK: - GraphQL.Operation Extensions

extension GraphQLOperation {
    public var queryString: String {
        return description
    }
    
    public var description: String {
        let operationName = name.isEmpty ? "" : " \(name)"
        
        return "\(type)\(operationName)\(renderOperationArgumentsList(arguments))\(renderSelectionSet(selectionSet))"
    }
    
    public var debugDescription: String {
        switch type {
        case .mutation:
            return "GraphQL.Mutation(\(description))"
        case .query:
            return "GraphQL.Query(\(description))"
        }
    }
}
