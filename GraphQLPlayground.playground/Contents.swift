/*:
# GraphQL Swift
*/

import UIKit
import Foundation

/*:
## GraphQLRenderer

Handles rendering of `GraphQLNode` and `GraphQLQuery` instances into `String`s.
*/
// TODO: This should handle pretty printing too!
struct GraphQLRenderer {
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

/*:
## Usage Examples

#### Node Usage

In this example, we're going to demonstrate how to use `GraphQLNode` retrieve some information on a parent.

First, we're creating a node to fetch a `profilePicture` with a `size` of 50. The returned data will include the
`uri` for the `profilePicture`, as well as its `width` and `height`
*/
let profilePictureNode = GraphQLNode(name: "profilePicture", arguments: ["size" : 50], properties: [
    "uri",
    "width",
    "height",
])

/*:
Next, we create an array of `GraphQLNode`'s to represent the data we want to retrieve about the parent.
*/
let parentProperties: [GraphQLNode] = [
    "id",
    "firstName",
    "lastName",
    "username",
    "email",
    "phone",
    profilePictureNode
]

/*:
Finally, we create an instance of `GraphQLNode` with the name set to the type of the object we want to retrieve, some parameters used by the server for fetching the correct document, and the properties that we'd like to have returned from the server.
*/
let parentNode = GraphQLNode(name: "parent", arguments: ["id" : 3500401], properties: parentProperties)

/*:
parent(id: 3500401) {
    id,
    firstName,
    lastName,
    username,
    email,
    phone,
    profilePicture(size: 50) {
        uri,
        width,
        height
    }
}
*/
print(parentNode)

/*:
To actually get the information from the server, execute the query

Response Example:
{
    id: 3500401,
    firstName: "Justin",
    lastName: "Makaila",
    username: "justinmakaila",
    email: "justin@tabtor.com",
    phone: "2155550000",
    profilePicture: {
        uri: "http://google.com",
        width: 50,
        height: 50
    }
}
*/

/*:
#### Query Usage
In this example, we're going to demonstrate how to use `GraphQLQuery` for powerful client specified queries.
More specifically, we're going to get the parents of two users. This example is a bit naiive, and assumes you know the parents names up front.

First, create two nodes to represent the parents:
*/
let parentNode1 = GraphQLNode(name: "parent", arguments: ["id": "555"], properties: parentProperties)
let parentNode2 = GraphQLNode(name: "parent", arguments: ["id": "666"], properties: parentProperties)

/*:
Next, create a `GraphQLQuery` with the name of "StudentParents". Populate `fields` with the nodes created above:
*/
let query: GraphQLQuery = GraphQLQuery(name: "StudentParents", fields: [
    "Michelle": parentNode1,
    "Mike": parentNode2
])

/*:
This will yield:

query StudentParents {
    Michelle: parent(id: 555) {
        id,
        firstName,  
        lastName,
        username,
        email,
        phone,
        profilePicture(size: 50) {
            uri,
            width,
            height
        }
    }
    Mike: parent(id: 666) {
        id,
        firstName,
        lastName,
        username,
        email,
        phone,
        profilePicture(size: 50) {
            uri,
            width,
            height
        }
    }
}
*/
print(query)
