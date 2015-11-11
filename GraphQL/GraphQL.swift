//
//  GraphQL.swift
//  GraphQL
//
//  Created by Justin Makaila on 11/6/15.
//  Copyright © 2015 justinmakaila. All rights reserved.
//

import Foundation

public protocol GraphQLQueryType {
    var queryString: String { get }
}

public struct GraphQL {
    public struct Document {
        public let operations: [GraphQLQueryType]
        
        init(operations: [GraphQLQueryType]) {
            self.operations = operations
        }
    }
    
    public struct Query {
        public let name: String
        public let arguments: [String: AnyObject]
        public let fields: [GraphQL.Field]
        
        public init(name: String, arguments: [String: AnyObject], fields: [GraphQL.Field]) {
            self.name = name
            self.arguments = arguments
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
}


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

extension GraphQL.Field: GraphQLQueryType, CustomStringConvertible, CustomDebugStringConvertible {
    public var queryString: String {
        return description
    }
    
    public var description: String {
        return "\(name)\(renderArgumentsList(arguments))\(renderSelectionSet(fields, aliases: aliases))"
    }
    
    public var debugDescription: String {
        return "GraphQL.Field(\(description))"
    }
}



// MARK: - GraphQL.Query Extensions

extension GraphQL.Query: GraphQLQueryType, CustomStringConvertible, CustomDebugStringConvertible {
    public var queryString: String {
        return description
    }
    
    public var description: String {
        return "query \(name)\(renderOperationArgumentsList(arguments))\(renderSelectionSet(fields))"
    }
    
    public var debugDescription: String {
        return "GraphQL.Query(\(description))"
    }
}



// MARK: - GraphQL.Mutation Extensions

extension GraphQL.Mutation: GraphQLQueryType, CustomStringConvertible, CustomDebugStringConvertible {
    public var queryString: String {
        return description
    }
    
    public var description: String {
        return "mutation \(name)\(renderOperationArgumentsList(arguments)) { \(name)\(renderParameterizedArgumentsList(arguments))\(renderSelectionSet(fields)) }"
    }
    
    public var debugDescription: String {
        return "GraphQL.Mutation(\(description))"
    }
}



// MARK: - String Rendering Helpers

func renderDocument(operations: [GraphQLQueryType]) -> String {
    let operationsList = operations.reduce([]) { value, operation in
        return value + ["\(operation)"]
    }
    
    if !operationsList.isEmpty {
        return "{ \(operationsList.joinWithSeparator("\n")) }"
    }
    
    return ""
}

func renderParameterizedArgumentsList(arguments: [String: AnyObject]) -> String {
    let argumentsList = arguments.reduce([String]()) { value, argument in
        return value + ["\(argument.0): $\(argument.0)"]
    }
    
    if !argumentsList.isEmpty {
        return "(\(argumentsList.joinWithSeparator(", ")))"
    }
    
    return ""
}

func renderOperationArgumentsList(arguments: [String: AnyObject]) -> String {
    let argumentsList = arguments.reduce([String]()) { value, argument in
        var typeName: String = ""
        switch argument.1 {
        case is String:
            typeName = "String!"
        case is Bool:
            typeName = "Bool!"
        case is Int:
            typeName = "Int!"
        case is Double:
            typeName = "Double!"
        case is Float:
            typeName = "Float!"
        default:
            assert(false, "Type is invalid!")
        }
        
        return value + ["$\(argument.0): \(typeName)"]
    }
    
    if !argumentsList.isEmpty {
        return "(\(argumentsList.joinWithSeparator(", ")))"
    }
    
    return ""
}

func renderArgumentsList(arguments: [String: AnyObject] = [:]) -> String {
    let argumentsList = arguments.reduce([]) { value, argument in
        return value + ["\(argument.0): \"\(argument.1)\""]
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
