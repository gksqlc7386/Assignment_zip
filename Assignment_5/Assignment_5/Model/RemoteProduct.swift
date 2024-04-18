
import Foundation

//URLSession을 통해 가져올 Decodable Model
struct RemoteProduct : Decodable {
    let id: Int
    let thumbnail: URL
    let title: String
    let price: Double
    let description: String
}

