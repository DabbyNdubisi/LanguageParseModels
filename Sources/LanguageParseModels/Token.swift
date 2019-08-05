//
//  Token.swift
//  NNSyntaxParser
//
//  Created by Dabeluchi Ndubisi on 2019-07-12.
//  Copyright © 2019 Dabeluchi Ndubisi. All rights reserved.
//

import Foundation
import NaturalLanguage

/// A parse token
public struct Token: Equatable {
    /// index of token wrt list of sentence tokens
    public var i: Int
    /// range of token in the reference sentence
    public var sentenceRange: Range<String.Index>
    /// lemmatized version of token
    public var lemma: String
    /// Part-of-Speech tag of the token
    public var posTag: POSTag
    
    public init(i: Int, sentenceRange: Range<String.Index>, lemma: String, posTag: POSTag) {
        self.i = i
        self.sentenceRange = sentenceRange
        self.lemma = lemma
        self.posTag = posTag
    }
}
