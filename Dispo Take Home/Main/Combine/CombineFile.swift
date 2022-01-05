//
//  CombineFile.swift
//  Dispo Take Home
//
//  Created by Sam Greenhill on 1/5/22.
//

import Foundation
import Combine


class CombineFile {
    
    var subscriber = Set<AnyCancellable>()
    
    var gifData = PassthroughSubject<String, Never>()
    
    
}
