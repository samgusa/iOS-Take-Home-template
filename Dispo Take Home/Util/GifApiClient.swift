import Combine
import UIKit

struct GifAPIClient {
    var gifInfo: (_ gifId: String) -> AnyPublisher<GifInfo, Never>
    var searchGIFs: (String) -> AnyPublisher<[SearchResult], Never>
    var featuredGIFs: () -> AnyPublisher<[SearchResult], Never>
}



// MARK: - Live Implementation

extension GifAPIClient {
    static let live = GifAPIClient(
        //similar to other publishers
        gifInfo: { gifId in
            var components = URLComponents(
                url: URL(string: "\(Constants.apiURLConstant)\(gifId)")!,
                resolvingAgainstBaseURL: false
            )!
            components.queryItems = [
              .init(name: "api_key", value: Constants.giphyApiKey),
              .init(name: "gif_id", value: gifId),
            ]
            let url = components.url!
            return URLSession.shared.dataTaskPublisher(for: url)
              .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                  throw URLError(.badServerResponse)
                }
                return element.data
                }
                .decode(type: apiResponse.self, decoder: JSONDecoder())
                .map { response in
                  let gif = response.data
                  return GifInfo(id: gif.id,
                              gifUrl: gif.images.fixed_height.url,
                              url: gif.url,
                              text: gif.title,
                              shares: 0,
                              backgroundColor: nil,
                              tags: [],
                              rating: gif.rating
                  )
                }
                .replaceError(with:
                                GifInfo(id: "",
                                        gifUrl: URL(fileURLWithPath: ""),
                                        url: URL(fileURLWithPath: ""), text: "Error Occurred",
                                        shares: 0,
                                        backgroundColor: nil,
                                        tags: [],
                                        rating: "")
                )
                .share()
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        },
        searchGIFs: { query in
            var components = URLComponents(
                url: URL(string: "\(Constants.apiURLConstant)search")!,
                resolvingAgainstBaseURL: false
            )!
            components.queryItems = [
                .init(name: "api_key", value: Constants.giphyApiKey),
                .init(name: "q", value: query),
            ]
            let url = components.url!
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .decode(type: APIListResponse.self, decoder: JSONDecoder())
                .map { response in
                    response.data.map {
                        SearchResult(
                            id: $0.id,
                            gifUrl: $0.images.fixed_height.url,
                            title: $0.title
                        )
                    }
                }
                .replaceError(with: [])
                .share()
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        },
        featuredGIFs: {
            var components = URLComponents(
                url: URL(string: "\(Constants.apiURLConstant)trending")!,
                resolvingAgainstBaseURL: false
            )!
            components.queryItems = [
                .init(name: "api_key", value: Constants.giphyApiKey),
                .init(name: "rating", value: "pg"),
            ]
            let url = components.url!
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { element -> Data in
                    guard let httpResponse = element.response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return element.data
                }
                .decode(type: APIListResponse.self, decoder: JSONDecoder())
                .map { response in
                    response.data.map {
                        SearchResult(
                            id: $0.id,
                            gifUrl: $0.images.fixed_height.url,
                            title: $0.title
                        )
                    }
                }
                .replaceError(with: [])
                .share()
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    )
}

private struct apiResponse: Codable {
    //needs to be called data because that is what the JSON is. 
    var data: GifObject
}

private struct APIListResponse: Codable {
    var data: [GifObject]
}

private struct GifObject: Codable {
    var id: String
    var title: String
    var source_tld: String
    var rating: String
    /// Giphy URL (not gif url to be displayed)
    var url: URL
    var images: Images
    
    struct Images: Codable {
        var fixed_height: Image
        
        struct Image: Codable {
            var url: URL
            var width: String
            var height: String
        }
    }
}

