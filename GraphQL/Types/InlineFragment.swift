import Foundation

// MARK: - GraphQL.InlineFragment Extensions

extension GraphQL.InlineFragment: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        let typeCondition = (self.typeCondition != nil) ? "on \(self.typeCondition!)" : ""
        let directive = (self.directive != nil) ? " \(self.directive!.description)" : ""
        
        return "... \(typeCondition)\(directive)\(renderSelectionSet(selectionSet))"
    }
    
    public var debugDescription: String {
        return "GraphQL.InlineFragment(\(description))"
    }
}