import Foundation

prefix operator ... {}
public prefix func ... (fragment: GraphQL.Fragment) -> GraphQL.Field {
    return GraphQL.Field(name: fragment.description)
}

// MARK: - GraphQL.InlineFragment Extensions

extension GraphQL.Fragment: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        let directive = self.directive != nil ? self.directive!.description : ""
        
        return "fragment \(name) on \(typeCondition)\(directive)\(renderSelectionSet(selectionSet))"
    }
    
    public var debugDescription: String {
        return "GraphQL.InlineFragment(\(description))"
    }
}