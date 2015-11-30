@testable import GraphQL
import Quick
import Nimble

class GraphQLSpec: QuickSpec {
    override func spec() {
        describe("GraphQL") {
            describe("a field") {
                var rootField: GraphQL.Field!
                var subField: GraphQL.Field!
                var literalStringField: GraphQL.Field!
                var literalArrayField: GraphQL.Field!

                beforeEach {
                    literalStringField = "width"
                    
                    literalArrayField = [
                        "width",
                        "height"
                    ]
                    
                    subField = GraphQL.Field(name: "profilePicture", fields: [
                        "width",
                        "height"
                    ])
                    
                    let userField = GraphQL.Field(name: "user", arguments: ["id": 12345], fields: [
                        "firstName",
                        "lastName",
                        "username",
                        subField
                    ])
                    
                    rootField = [userField]
                }
                
                it("can be named") {
                    // root fields do not have names
                    expect(rootField.name).to(beNil())
                    expect(literalArrayField.name).to(beNil())
                    
                    expect(subField.name).to(equal("profilePicture"))
                    expect(literalStringField.name).to(equal("width"))
                }
                
                // A node is considered a "root" if it is not named
                it("can indicate if it's the root node") {
                    expect(rootField.isRootNode).to(equal(true))
                    expect(literalArrayField.isRootNode).to(equal(true))
                    
                    expect(subField.isRootNode).to(equal(false))
                    expect(literalStringField.isRootNode).to(equal(false))
                }
                
                it("can be serialized into a string suitable for submission to a GraphQL server") {
                    let rootFieldDescriptionTrimmed = rootField.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    
                    expect(rootFieldDescriptionTrimmed).to(equal("{ user(id:12345) { firstName lastName username profilePicture { width height } } }"))
                }
            }
            
            describe("a query") {
                var query: GraphQL.Query!
                
                beforeEach {
                    let userFields: [GraphQL.Field] = [
                        "firstName",
                        "lastName",
                        "username"
                    ]
                    
                    let friendsField = GraphQL.Field(name: "friends", arguments: ["first": 10], fields: userFields)
                    let mutualFriendsField = GraphQL.Field(name: "mutualFriends", arguments: ["first": 30], fields: userFields)
                    let userField = GraphQL.Field(name: "user", arguments: ["id": 12], fields: [friendsField, mutualFriendsField])
                    
                    query = GraphQL.Query(name: "findFriends", fields: [userField])
                }
                
                it("must be named") {
                    expect(query.name).toNot(beNil())
                }
                
                it("can be serialized into a string suitable for submission to a GraphQL server") {
                    let queryDescriptionTrimmed = query.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    
                    expect(queryDescriptionTrimmed).to(equal("query findFriends { user(id:12) { friends(first:10) { firstName lastName username }  mutualFriends(first:30) { firstName lastName username } } }"))
                }
            }
        }
    }
}