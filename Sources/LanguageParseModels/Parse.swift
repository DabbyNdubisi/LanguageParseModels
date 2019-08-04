//
//  Parse.swift
//
//
//  Created by Dabeluchi Ndubisi on 2019-06-29.
//

import Foundation

/// Parse errors
public enum ParseError: Error {
    case outOfRange
}

/// Model
public struct Parse {
    public let n: Int
    public private(set) var heads: [Dependency?]
    public private(set) var lefts: [[Token]]
    public private(set) var rights: [[Token]]
    
    /// Initializer
    /// - Parameters:
    ///     - n: number of tokens in the sentence (including the <ROOT> token)
    public init(n: Int) {
        self.n = n
        heads = .init(repeating: nil, count: n)
        lefts = .init(repeating: [], count: n)
        rights = .init(repeating: [], count: n)
    }
    
    public mutating func add(dependency: Dependency, to node: Token) throws {
        let range = (0...n)
        guard range.contains(dependency.head) && range.contains(node.i) else {
            throw ParseError.outOfRange
        }
        
        heads[node.i] = dependency
        if node.i < dependency.head {
            lefts[dependency.head].append(node)
        } else {
            rights[dependency.head].append(node)
        }
    }
}
