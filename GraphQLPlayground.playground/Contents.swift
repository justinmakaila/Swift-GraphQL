import UIKit
import Foundation
import GraphQL

/**
mutation {
    likeStory(storyId: 1234) {
        story {
            likeCount
        }
    }
}
*/
let likeStoryMutation = GraphQL.Operation(type: .Mutation, selectionSet: [
    GraphQL.Field(name: "likeStory", arguments: ["storyId": 1234], selectionSet: [
        GraphQL.Field(name: "story", selectionSet: [
            "likeCount"
        ])
    ])
])

print(likeStoryMutation)

/**
query getParent($id: String!) {
    parent(id: $id) {
        id
        firstName
        lastName
        email
        students {
            edges {
                node {
                    id
                    firstName
                    lastName
                    class {
                        name
                        description
                    }
                }
            }
        }
    }
}
*/
let getParentQuery: GraphQL.Operation = GraphQL.Operation(type: .Query, name: "getParent", arguments: ["id": GraphQL.InputValueType.StringValue(true).description], selectionSet: [
    GraphQL.Field(name: "parent", arguments: ["id": "$id"], selectionSet: [
        "id",
        "firstName",
        "lastName",
        "email",
        GraphQL.Field(name: "students", selectionSet: [
            GraphQL.Field(name: "edges", selectionSet: [
                GraphQL.Field(name: "node", selectionSet: [
                    "id",
                    "firstName",
                    "lastName",
                    GraphQL.Field(name: "class", selectionSet: [
                        "name",
                        "description"
                    ])
                ])
            ])
        ])
    ])
])

print(getParentQuery)


/**
query inlineFragmentTyping {
    profiles(handles: ["zuck", "cocacola"]) {
        handle
        ... on User {
            friends {
                count
            }
        }
        ... on Page {
            likers {
                count
            }
        }
    }
}
*/
let inlineFragmentTypingQuery: GraphQL.Operation = GraphQL.Operation(type: .Query, name: "inlineFragmentTyping", selectionSet: [
    GraphQL.Field(name: "profiles", arguments: ["handles": ["zuck", "cococola"]], selectionSet: [
        "handle"
    ], fragments: [
        GraphQL.InlineFragment(typeCondition: "User", selectionSet: [
            GraphQL.Field(name: "friends", selectionSet: [
                "count"
            ])
        ]),
        GraphQL.InlineFragment(typeCondition: "Page", selectionSet: [
            GraphQL.Field(name: "likers", selectionSet: [
                "count"
            ])
        ])
    ])
])

print(inlineFragmentTypingQuery)


/**
query inlineFragmentNoType($expandedInfo: Boolean) {
    user(handle: "zuck") {
        id
        name
        ... @include(if: $expandedInfo) {
            firstName
            lastName
            birthday
        }
    }
}
*/
let inlineFragmentNoTypeQuery: GraphQL.Operation = GraphQL.Operation(type: .Query, name: "inlineFragmentNoType", arguments: ["$expandedInfo": GraphQL.InputValueType.BooleanValue(false).description], selectionSet: [
    GraphQL.Field(name: "user", arguments: ["handle": "zuck"], selectionSet: [
        "id",
        "name",
    ], fragments: [
        GraphQL.InlineFragment(directive: GraphQL.Directive(name: "include", arguments: ["if": "$expandedInfo"]), selectionSet: [
            "firstName",
            "lastName",
            "birthday"
        ])
    ])
])

print(inlineFragmentNoTypeQuery)

/**
query lifetimeActivity($studentId: String!) {
    student(id: $studentId) {
        lifetimeActivity: activity {
            totalDuration
            questionsAttempted
            correctQuestionsAttempted
        }
    }
}
*/
let lifetimeActivityQuery: GraphQL.Operation = GraphQL.Operation(type: .Query, name: "lifetimeActivity", arguments: ["$studentId": GraphQL.InputValueType.StringValue(true).description], selectionSet: [
    GraphQL.Field(name: "student", arguments: ["id": "$studentId"], selectionSet: [
        GraphQL.Field(alias: "lifetimeActivity", name: "activity", selectionSet: [
            "totalDuration",
            "questionsAttempted",
            "correctQuestionsAttempted"
        ])
    ])
])

print(lifetimeActivityQuery)

/**
node(id: "someIdString") {
    ... on Student {
        firstName
        lastName
    }
}
*/
let nodeField = GraphQL.Field(name: "node", arguments: ["id": "someIdString"], fragments: [
    GraphQL.InlineFragment(typeCondition: "Student", selectionSet: [
        "firstName",
        "lastName"
    ])
])

print(nodeField)
