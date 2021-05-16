//
//  ViewModelType.swift
//  iCarTrack
//
//  Created by siva lingam on 13/5/21.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
