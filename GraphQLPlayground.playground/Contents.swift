import UIKit
import Foundation
import GraphQL

let userFields: [GraphQL.Field] = [
    "firstName",
    "lastName",
    "username",
    "email",
    "phone"
]

let updateUsernameMutation = GraphQL.Mutation(name: "updateUsername", arguments: ["id": 12345, "username": "justin"], fields: [
    GraphQL.Field(name: "user", fields: userFields)
])
print(updateUsernameMutation)


let friendsField = GraphQL.Field(name: "friends", arguments: ["first": 10], fields: userFields)
let mutualFriendsField = GraphQL.Field(name: "mutualFriends", arguments: ["first": 30], fields: userFields)
let currentUserField = GraphQL.Field(name: "user", arguments: ["id": 12], fields: [friendsField, mutualFriendsField])

let findFriendsQuery = GraphQL.Query(name: "findFriends", fields: [currentUserField])

print(findFriendsQuery)


