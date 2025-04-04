//
// This source file is part of the Stanford Biodesign for Digital Health open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//
// Originally created by David Whetstone, Trax, 10/16/19.

import ArgumentParser
import Foundation
import XCCovLib


extension Mode: ExpressibleByArgument {}


@main
struct xccov2lcov: ParsableCommand {
    @Argument(help: "Input filename (output of `xccov view --report --json file.xcresult`). Omit to read input from STDIN.")
    var inputFilename: String?
    
    @Option(help: "Path to trim from start of paths in input file")
    var trimPath: String = ""
    
    @Option(help: "Targets to include in output (default: all targets)")
    var targets: [String] = []
    
    @Option(help: "mode")
    var mode: Mode = .simple
    
    func run() throws {
        let data: Data
        if let inputFilename {
            guard FileManager().isReadableFile(atPath: inputFilename) else {
                throw CmdError(description: "Cannot read input file: \(inputFilename)")
            }
            data = try Data(contentsOf: URL(fileURLWithPath: inputFilename))
        } else {
            data = sequence(first: "", next: { _ in readLine(strippingNewline: false) })
                .reduce(into: Data()) { data, line in
                    data.append(contentsOf: line.utf8)
                }
        }
        let context = XCCovContext(
            includedTargets: targets,
            trimPath: trimPath,
            mode: mode
        )
        let xccovData = try JSONDecoder().decode(XCCovData.self, from: data)
        print(xccovData.lcov(context: context))
    }
}


struct CmdError: Error, CustomStringConvertible {
    let description: String
}
