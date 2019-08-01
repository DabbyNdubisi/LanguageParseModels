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
        
        automata = ParserAutomata(rootToken: Token(i: 0, sentenceRange: "<ROOT>".range(of: "<ROOT>")!, posTag: .root), buffer: [])
    }
    
    override func tearDown() {
        automata = nil
        
        super.tearDown()
    }
    
    // MARK: - init tests
    func testBufferIsReversedOnInit() {
        let sentence = "<ROOT> What is this sentence"
        let rootTokenRange = sentence.range(of: "<ROOT>")!
        let rootToken = Token(i: 0, sentenceRange: rootTokenRange, posTag: .root)
        let bufferTokens = tokens(for: sentence, rootTokenRange: rootTokenRange)
        automata = ParserAutomata(rootToken: rootToken, buffer: bufferTokens)
        
        XCTAssertEqual(bufferTokens.reversed(), automata.buffer)
    }
    
    func testStackContainsRootTokenOnInit() {
        let sentence = "<ROOT> What is this sentence"
        let rootToken = Token(i: 0, sentenceRange: sentence.range(of: "<ROOT>")!, posTag: .root)
        automata = ParserAutomata(rootToken: rootToken, buffer: [])
        
        XCTAssertEqual(automata.stack, [rootToken])
    }
    
    func testInitSetsUpParseToAccountForRootToken() {
        let sentence = "<ROOT> What is this sentence"
        let rootTokenRange = sentence.range(of: "<ROOT>")!
        let rootToken = Token(i: 0, sentenceRange: rootTokenRange, posTag: .root)
        let bufferTokens = tokens(for: sentence, rootTokenRange: rootTokenRange)
        automata = ParserAutomata(rootToken: rootToken, buffer: bufferTokens)
        
        XCTAssertEqual(automata.parse.n, 1 + bufferTokens.count)
    }
    
    // MARK: - isTerminal tests
    func testIsTerminalIsTrueIfStackContainsOnlyRootTokenAndBufferIsEmpty() {
        let sentence = "<ROOT> What is this sentence"
        let rootToken = Token(i: 0, sentenceRange: sentence.range(of: "<ROOT>")!, posTag: .root)
        automata = ParserAutomata(rootToken: rootToken, buffer: [])
        
        XCTAssertTrue(automata.isTerminal)
    }
    
    func testIsTerminalIsFalseIfBufferIsNotEmpty() {
        let sentence = "<ROOT> What is this sentence"
        let rootTokenRange = sentence.range(of: "<ROOT>")!
        let rootToken = Token(i: 0, sentenceRange: rootTokenRange, posTag: .root)
        let bufferTokens = tokens(for: sentence, rootTokenRange: rootTokenRange)
        automata = ParserAutomata(rootToken: rootToken, buffer: bufferTokens)
        
        XCTAssertFalse(automata.isTerminal)
    }
    
    func testIsTerminalIsFalseIfStackContainsOtherElementsBesidedRootToken() {
        let sentence = "<ROOT> What is this sentence"
        let rootTokenRange = sentence.range(of: "<ROOT>")!
        let rootToken = Token(i: 0, sentenceRange: rootTokenRange, posTag: .root)
        let bufferTokens = tokens(for: sentence, rootTokenRange: rootTokenRange)
        automata = ParserAutomata(rootToken: rootToken, buffer: bufferTokens)
        
        // add all elements to stack
        for _ in 0..<bufferTokens.count {
            automata.apply(transition: Transition.shift)
        }
        
        XCTAssertFalse(automata.isTerminal)
    }
    
    private func tokens(for sentence: String, rootTokenRange: Range<String.Index>) -> [Token] {
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = sentence
        return tagger.tags(in: sentence.range(of: sentence.suffix(from: rootTokenRange.upperBound))!, unit: .word, scheme: .lexicalClass, options: [.omitWhitespace]).enumerated().map { Token(i: $0.offset + 1, sentenceRange: $0.element.1, posTag: POSTag(nlTag: $0.element.0!)!) }
    }
}
