import SwiftUI
import AdvancedList

struct MeasurementRow: View {
    var attribute: String
    @Binding var value: String
    @FocusState var focusedField: String?

    var body: some View {
        HStack {
            Text("\(attribute):")
                .foregroundColor(.gray)
            Spacer()
            TextField("Enter \(attribute)", text: $value)
                .focused($focusedField, equals: attribute)
                .onChange(of: focusedField) {
                    // This closure will be called whenever the focus state changes.
                    if focusedField != attribute {
                        // The TextField lost focus, save the data
                        print("Saving data for \(attribute)")
                        // Implement the save action here, such as updating the ViewModel or model.
                    }
                }
        }
    }
}

struct UserProfileView: View {
    @StateObject var viewModel = UserMeasurementsViewModel()
    @State private var searchText = ""
    @State private var showingAddMeasurementView = false

    var body: some View {
        NavigationView {
            AdvancedList(viewModel.filteredMeasurements, content: { measurement in
                MeasurementRow(attribute: measurement.id, value: .init(
                    get: { measurement.value },
                    set: { viewModel.measurements[measurement.id] = $0 }
                ))
            }, listState: .items, emptyStateView: {
                Text("No data")
            }, errorStateView: { error in
                Text("An error occurred: \(error.localizedDescription)")
            }, loadingStateView: {
                Text("Loading...")
            })
            .onDelete { indexSet in
                deleteMeasurement(at: indexSet)
            }
            .searchable(text: $viewModel.searchText) // Provided by SwiftUI, not AdvancedList
        }
    }
    // Delete measurements based on the index set
        func deleteMeasurement(at offsets: IndexSet) {
            offsets.forEach { index in
                let measurementID = viewModel.filteredMeasurements[index].id
                viewModel.measurements.removeValue(forKey: measurementID)
            }
            // Call any additional functions if necessary to save changes, update views, etc.
        }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
