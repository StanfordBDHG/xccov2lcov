//
//  main.swift
//  xccov2lcov
//
//  Created by David Whetstone on 10/16/19.
//  Copyright © 2019 Trax. All rights reserved.
//

import ArgumentParser
import Foundation
import XCCovLib


extension Mode: ExpressibleByArgument {}


@main
struct xccov2lcov: ParsableCommand {
    @Argument(help: "Input filename (output of `xccov view --report --json file.xcresult`)")
    var inputFilename: String
    
    @Option(help: "Path to trim from start of paths in input file")
    var trimPath: String = ""
    
    @Option(help: "")
    var targets: [String] = []
    
    @Option(help: "mode")
    var mode: Mode = .simple
    
    func run() throws {
        guard FileManager().isReadableFile(atPath: inputFilename) else {
            throw CmdError(description: "Cannot read input file: \(inputFilename)")
        }
        let context = XCCovContext(
            includedTargets: targets,
            trimPath: trimPath,
            mode: mode
        )
        let data = try Data(contentsOf: URL(fileURLWithPath: inputFilename))
        let xccovData = try JSONDecoder().decode(XCCovData.self, from: data)
        print(xccovData.lcov(context: context))
    }
}


struct CmdError: Error, CustomStringConvertible {
    let description: String
}
