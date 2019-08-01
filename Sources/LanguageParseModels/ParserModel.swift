//
//  ParserModel.swift
//  NNSyntaxParser
//
//  Created by Dabeluchi Ndubisi on 2019-07-31.
//  Copyright © 2019 Dabeluchi Ndubisi. All rights reserved.
//

import Foundation

protocol ParserModel {
    func transitionProbabilities(for features: [Int32]) throws -> [Int: Float]
}
