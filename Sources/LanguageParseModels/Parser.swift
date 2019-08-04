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
    static let rootPrefix = "<ROOT>"
    private var rootPrefix: String { Parser.rootPrefix }
    
    private let model: ParserModel
    private let featureProvider: TransitionFeatureProvider

    init(model: ParserModel, featureProvider: TransitionFeatureProvider) {
        self.model = model
        self.featureProvider = featureProvider
    }

    func parse(sentence: String) throws -> Parse {
        guard sentence.range(of: rootPrefix) != nil else {
            return try parse(sentence: "\(rootPrefix) \(sentence)")
        }
        var state = ParserAutomata(rootPrefix: rootPrefix, sentence: sentence)

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
