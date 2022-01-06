//
//  CombineFile.swift
//  Dispo Take Home
//
//  Created by Sam Greenhill on 1/5/22.
//

import Foundation
import UIKit
import Combine


class CombineFile {
    
    static var shared = CombineFile()
    
    var subscription = Set<AnyCancellable>()
    
    var gifImg = PassthroughSubject<UIImage?, Never>()
    
    //image URL Fetching
    
    
    
}
