//
//  GraphQL.swift
//  GraphQL
//
//  Created by Justin Makaila on 11/6/15.
//  Copyright © 2015 justinmakaila. All rights reserved.
//

import Foundation

/*:
## GraphQLRenderer

Handles rendering of `GraphQLNode` and `GraphQLQuery` instances into `String`s.
*/
// TODO: This should handle pretty printing too!
private struct GraphQLRenderer {
    /**
        Renders a `GraphQLNode` to a String. Suitable to be passed to a GraphQL server
     */
    static func renderGraphQLNode(node: GraphQLNode) -> String {
        let indentationString = ""
        var queryString = ""
        
        queryString += indentationString
        
        if let name = node.name {
            queryString += name
        }
        
        if node.arguments.count > 0 {
            queryString += "("
            
            queryString += node.arguments.reduce([]) { value, argument in
                return value + ["\(argument.0): \(argument.1)"]
            }.joinWithSeparator(", ")
            
            queryString += ")"
        }
        
        if node.properties.count > 0 {
            queryString += "{"
            
            queryString += node.properties.reduce([]) { value, property in
                return value + ["\(property)"]
            }.joinWithSeparator(",")
            
            queryString += "}"
        }
        
        return queryString
    }

    /**
        Renders a `GraphQLQuery` to a String. Suitable to be passed to a GraphQL server
     */
    static func renderGraphQLQuery(query: GraphQLQuery) -> String {
        var queryString = "query \(query.name)"
        
        if query.fields.count > 0 {
            queryString += "{"
            
            queryString += query.fields.reduce([]) { value, property in
                return value + ["\(property.0): \(property.1)"]
            }.joinWithSeparator("")
            
            queryString += "}"
        }
        
        return queryString
    }
}

/*:
## GraphQLNode
Represents a node in a GraphQL query.
*/
struct GraphQLNode {
    let name: String?
    let arguments: [String: AnyObject]
    let properties: [GraphQLNode]
    
    var isRootNode: Bool {
        return name?.isEmpty ?? true
    }
    
    init(name: String, arguments: [String : AnyObject] = [:], properties: [GraphQLNode] = []) {
        for node in properties {
            assert(!node.isRootNode, "You cannot include a root node, or a node with an empty name as a child of another node.")
        }
        
        self.name = name
        self.arguments = arguments
        self.properties = properties
    }
}

extension GraphQLNode: StringLiteralConvertible {
    init(stringLiteral value: StringLiteralType) {
        self.init(name: value)
    }
    
    init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(name: value)
    }
    
    init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(name: value)
    }
}

extension GraphQLNode: ArrayLiteralConvertible {
    init(arrayLiteral elements: GraphQLNode...) {
        self.init(name: "", properties: elements)
    }
}

extension GraphQLNode: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return GraphQLRenderer.renderGraphQLNode(self)
    }
    
    var debugDescription: String {
        return "GraphQLNode(\(description))"
    }
}

/*:
## GraphQLQuery
Represents a query in a GraphQL query.
*/
struct GraphQLQuery {
    let name: String
    let fields: [String: GraphQLNode]
    
    init(name: String, fields: [String: GraphQLNode]) {
        self.name = name
        self.fields = fields
    }
}

extension GraphQLQuery: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return GraphQLRenderer.renderGraphQLQuery(self)
    }
    
    var debugDescription: String {
        return "GraphQLQuery(\(description))"
    }
}
