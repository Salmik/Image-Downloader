import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let width: Int
    let height: Int
    let urls: [URLCase.RawValue: String]
    
    enum URLCase: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
