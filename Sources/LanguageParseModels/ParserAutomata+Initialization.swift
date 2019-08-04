//
//  ParserAutomata+Initialization.swift
//  NNSyntaxParser
//
//  Created by Dabeluchi Ndubisi on 2019-08-01.
//  Copyright © 2019 Dabeluchi Ndubisi. All rights reserved.
//

import Foundation
import NaturalLanguage

extension ParserAutomata {
    init(rootPrefix: String, sentence: String) {
        let rootPrefixRange = sentence.range(of: rootPrefix)!
        let remainingSentenceRange = sentence.range(of: sentence.suffix(from: rootPrefixRange.upperBound))!
        
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = sentence
        let rootToken = Token(i: 0, sentenceRange: rootPrefixRange, posTag: .root)
        self.init(
            rootToken: rootToken,
            buffer: tagger.tags(in: remainingSentenceRange,
                                unit: .word,
                                scheme: .lexicalClass,
                                options: [.omitWhitespace])
                .enumerated()
                .map({ Token(i: $0.offset + 1,
                             sentenceRange: $0.element.1,
                             posTag: POSTag(nlTag: $0.element.0!)! )
                })
        )
    }
}

