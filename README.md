# Swift-GraphQL
GraphQL implementation written in Swift

```
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
```
