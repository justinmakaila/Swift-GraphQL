import Foundation

// MARK: - GraphQL.InlineFragment Extensions

extension GraphQL.Fragment: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "fragment \(name) on \(self.typeCondition) \(renderSelectionSet(selectionSet))"
    }
    
    public var debugDescription: String {
        return "GraphQL.InlineFragment(\(description))"
    }
}