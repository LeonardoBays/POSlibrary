import Foundation

class BooksService {
    func fetchBooks(query: String) async throws -> [Book] {
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(query)") else {
            return []
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(BookResponse.self, from: data)
        return response.items ?? []
    }
}
