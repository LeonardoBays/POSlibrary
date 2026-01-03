import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            BookListView()
                .tabItem {
                    Label("Books", systemImage: "book")
                }
            
            ReservedBooksView()
                .tabItem {
                    Label("Reservations", systemImage: "bookmark")
                }
        }
    }
}
