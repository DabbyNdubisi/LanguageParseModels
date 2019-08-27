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
    public init(rootPrefix: String, sentence: String) {
        let rootPrefixRange = sentence.range(of: rootPrefix)!
        let remainingSentenceRange = sentence.range(of: sentence.suffix(from: rootPrefixRange.upperBound))!
        
        let tagger = NLTagger(tagSchemes: [.lexicalClass, .lemma])
        tagger.string = sentence
        let rootToken = Token(i: 0, sentenceRange: rootPrefixRange, lemma: rootPrefix, posTag: .root)
        
        let posTags = tagger.tags(in: remainingSentenceRange,
                                  unit: .word,
                                  scheme: .lexicalClass,
                                  options: [.omitWhitespace])
        let lemmas = tagger.tags(in: remainingSentenceRange,
                                 unit: .word,
                                 scheme: .lemma,
                                 options: [.omitWhitespace])
        guard lemmas.count == posTags.count else {
            fatalError("invalid tokenization")
        }
        
        let tokens = (0..<posTags.count)
            .map({ Token(i: $0 + 1,
                     sentenceRange: posTags[$0].1,
                     lemma: lemmas[$0].0?.rawValue ?? String(sentence[lemmas[$0].1]),
                     posTag: POSTag(nlTag: posTags[$0].0!)! )
            })
        
        self.init(rootToken: rootToken, buffer: tokens)
    }
}

