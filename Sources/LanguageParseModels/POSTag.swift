//
//  POSTag.swift
//
//
//  Created by Dabeluchi Ndubisi on 2019-07-12.
//

import Foundation
import NaturalLanguage

/// POSTags adapted from NaturalLanguage NLTagScheme.lexicalClass
public enum POSTag: Equatable, CaseIterable {
    /// Tag reserved for the <ROOT> token
    case root
    case word
    case punctuation
    case whitespace
    case other
    case noun
    case verb
    case adjective
    case adverb
    case pronoun
    case determiner
    case particle
    case preposition
    case number
    case conjunction
    case interjection
    case classifier
    case idiom
    case otherWord
    case sentenceTerminator
    case openQuote
    case closeQuote
    case openParenthesis
    case closeParenthesis
    case wordJoiner
    case dash
    case otherPunctuation
    case paragraphBreak
    case otherWhitespace
}

extension POSTag {
    public init?(nlTag: NLTag) {
        switch nlTag {
        case .word:
            self = .word
        case .punctuation:
            self = .punctuation
        case .whitespace:
            self = .whitespace
        case .other:
            self = .other
        case .noun:
            self = .noun
        case .verb:
            self = .verb
        case .adjective:
            self = .adjective
        case .adverb:
            self = .adverb
        case .pronoun:
            self = .pronoun
        case .determiner:
            self = .determiner
        case .particle:
            self = .particle
        case .preposition:
            self = .preposition
        case .number:
            self = .number
        case .conjunction:
            self = .conjunction
        case .interjection:
            self = .interjection
        case .classifier:
            self = .classifier
        case .idiom:
            self = .idiom
        case .otherWord:
            self = .otherWord
        case .sentenceTerminator:
            self = .sentenceTerminator
        case .openQuote:
            self = .openQuote
        case .closeQuote:
            self = .closeQuote
        case .openParenthesis:
            self = .openParenthesis
        case .closeParenthesis:
            self = .closeParenthesis
        case .wordJoiner:
            self = .wordJoiner
        case .dash:
            self = .dash
        case .otherPunctuation:
            self = .otherPunctuation
        case .paragraphBreak:
            self = .paragraphBreak
        case .otherWhitespace:
            self = .otherWhitespace
        default:
            // no nlTags should match the root tag
            return nil
        }
    }
    
    public var nlTag: NLTag? {
        switch self {
        case .root:
            return nil
        case .word:
            return .word
        case .punctuation:
            return .punctuation
        case .whitespace:
            return .whitespace
        case .other:
            return .other
        case .noun:
            return .noun
        case .verb:
            return .verb
        case .adjective:
            return .adjective
        case .adverb:
            return .adverb
        case .pronoun:
            return .pronoun
        case .determiner:
            return .determiner
        case .particle:
            return .particle
        case .preposition:
            return .preposition
        case .number:
            return .number
        case .conjunction:
            return .conjunction
        case .interjection:
            return .interjection
        case .classifier:
            return .classifier
        case .idiom:
            return .idiom
        case .otherWord:
            return .otherWord
        case .sentenceTerminator:
            return .sentenceTerminator
        case .openQuote:
            return .openQuote
        case .closeQuote:
            return .closeQuote
        case .openParenthesis:
            return .openParenthesis
        case .closeParenthesis:
            return .closeParenthesis
        case .wordJoiner:
            return .wordJoiner
        case .dash:
            return .dash
        case .otherPunctuation:
            return .otherPunctuation
        case .paragraphBreak:
            return .paragraphBreak
        case .otherWhitespace:
            return.otherWhitespace
        }
    }
}
