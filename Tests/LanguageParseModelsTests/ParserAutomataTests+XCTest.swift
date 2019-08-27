//
//  File.swift
//  
//
//  Created by Dabeluchi Ndubisi on 2019-07-22.
//

import XCTest

extension ParserAutomataTests {
    static var allTests: [(String, (ParserAutomataTests) -> () throws -> Void)] {
        return [
            ("testStackContainsRootTokenOnInit", testStackContainsRootTokenOnInit),
            ("testInitSetsUpParseToAccountForRootToken", testInitSetsUpParseToAccountForRootToken),
            ("testIsTerminalIsTrueIfStackContainsOnlyRootTokenAndBufferIsEmpty", testIsTerminalIsTrueIfStackContainsOnlyRootTokenAndBufferIsEmpty),
            ("testIsTerminalIsFalseIfBufferIsNotEmpty", testIsTerminalIsFalseIfBufferIsNotEmpty),
            ("testIsTerminalIsFalseIfStackContainsOtherElementsBesidesRootToken", testIsTerminalIsFalseIfStackContainsOtherElementsBesidesRootToken)
        ]
    }
}
