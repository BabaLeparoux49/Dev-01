import Foundation
import Combine

@MainActor
final class HistoryStore: ObservableObject {
    @Published var items: [SavedCalculation] = []

    private let key = "ufrais.calculations.history"

    init() {
        load()
    }

    func save(_ item: SavedCalculation) {
        items.insert(item, at: 0)
        persist()
    }

    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        persist()
    }

    func clear() {
        items.removeAll()
        persist()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([SavedCalculation].self, from: data) else {
            return
        }
        items = decoded
    }
}
