
import Foundation
struct ErrorMessage: Identifiable, Equatable {
    let id = UUID()
    let message: String

    static func ==(lhs: ErrorMessage, rhs: ErrorMessage) -> Bool {
        return lhs.id == rhs.id
    }
}

