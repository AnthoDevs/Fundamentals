//
//  TestJSONLoader.swift
//  Fundamentals
//
//  Created by Anthony on 8/24/26.
//


import Foundation

private final class TestBundleToken {}

enum TestJSONLoader {

    static func load(_ name: String) throws -> Data {
        let bundle = Bundle(for: TestBundleToken.self)
        guard let url = bundle.url(
            forResource: name,
            withExtension: "json"
        ) else {
            throw NSError(
                domain: "TestJSONLoader",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey: "\(name).json not found"
                ]
            )
        }

        return try Data(contentsOf: url)
    }
}
