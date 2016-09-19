import Foundation

// MARK: - GraphQL.Document Extensions

extension GraphQL.Document: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: GraphQLType...) {
        self.init(operations: elements)
    }
}

extension GraphQL.Document: CustomStringConvertible, CustomDebugStringConvertible {
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
