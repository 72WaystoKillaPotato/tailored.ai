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
    @State private var showingAddMeasurementView = false

    var body: some View {
        NavigationView {
            VStack {
                AdvancedList(viewModel.filteredMeasurements, content: { measurement in
                    MeasurementRow(attribute: measurement.id, value: Binding(
                        get: { self.viewModel.measurements[measurement.id, default: ""] },
                        set: { self.viewModel.measurements[measurement.id] = $0 }
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
                .searchable(text: $viewModel.searchText)
                
                Button("Add Custom Measurement") {
                    showingAddMeasurementView = true
                }
                .padding()
                .background(Color("colors/blue"))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
                .sheet(isPresented: $showingAddMeasurementView) {
                    AddMeasurementView(viewModel: viewModel)
                }
            }
            .navigationTitle("Your Measurements")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Delete measurements based on the index set
    func deleteMeasurement(at offsets: IndexSet) {
        offsets.forEach { index in
            let measurementID = viewModel.filteredMeasurements[index].id
            viewModel.measurements.removeValue(forKey: measurementID)
        }
    }
}

struct AddMeasurementView: View {
    @ObservedObject var viewModel: UserMeasurementsViewModel
    @State private var newAttribute = ""
    @State private var newValue = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack{
                Form {
                    TextField("Attribute (e.g., 'Arm Length')", text: $newAttribute)
                    TextField("Value (e.g., '34 inches')", text: $newValue)
                }
                Button("Add") {
                    guard !newAttribute.isEmpty && !newValue.isEmpty else { return }
                    saveData()
                    // Reset fields after adding
                    newAttribute = ""
                    newValue = ""
                    // Optionally dismiss the view or keep it for further additions
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(newAttribute.isEmpty || newValue.isEmpty)
            }
            .navigationTitle("Add New Measurement")
            .navigationBarItems(leading: Button("Cancel") {
                // Simply dismiss the view
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func saveData() {
        // Here you could write to UserDefaults, send to a server, or update a local database
        // For demonstration, print the measurements to the console
        viewModel.measurements[newAttribute] = newValue
        print("Saving Data: \(viewModel.measurements)")
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
