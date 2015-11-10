//
//  GraphQL.swift
//  GraphQL
//
//  Created by Justin Makaila on 11/6/15.
//  Copyright © 2015 justinmakaila. All rights reserved.
//

import Foundation

public struct GraphQL {
    public struct Field {
        public let name: String
        public let arguments: [String: AnyObject]
        
        public let fields: [GraphQL.Field]
        public let aliases: [String: GraphQL.Field]
        
        var isRootNode: Bool {
            return name.isEmpty
        }

        public init(name: String, arguments: [String: AnyObject] = [:], fields: [GraphQL.Field] = [], aliases: [String: GraphQL.Field] = [:]) {
            for field in fields {
                assert(!field.isRootNode, "You cannot add a root field as a child of another field")
            }
            
            self.name = name
            self.arguments = arguments
            self.fields = fields
            self.aliases = aliases
        }
    }
    
    public struct Query {
        public let name: String
        public let fields: [GraphQL.Field]
        
        public init(name: String, fields: [GraphQL.Field]) {
            self.name = name
            self.fields = fields
        }
    }
    
    public struct Mutation {
        public let name: String
        public let arguments: [String: AnyObject]
        public let fields: [GraphQL.Field]
        
        public init(name: String, arguments: [String: AnyObject] = [:], fields: [GraphQL.Field]) {
            self.name = name
            self.arguments = arguments
            self.fields = fields
        }
    }
}



// MARK - GraphQL.Node Extensions

extension GraphQL.Field: StringLiteralConvertible {
    public init(stringLiteral value: StringLiteralType) {
        self.init(name: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(name: value)
    }
    
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(name: value)
    }
}

// ???: Should this whole idea be moved to a separate object? Perhaps GraphQL.Document to encapsulate the fact that a `Document` is a container of fields?
// It would eliminate the `isRootNode` assertion in the field initializer, and complete the idea that you can't have a field with no name in a `Query` or `Mutation`
extension GraphQL.Field: ArrayLiteralConvertible {
    public init(arrayLiteral elements: GraphQL.Field...) {
        self.init(name: "", fields: elements)
    }
}

extension GraphQL.Field: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "\(name)\(renderArgumentsList(arguments))\(renderSelectionSet(fields, aliases: aliases))"
    }
    
    public var debugDescription: String {
        return "GraphQL.Field(\(description))"
    }
}



// MARK: - GraphQL.Query Extensions

extension GraphQL.Query: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "query \(name) \(renderSelectionSet(fields))"
    }
    
    public var debugDescription: String {
        return "GraphQL.Query(\(description))"
    }
}



// MARK: - GraphQL.Mutation Extensions

extension GraphQL.Mutation: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "mutation \(name)\(renderArgumentsList(arguments))\(renderSelectionSet(fields))"
    }
    
    public var debugDescription: String {
        return "GraphQL.Mutation(\(description))"
    }
}



// MARK: - String Rendering Helpers

func renderArgumentsList(arguments: [String: AnyObject] = [:]) -> String {
    let argumentsList = arguments.reduce([]) { value, argument in
        return value + ["\(argument.0): \(argument.1)"]
    }
    
    if !argumentsList.isEmpty {
        return "(\(argumentsList.joinWithSeparator(", ")))"
    }
    
    return ""
}

func renderSelectionSet(fields: [GraphQL.Field] = [], aliases: [String: GraphQL.Field] = [:]) -> String {
    let fieldsList = fields.reduce([]) { value, field in
        return value + ["\(field)"]
    }
    
    let aliasList = aliases.reduce([]) { value, alias in
        return value + ["\(alias.0): \(alias.1)"]
    }
    
    if !fieldsList.isEmpty || !aliasList.isEmpty {
        let selectionList = fieldsList + aliasList
        let selectionSet = selectionList.joinWithSeparator(" ")
        return " { \(selectionSet) }"
    }
    
    return ""
}
