import SwiftUI
import CoreData

struct ReservedBooksView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Reservation.timestamp, ascending: true)],
        animation: .default)
    private var reservations: FetchedResults<Reservation>

    var body: some View {
        NavigationView {
            List {
                ForEach(reservations) { reservation in
                    VStack(alignment: .leading) {
                        Text("Book ID: \(reservation.bookId ?? "Unknown")")
                            .font(.headline)
                        Text("Reserved by: \(reservation.reserverName ?? "Unknown")")
                            .font(.subheadline)
                        if let date = reservation.timestamp {
                            Text("Date: \(date, formatter: itemFormatter)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Reservations")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { reservations[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
