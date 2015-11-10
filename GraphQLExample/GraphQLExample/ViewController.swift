//
//  ViewController.swift
//  GraphQLExample
//
//  Created by Justin Makaila on 11/9/15.
//  Copyright © 2015 justinmakaila. All rights reserved.
//

import UIKit
import GraphQL

private let CurrentTeacherId = "someTeacherId"
private let AddStudentId = "someStudentId"

private let TabtorURL = NSURL(string: "tapi.tabtor.com/graphql")!

private let StudentFields: [GraphQL.Field] = [
    "firstName",
    "lastName",
    "id"
]

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        getClass()
        addStudent()
    }

    func getClass() {
        let classQuery = GraphQL.Query(
            name: "currentClass",
            fields:[
                GraphQL.Field(
                    name: "class",
                    arguments: [
                        "teacherId": CurrentTeacherId
                    ],
                    fields: [
                        GraphQL.Field(
                            name: "students",
                            fields: StudentFields
                        )
                    ]
                )
            ]
        )
        
        debugPrint(classQuery)
        
        let request = NSMutableURLRequest(URL: TabtorURL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 30)
        request.HTTPBody = classQuery.description.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    func addStudent() {
        let addStudentMutation = GraphQL.Mutation(
            name: "addStudent",
            arguments: [
                "studentId": AddStudentId
            ],
            fields: [
                GraphQL.Field(
                    name: "student",
                    fields: StudentFields
                )
            ]
        )
        
        debugPrint(addStudentMutation)
    }

}

