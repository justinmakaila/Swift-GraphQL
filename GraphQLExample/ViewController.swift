//
//  ViewController.swift
//  GraphQLExample
//
//  Created by Justin Makaila on 11/9/15.
//  Copyright © 2015 justinmakaila. All rights reserved.
//

import UIKit
import GraphQL
import Alamofire

private let ExampleURL = NSURL(string: "http://localhost:3000/data")!
private let LukeSkywalkerUserId = "559645cd1a38532d14349246"

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUser(LukeSkywalkerUserId)
        //getUserNamedQuery(LukeSkywalkerUserId)
        //createUser("Justin")
    }
    
    func getUser(id: String) {
        /**
         user(id: "\(id)") {
            name
            friends {
                name
            } 
         }
        */
        let userQuery = GraphQL.Field(
            name: "user",
            arguments: [
                "id": id
            ],
            selectionSet: [
                "name",
                GraphQL.Field(
                    name: "friends",
                    selectionSet: [
                        "name"
                    ]
                )
            ]
        )

        let document = GraphQL.Document(arrayLiteral: userQuery)
        let request = requestForQuery(document)
        executeRequest(request)
    }
    
    func getUserNamedQuery(id: String) {
        let userQuery = GraphQL.Query(
            name: "getUser",
            arguments: [
                "id": id
            ],
            selectionSet: [
                GraphQL.Field(
                    name: "user",
                    arguments: [
                        "id": id
                    ],
                    selectionSet: [
                        "name"
                    ]
                )
            ])
        
        let request = requestForQuery(userQuery)
        executeRequest(request)
    }
    
    func createUser(name: String) {
        /*
        mutation createUser($name: String!) {
            createUser(name: $name) {
                name
                friends
                id
            }
        }
        */
        let createUserMutation = GraphQL.Mutation(
            name: "createUser",
            arguments: [
                "name": name
            ],
            selectionSet: [
                "name",
                "id",
            ]
        )
        
        print(createUserMutation)
        
        let request = requestForQuery(createUserMutation)
        executeRequest(request)
    }
}

private extension ViewController {
    func mutableURLRequest() -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: ExampleURL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 30)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func requestForQuery(query: GraphQLType, arguments: [String: AnyObject]? = nil) -> NSURLRequest {
        let request = mutableURLRequest()
        
        var parameters: [String: AnyObject] = [
            "query": query.queryString
        ]
        
        if let arguments = arguments {
            parameters["arguments"] = arguments
        }
        
        return Alamofire.ParameterEncoding.URL.encode(request, parameters: parameters).0
    }
    
    func executeRequest(request: NSURLRequest) {
        Alamofire.request(request)
            .responseJSON { response in
                if let json = response.result.value {
                    print(json)
                }
            }
    }
}
