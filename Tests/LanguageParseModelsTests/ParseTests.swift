//
//  ParseTests.swift
//  
//
//  Created by Dabeluchi Ndubisi on 2019-07-22.
//

import XCTest
@testable import LanguageParseModels

final class ParseTests: XCTestCase {
    func testAddingRightTransitionDependency() throws {
        var parse = Parse(n: 2)
        
        let token = Token(i: 1, sentenceRange: "1 2".range(of: "2")!, posTag: .number)
        try parse.add(dependency: Dependency(head: 0, relationship: .acl), to: token)
        
        XCTAssertNotNil(parse.heads[token.i])
        XCTAssertEqual(parse.heads[token.i]!.head, 0)
        XCTAssertTrue(parse.rights[0].contains(token))
    }
    
    func testAddingLeftTransitionDependency() throws {
        var parse = Parse(n: 2)
        
        let token = Token(i: 0, sentenceRange: "1 2".range(of: "2")!, posTag: .number)
        try parse.add(dependency: Dependency(head: 1, relationship: .acl), to: token)
        
        XCTAssertNotNil(parse.heads[token.i])
        XCTAssertEqual(parse.heads[token.i]!.head, 1)
        XCTAssertTrue(parse.lefts[1].contains(token))
    }
}
