//
//  TransitionFeatureProvider.swift
//  NNSyntaxParser
//
//  Created by Dabeluchi Ndubisi on 2019-07-15.
//  Copyright © 2019 Dabeluchi Ndubisi. All rights reserved.
//

import Foundation

public struct TransitionFeatureProvider {
    static let noneToken = "<NONE>" // Equivalent of nil when there is no tag (needed during feature extraction)
    
    private static let index2Tags: [String] = POSTag.allCases.map { $0.tagString }
    
    private static let index2DependencyRelation: [String] = DependencyRelation.allCases.map { $0.relationString }
    
    /// Maps an index to one of:
    /// <NONE>: Indicates the index doesn't exist (0th index)
    /// tags: (1 - 29th indices)
    /// labels: (30 - 66th indices)
    /// words: (67 - index2Token.count-1 indices) (400K Glove words)
    let index2Token: [String]
    
    /// reverse mapping from token to index
    let token2Index: [String: Int32]
    
    /// Tokens for <NONE> + tags + labels
    static var domainTokens: [String] {
        return [TransitionFeatureProvider.noneToken] + TransitionFeatureProvider.index2Tags + TransitionFeatureProvider.index2DependencyRelation
    }
    
    public init(index2Word: [String]) {
        // construct consolidated index2Word mapping that consists of
        // <NONE> + tags + labels + words
        self.index2Token = TransitionFeatureProvider.domainTokens + index2Word
        
        // reverse token to index mapping construction
        var token2Index = [String: Int32]()
        for i in 0..<index2Token.count {
            token2Index[index2Token[i]] = Int32(i)
        }
        self.token2Index = token2Index
    }
    
    func features(for state: ParserAutomata, sentence: String) -> [Int32] {
        let top3Stack = state.stackTop(k: 3)
        let top3Buffer = state.bufferTop(k: 3)
        var s0l0: Token? =  nil
        var s0l1: Token? = nil
        var s0r0: Token? = nil
        var s0r1: Token? = nil
        var s1l0: Token? =  nil
        var s1l1: Token? = nil
        var s1r0: Token? = nil
        var s1r1: Token? = nil
        var s0l0_of_l0: Token? = nil
        var s0r0_of_r0: Token? = nil
        var s1l0_of_l0: Token? = nil
        var s1r0_of_r0: Token? = nil
        
        if top3Stack.count > 0 {
            let s0LeftChildren = state.parse.lefts[top3Stack[0].i]
            let s0RightChildren = state.parse.rights[top3Stack[0].i]
            s0l0 = s0LeftChildren.last ?? nil
            s0r0 = s0RightChildren.last ?? nil
            s0l1 = s0LeftChildren.count >= 2 ? s0LeftChildren[s0LeftChildren.count - 2] : nil
            s0r1 = s0RightChildren.count >= 2 ? s0RightChildren[s0RightChildren.count - 2] : nil
            
            if let s0LeftMostChild = s0l0 {
                let s0LeftMostChildLeftChildren = state.parse.lefts[s0LeftMostChild.i]
                s0l0_of_l0 = s0LeftMostChildLeftChildren.last ?? nil
            }
            if let s0RightMostChild = s0r0 {
                let s0RightMostChildRightChildren = state.parse.rights[s0RightMostChild.i]
                s0r0_of_r0 = s0RightMostChildRightChildren.last ?? nil
            }
        }
        if top3Stack.count > 1 {
            let s1LeftChildren = state.parse.lefts[top3Stack[1].i]
            let s1RightChildren = state.parse.rights[top3Stack[1].i]
            s1l0 = s1LeftChildren.last ?? nil
            s1r0 = s1RightChildren.last ?? nil
            s1l1 = s1LeftChildren.count >= 2 ? s1LeftChildren[s1LeftChildren.count - 2] : nil
            s1r1 = s1RightChildren.count >= 2 ? s1RightChildren[s1RightChildren.count - 2] : nil
            
            if let s1LeftMostChild = s1l0 {
                let s1LeftMostChildLeftChildren = state.parse.lefts[s1LeftMostChild.i]
                s1l0_of_l0 = s1LeftMostChildLeftChildren.last ?? nil
            }
            if let s1RightMostChild = s1r0 {
                let s1RightMostChildRightChildren = state.parse.rights[s1RightMostChild.i]
                s1r0_of_r0 = s1RightMostChildRightChildren.last ?? nil
            }
        }
        
        // Fill up top3Stack and buffer with nil if needed
        var filledTop3Stack: [Token?] = top3Stack
        var filledTop3Buffer: [Token?] = top3Buffer
        while filledTop3Stack.count < 3 { filledTop3Stack.append(nil) }
        while filledTop3Buffer.count < 3 { filledTop3Buffer.append(nil) }
        
        // nw: 18 features for words
        let nonStackNonBufferFeatures = [ s0l0, s0l1, s0r0, s0r1, s1l0, s1l1, s1r0, s1r1, s0l0_of_l0, s0r0_of_r0, s1l0_of_l0, s1r0_of_r0]
        let nw = (filledTop3Stack + filledTop3Buffer + nonStackNonBufferFeatures).map({ token -> String in
            token == nil ? TransitionFeatureProvider.noneToken : String(sentence[token!.sentenceRange])
        })
        let nt = (filledTop3Stack + filledTop3Buffer + nonStackNonBufferFeatures).map({ ($0 ?? nil)?.posTag })
        let nl = nonStackNonBufferFeatures.map({ $0 == nil ? nil : (state.parse.heads[$0!.i])?.relationship })
        
        return nw.map({ index(word: $0) }) +
            nt.map({ $0 == nil ? noneIndex : index(tag: $0!) }) +
            nl.map({ $0 == nil ? noneIndex : index(depRelation: $0!) })
    }
    
    func index(word: String) -> Int32 {
        return index(for: word.lowercased())
    }
    
    func index(tag: POSTag) -> Int32 {
        return index(for: tag.tagString)
    }
    
    func index(depRelation: DependencyRelation) -> Int32 {
        return index(for: depRelation.relationString)
    }
    
    // MARK: - Private helpers
    private func token(for index: Int32) -> String {
        return index2Token[Int(index)]
    }
    
    private func index(for token: String) -> Int32 {
        return token2Index[token] ?? noneIndex
    }
    
    private var noneIndex: Int32 {
        return token2Index[TransitionFeatureProvider.noneToken]!
    }
}

// MARK: - POSTag extensions
private extension POSTag {
    var tagString: String {
        switch self {
        case .root:
            return "<ROOT_TAG>"
        case .word,
             .punctuation,
             .whitespace,
             .other,
             .noun,
             .verb,
             .adjective,
             .adverb,
             .pronoun,
             .determiner,
             .particle,
             .preposition,
             .number,
             .conjunction,
             .interjection,
             .classifier,
             .idiom,
             .otherWord,
             .sentenceTerminator,
             .openQuote,
             .closeQuote,
             .openParenthesis,
             .closeParenthesis,
             .wordJoiner,
             .dash,
             .otherPunctuation,
             .paragraphBreak,
             .otherWhitespace:
            return "TAG_\(nlTag!.rawValue)"
        }
    }
}

// MARK: - DependencyRelation extensions
private extension DependencyRelation {
    var relationString: String {
        switch self {
        case .acl:
            return "DEP_acl"
        case .advcl:
            return "DEP_advcl"
        case .advmod:
            return "DEP_advmod"
        case .amod:
            return "DEP_amod"
        case .appos:
            return "DEP_appos"
        case .aux:
            return "DEP_aux"
        case .`case`:
            return "DEP_`case`"
        case .cc:
            return "DEP_cc"
        case .ccomp:
            return "DEP_ccomp"
        case .clf:
            return "DEP_clf"
        case .compound:
            return "DEP_compound"
        case .conj:
            return "DEP_conj"
        case .cop:
            return "DEP_cop"
        case .csubj:
            return "DEP_csubj"
        case .dep:
            return "DEP_dep"
        case .det:
            return "DEP_det"
        case .discourse:
            return "DEP_discourse"
        case .dislocated:
            return "DEP_dislocated"
        case .expl:
            return "DEP_expl"
        case .fixed:
            return "DEP_fixed"
        case .flat:
            return "DEP_flat"
        case .goeswith:
            return "DEP_goeswith"
        case .iobj:
            return "DEP_iobj"
        case .list:
            return "DEP_list"
        case .mark:
            return "DEP_mark"
        case .nmod:
            return "DEP_nmod"
        case .nsubj:
            return "DEP_nsubj"
        case .nummod:
            return "DEP_nummod"
        case .obj:
            return "DEP_obj"
        case .obl:
            return "DEP_obl"
        case .orphan:
            return "DEP_orphan"
        case .parataxis:
            return "DEP_parataxis"
        case .punct:
            return "DEP_punct"
        case .reparandum:
            return "DEP_reparandum"
        case .root:
            return "DEP_root"
        case .vocative:
            return "DEP_vocative"
        case .xcomp:
            return "DEP_xcomp"
        }
    }
}
