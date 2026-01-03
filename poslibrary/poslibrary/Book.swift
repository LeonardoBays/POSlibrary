import Foundation

struct Book: Identifiable, Decodable {
    let id: String
    let volumeInfo: VolumeInfo?
    
    struct VolumeInfo: Decodable {
        let title: String?
        let authors: [String]?
        let description: String?
        let imageLinks: ImageLinks?
    }
    
    struct ImageLinks: Decodable {
        let thumbnail: String?
    }
}

struct BookResponse: Decodable {
    let items: [Book]?
}
