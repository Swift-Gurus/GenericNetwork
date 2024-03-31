import Foundation

extension String {
    var nonEmptyOrNil: String? {
        self.isEmpty ? nil : self
    }
}
