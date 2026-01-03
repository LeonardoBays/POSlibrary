import SwiftUI
import CoreData

struct BookDetailView: View {
    let book: Book
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingReservationSheet = false
    @State private var reserverName = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let thumbnail = book.volumeInfo?.imageLinks?.thumbnail, let url = URL(string: thumbnail) {
                    HStack {
                        Spacer()
                        AsyncImage(url: url) { image in
                            image.resizable().aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Color.gray
                        }
                        .frame(height: 200)
                        Spacer()
                    }
                }
                
                Text(book.volumeInfo?.title ?? "Unknown Title")
                    .font(.largeTitle)
                    .padding(.horizontal)
                
                Text(book.volumeInfo?.authors?.joined(separator: ", ") ?? "Unknown Author")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                Text(book.volumeInfo?.description ?? "No description available.")
                    .padding()
                
                Button(action: {
                    showingReservationSheet = true
                }) {
                    Text("Reserve This Book")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingReservationSheet) {
            VStack(spacing: 20) {
                Text("Confirm Reservation")
                    .font(.title)
                
                TextField("Enter your name", text: $reserverName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Confirm") {
                    addReservation()
                    showingReservationSheet = false
                }
                .disabled(reserverName.isEmpty)
                .padding()
                
                Button("Cancel") {
                    showingReservationSheet = false
                }
                .foregroundColor(.red)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func addReservation() {
        withAnimation {
            let newReservation = Reservation(context: viewContext)
            newReservation.timestamp = Date()
            newReservation.bookId = book.id
            newReservation.reserverName = reserverName

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
