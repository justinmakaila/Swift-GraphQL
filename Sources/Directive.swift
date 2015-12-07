import Foundation

// MARK: - GraphQL.Directive Extensions

extension GraphQL.Directive: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "@\(name)\(renderArgumentsList(arguments))"
    }
    
    public var debugDescription: String {
        return "GraphQL.Directive(\(description))"
    }
}
