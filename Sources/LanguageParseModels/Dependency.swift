//
//  Dependency.swift
//  
//
//  Created by Dabeluchi Ndubisi on 2019-07-12.
//

import Foundation

/// Simple dependency structure depicting single
/// parent and child dependency
public struct Dependency {
    public let head: Int
    public let relationship: DependencyRelation
    
    public init(head: Int, relationship: DependencyRelation) {
        self.head = head
        self.relationship = relationship
    }
}
