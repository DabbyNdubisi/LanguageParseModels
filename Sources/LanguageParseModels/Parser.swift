//
//  Parser.swift
//  NNSyntaxParser
//
//  Created by Dabeluchi Ndubisi on 2019-07-16.
//  Copyright © 2019 Dabeluchi Ndubisi. All rights reserved.
//

import Foundation
import NaturalLanguage

class Parser {
    private let rootPrefix = "<ROOT>"
    private let model: ParserModel
    private let featureProvider: TransitionFeatureProvider
    private let tagger: NLTagger = NLTagger(tagSchemes: [.lexicalClass])

    init(model: ParserModel, featureProvider: TransitionFeatureProvider) {
        self.model = model
        self.featureProvider = featureProvider
    }

    func parse(sentence: String) throws -> Parse {
        guard let rootPrefixRange = sentence.range(of: rootPrefix) else {
            return try parse(sentence: "\(rootPrefix) \(sentence)")
        }

        let range = sentence.range(of: sentence.suffix(from: rootPrefixRange.upperBound))!
        tagger.string = sentence
        let rootToken = Token(i: 0, sentenceRange: rootPrefixRange, posTag: .root)
        let buffer =
            tagger.tags(in: range, unit: .word, scheme: .lexicalClass, options: [.omitWhitespace]).enumerated().map({ Token(i: $0.offset + 1, sentenceRange: $0.element.1, posTag: POSTag(nlTag: $0.element.0!)! ) })
        var state = ParserAutomata(rootToken: rootToken, buffer: buffer)

        while !state.isTerminal {
            let valids = state.validTransitions()
            let transitionProbabilities = try model.transitionProbabilities(for: featureProvider.features(for: state, sentence: sentence))
            let bestPrediction = valids.max(by: {
                transitionProbabilities[$0.rawValue]! < transitionProbabilities[$1.rawValue]!
            })!
            state.apply(transition: bestPrediction)
        }

        return state.parse
    }
}
