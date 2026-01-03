import SwiftUI

struct BookListView: View {
    @State private var books: [Book] = []
    @State private var searchText = "ios"
    private let booksService = BooksService()

    var body: some View {
        NavigationView {
            List(books) { book in
                NavigationLink(destination: BookDetailView(book: book)) {
                    HStack {
                        if let thumbnail = book.volumeInfo?.imageLinks?.thumbnail, let url = URL(string: thumbnail) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 50, height: 75)
                        }
                        VStack(alignment: .leading) {
                            Text(book.volumeInfo?.title ?? "Unknown Title")
                                .font(.headline)
                            Text(book.volumeInfo?.authors?.joined(separator: ", ") ?? "Unknown Author")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Library")
            .searchable(text: $searchText)
            .onChange(of: searchText) { newValue in
                Task {
                    /* minimal debounce or just fetch */
                   if !newValue.isEmpty {
                       try? await loadBooks()
                   }
                }
            }
            .task {
                try? await loadBooks()
            }
        }
    }

    private func loadBooks() async throws {
        /* In a real app we'd debounce, but for simplicity we fetch directly */
        books = try await booksService.fetchBooks(query: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchText)
    }
}
