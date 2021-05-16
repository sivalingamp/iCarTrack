//
//  Application.swift
//  iCarTrack
//
//  Created by siva lingam on 13/5/21.
//

import Foundation
import Domain
import DataPlatform

final class Application {
    static let shared = Application()
    let useCaseProvider: Domain.UseCaseProvider
    private init() {
        self.useCaseProvider = DataPlatform.UseCaseProvider()
    }
}
