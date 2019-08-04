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
        let tokens = [Token(i: 0, sentenceRange: "1 2".range(of: "1")!, posTag: .number), Token(i: 1, sentenceRange: "1 2".range(of: "2")!, posTag: .number)]
        var parse = Parse(tokens: tokens)
        
        let token = tokens[1]
        try parse.add(dependency: Dependency(head: 0, relationship: .acl), to: token)
        
        XCTAssertNotNil(parse.heads[token.i])
        XCTAssertEqual(parse.heads[token.i]!.head, 0)
        XCTAssertTrue(parse.rights[0].contains(token))
    }
    
    func testAddingLeftTransitionDependency() throws {
        let tokens = [Token(i: 0, sentenceRange: "1 2".range(of: "1")!, posTag: .number), Token(i: 1, sentenceRange: "1 2".range(of: "2")!, posTag: .number)]
        var parse = Parse(tokens: tokens)
        
        let token = tokens[0]
        try parse.add(dependency: Dependency(head: 1, relationship: .acl), to: token)
        
        XCTAssertNotNil(parse.heads[token.i])
        XCTAssertEqual(parse.heads[token.i]!.head, 1)
        XCTAssertTrue(parse.lefts[1].contains(token))
    }
}
