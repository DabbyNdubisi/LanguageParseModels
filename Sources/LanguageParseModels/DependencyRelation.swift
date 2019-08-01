//
//  DependencyRelation.swift
//
//
//  Created by Dabeluchi Ndubisi on 2019-07-12.
//

import Foundation

// Possible dependency relations
public enum DependencyRelation: String, Equatable, CaseIterable {
    case acl // clausal modifier of noun (adjectival clause)
    case advcl // adverbial clause modifier
    case advmod // adverbial modifier
    case amod // adjectival modifier
    case appos // appositional modifier
    case aux // auxiliary
    case `case` // case marking
    case cc // coordinating conjunction
    case ccomp // clausal complement
    case clf // classifier
    case compound // compound
    case conj // conjunct
    case cop // copula
    case csubj // clausal subject
    case dep // unspecified dependency
    case det // determiner
    case discourse // discourse element
    case dislocated // dislocated elements
    case expl // expletive
    case fixed // fixed multiword expression
    case flat // flat multiword expression
    case goeswith // goes with
    case iobj // indirect object
    case list // list
    case mark // marker
    case nmod // nominal modifier
    case nsubj // nominal subject
    case nummod // numeric modifier
    case obj // object
    case obl // oblique nominal
    case orphan // orphan
    case parataxis // parataxis
    case punct // punctuation
    case reparandum // overridden disfluency
    case root // root (dependency between the root of the sentence and the "<ROOT>" synthetic word token)
    case vocative // vocative
    case xcomp // open clausal complement
}
