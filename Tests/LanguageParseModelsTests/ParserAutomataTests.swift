//
//  ParserAutomataTests.swift
//  
//
//  Created by Dabeluchi Ndubisi on 2019-07-22.
//

import XCTest
import NaturalLanguage
@testable import LanguageParseModels

final class ParserAutomataTests: XCTestCase {
    var automata: ParserAutomata!
    
    override func setUp() {
        super.setUp()
        
        automata = ParserAutomata(rootToken: Token(i: 0, sentenceRange: "<ROOT>".range(of: "<ROOT>")!, lemma: "<ROOT>", posTag: .root), buffer: [])
    }
    
    override func tearDown() {
        automata = nil
        
        super.tearDown()
    }
    
    // MARK: - init tests
    func testStackContainsRootTokenOnInit() {
        let sentence = "<ROOT> What is this sentence"
        let rootTokenRange = sentence.range(of: "<ROOT>")!
        let rootToken = Token(i: 0, sentenceRange: rootTokenRange, lemma: "<ROOT>", posTag: .root)
        automata = ParserAutomata(rootToken: rootToken, buffer: [])
        
        XCTAssertEqual(automata.stack, [rootToken])
    }
    
    func testInitSetsUpParseToAccountForRootToken() {
        let sentence = "<ROOT> What is this sentence"
        automata = ParserAutomata(rootPrefix: "<ROOT>", sentence: sentence)
        
        XCTAssertEqual(automata.parse.n, 1 + automata.buffer.count)
    }
    
    // MARK: - isTerminal tests
    func testIsTerminalIsTrueIfStackContainsOnlyRootTokenAndBufferIsEmpty() {
        let sentence = "<ROOT> What is this sentence"
        let rootTokenRange = sentence.range(of: "<ROOT>")!
        let rootToken = Token(i: 0, sentenceRange: rootTokenRange, lemma: "<ROOT>", posTag: .root)
        automata = ParserAutomata(rootToken: rootToken, buffer: [])
        
        XCTAssertTrue(automata.isTerminal)
    }
    
    func testIsTerminalIsFalseIfBufferIsNotEmpty() {
        let sentence = "<ROOT> What is this sentence"
        automata = ParserAutomata(rootPrefix: "<ROOT>", sentence: sentence)
        
        XCTAssertFalse(automata.isTerminal)
    }
    
    func testIsTerminalIsFalseIfStackContainsOtherElementsBesidesRootToken() {
        let sentence = "<ROOT> What is this sentence"
        automata = ParserAutomata(rootPrefix: "<ROOT>", sentence: sentence)
        
        // add all elements to stack
        let bufferCount = automata.buffer.count
        for _ in 0..<bufferCount {
            automata.apply(transition: Transition.shift)
        }
        
        XCTAssertFalse(automata.isTerminal)
    }
    
    private func automata(for sentence: String) -> ParserAutomata {
        return ParserAutomata(rootPrefix: "<ROOT>", sentence: sentence)
    }
}
