import Foundation

// MARK: - GraphQL.Document Extensions

extension GraphQL.Document: ArrayLiteralConvertible {
    public init(arrayLiteral elements: GraphQLQueryType...) {
        self.init(operations: elements)
    }
}

extension GraphQL.Document: GraphQLQueryType, CustomStringConvertible, CustomDebugStringConvertible {
    public var queryString: String {
        return description
    }
    
    public var description: String {
        return renderDocument(operations)
    }
    
    public var debugDescription: String {
        return "GraphQL.Document(\(description))"
    }
}