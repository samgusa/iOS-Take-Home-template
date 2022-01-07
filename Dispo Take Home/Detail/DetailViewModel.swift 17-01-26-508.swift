//
//  DetailViewModel.swift
//  Dispo Take Home
//
//  Created by Sam Greenhill on 1/5/22.
//

import Foundation
import Combine

//Similar to MainViewModel
func detailViewModel(
    lookupID: String,
    buttonTapped: AnyPublisher<URL, Never>
) -> (
    info: AnyPublisher<GifInfo, Never>,
    openSafari: AnyPublisher<URL, Never>
) {
    let api = GifAPIClient.live
    return (
        info: api.gifInfo(lookupID),
        openSafari: buttonTapped
    )
}
