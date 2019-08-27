//
//  Transition.swift
//  NNSyntaxParser
//
//  Created by Dabeluchi Ndubisi on 2019-07-14.
//  Copyright © 2019 Dabeluchi Ndubisi. All rights reserved.
//

import Foundation

public enum Transition: Equatable, Hashable {
    case shift
    case left(relation: DependencyRelation)
    case right(relation: DependencyRelation)
    
    public static var numberOfTransitions: Int {
        // Number of possible transitions ((n_possibleRelations * 2) + 1) Left, Right, Shift)
        return (2 * DependencyRelation.allCases.count) + 1
    }
    
    public init?(rawValue: Int) {
        let relations = DependencyRelation.allCases
        
        switch rawValue {
        case 0:
            self = .shift
        case 1...relations.count:
            self = .left(relation: relations[rawValue-1])
        case (relations.count+1)...(2*relations.count):
            self = .right(relation: relations[rawValue - (relations.count + 1)])
        default:
            return nil
        }
    }
    
    public var rawValue: Int {
        let relations = DependencyRelation.allCases
        func rawValue(for relation: DependencyRelation, offset: Int) -> Int {
            for (idx, element) in relations.enumerated() {
                if element == relation {
                    return offset + idx
                }
            }
            // We shouldn't get here as it means that the dependency
            // relation provided isn't contained in the array of all DependencyRelations, but that is not possible
            fatalError("Invalid relation provided")
        }
        
        switch self {
        case .shift:
            return 0
        case .left(let relation):
            return rawValue(for: relation, offset: 1)
        case .right(let relation):
            return rawValue(for: relation, offset: relations.count + 1)
        }
    }
    
    public var isLeft: Bool {
        return (1...(DependencyRelation.allCases.count)).contains(rawValue)
    }
    
    public var isRight: Bool {
        let relationsCount = DependencyRelation.allCases.count
        return ((relationsCount+1)...(2*relationsCount)).contains(rawValue)
    }
    
    public var isShift: Bool {
        return self == .shift
    }
    
    var relation: DependencyRelation? {
        switch self {
        case .shift:
            return nil
        case .left(let relation),
             .right(let relation):
            return relation
        }
    }
    
    /// Returns all the possible left transitions
    static var allLefts: [Transition] {
        return DependencyRelation.allCases.map { Transition.left(relation: $0) }
    }
    
    /// Returns all the possible right transitions
    static var allRights: [Transition] {
        return DependencyRelation.allCases.map { Transition.right(relation: $0) }
    }
}
