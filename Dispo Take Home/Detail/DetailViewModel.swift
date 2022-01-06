//
//  DetailViewModel.swift
//  Dispo Take Home
//
//  Created by Sam Greenhill on 1/5/22.
//

import Foundation
import Combine

func detailVM(
    gifInfo: AnyPublisher<String, Never>)
-> (AnyPublisher<GifInfo, Never>
) {
    let api = GifAPIClient.live
    
    let gif = gifInfo
        .map { api.gifInfo($0) }
        .switchToLatest()
    
    return gif.eraseToAnyPublisher()
}
