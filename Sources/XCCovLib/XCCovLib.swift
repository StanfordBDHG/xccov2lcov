//
// This source file is part of the Stanford Biodesign for Digital Health open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//
// Originally created by David Whetstone @ Trax Retail, 10/16/19.
//

// swiftlint:disable missing_docs

import Foundation


public enum Mode: String {
    case simple
    case full
}


public struct XCCovContext {
    public let includedTargets: [String]
    public let trimPath: String
    public let mode: Mode
    
    public init(includedTargets: [String] = [], trimPath: String = "", mode: Mode = .simple) {
        self.includedTargets = includedTargets
        self.trimPath = trimPath
        self.mode = mode
    }
}


extension XCCovData {
    public func lcov(context: XCCovContext) -> String {
        includedTargets(context.includedTargets)
            .map { $0.lcov(context: context) }
            .joined(separator: "\n")
    }
    
    private func includedTargets(_ includeTargets: [String]) -> [XCCovTarget] {
        includeTargets.isEmpty
            ? targets
            : targets.filter { includeTargets.contains($0.name) }
    }
}


extension XCCovTarget {
    public func lcov(context: XCCovContext) -> String {
        files.map { $0.lcov(context: context) }.joined(separator: "\n")
    }
}


extension XCCovFile {
    public func lcov(context: XCCovContext) -> String {
        let lines = [
            "SF:\(path.trimmingPrefix(context.trimPath))",
            "\(functions.map { $0.lcov(context: context) }.joined(separator: "\n"))",
            context.mode == .full ? "LF:\(executableLines)" : nil,
            context.mode == .full ? "LH:\(coveredLines)" : nil,
            "end_of_record"
        ]
        return lines
            .compactMap { $0 }
            .joined(separator: "\n")
    }
}


extension XCCovFunction {
    private var namedFunction: String {
        """
        FN:\(lineNumber),\(name)
        FNDA:\(executionCount),\(name)
        FNF:\(executableLines)
        FNH:\(coveredLines)
        """
    }
    
    private var unnamedFunction: String {
        "DA:\(lineNumber),\(executionCount)"
    }
    
    public func lcov(context: XCCovContext) -> String {
        name.isEmpty || context.mode == .simple ? unnamedFunction : namedFunction
    }
}
