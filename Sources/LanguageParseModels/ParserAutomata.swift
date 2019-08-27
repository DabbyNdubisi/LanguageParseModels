//
//  ParserAutomata.swift
//  NNSyntaxParser
//
//  Created by Dabeluchi Ndubisi on 2019-07-15.
//  Copyright © 2019 Dabeluchi Ndubisi. All rights reserved.
//

import Foundation

public struct ParserAutomata {
    private let rootToken: Token
    public private(set) var buffer: [Token]
    public private(set) var stack: [Token]
    public private(set) var parse: Parse
    
    init(rootToken: Token, buffer: [Token]) {
        self.rootToken = rootToken
        // reverse buffer array to make popping first element efficient
        self.buffer = buffer.reversed()
        self.stack = [rootToken]
        self.parse = Parse(tokens: [rootToken] + buffer)
    }
    
    public var isTerminal: Bool {
        return stack == [rootToken] && buffer.isEmpty
    }
    
    public mutating func apply(transition: Transition) {
        switch transition {
        case .shift:
            stack.append(buffer.popLast()!)
        case .left(let relation):
            try! parse.add(dependency: Dependency(head: buffer[buffer.count - 1].i, relationship: relation), to: stack[stack.count - 1])
            _ = stack.popLast()
        case .right(let relation):
            try! parse.add(dependency: Dependency(head: stack[stack.count - 2].i, relationship: relation), to: stack[stack.count - 1])
            _ = stack.popLast()
        }
    }
    
    public func validTransitions() -> [Transition] {
        var valids = [Transition]()
        
        if !buffer.isEmpty {
            valids.append(.shift)
            
            if !stack.isEmpty && stack.last != rootToken {
                valids += Transition.allLefts.filter({ $0.relation != .root })
            }
        }
        
        // This ensures that there can only be one `root` dependency
        if stack.count == 2 && buffer.isEmpty {
            valids += [Transition.right(relation: .root)]
        } else if stack.count >= 3 {
            valids += Transition.allRights.filter({ $0.relation != .root })
        }
        
        return valids
    }
    
    func stackTop(k: Int) -> [Token] {
        return top(k: k, array: stack)
    }
    
    func bufferTop(k: Int) -> [Token] {
        return top(k: k, array: buffer)
    }
    
    private func top(k: Int, array: [Token]) -> [Token] {
        guard !array.isEmpty else {
            return [Token]()
        }
        
        var topMost = [Token]()
        let lowerBound = max(0, array.count - k)
        for i in (lowerBound..<array.count).reversed() {
            topMost.append(array[i])
        }
        return topMost
    }
}
