//
//  ParseTests+XCTest.swift
//  
//
//  Created by Dabeluchi Ndubisi on 2019-07-22.
//

import XCTest

extension ParseTests {
    static var allTests: [(String, (ParseTests) -> () throws -> Void)] {
        return [
            ("testAddingRightTransitionDependency", testAddingRightTransitionDependency),
            ("testAddingLeftTransitionDependency", testAddingLeftTransitionDependency)
        ]
    }
}
