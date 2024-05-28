
import SwiftUI
struct SensorDataRow: View {
    var icon: String
    var label: String
    var value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text(label)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
        }
    }
}
