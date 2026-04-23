//
//  AddGoalView.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/22/26.
//

import SwiftUI
import SwiftData
import MapKit
import CoreLocation
import Combine

final class CurrentLocationPicker: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var currentCoordinate: CLLocationCoordinate2D?
    @Published var currentLocationName: String = "Current Location"

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    func requestLocation() {
        let status = manager.authorizationStatus
        authorizationStatus = status

        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            currentLocationName = "Location Access Denied"
        @unknown default:
            currentLocationName = "Current Location"
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentCoordinate = location.coordinate
        currentLocationName = "Current Location"
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocationName = "Current Location"
    }
}

struct AddGoalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @StateObject private var currentLocationPicker = CurrentLocationPicker()

    @State private var title = ""
    @State private var category = ""
    @State private var type: GoalType = .manual
    @State private var startDate = Date()
    @State private var reminderEnabled = false
    @State private var reminderHour = 9
    @State private var reminderMinute = 0
    @State private var targetValueText = ""

    @State private var locationSearchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedMapItem: MKMapItem?
    @State private var mapCameraPosition: MapCameraPosition = .automatic
    @State private var showingSaveError = false
    @State private var saveErrorMessage = ""

    let templates = GoalTemplates.presets

    var body: some View {
        NavigationStack {
            Form {
                Section("Preset Suggestions") {
                    ForEach(templates) { template in
                        Button {
                            applyTemplate(template)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(template.title)
                                    .foregroundStyle(.primary)

                                Text("\(template.category) • \(template.type.rawValue)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Goal Details") {
                    TextField("Title", text: $title)
                    TextField("Category", text: $category)

                    Picker("Goal Type", selection: $type) {
                        ForEach(GoalType.allCases) { goalType in
                            Text(goalType.rawValue).tag(goalType)
                        }
                    }

                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                }

                if type == .health {
                    Section("Health Goal Settings") {
                        TextField("Target steps (example: 10000)", text: $targetValueText)
                            .keyboardType(.numberPad)
                    }
                }

                if type == .location {
                    Section("Location Goal Settings") {
                        TextField("Search for a place", text: $locationSearchText)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()

                        Button("Search Map") {
                            Task {
                                await searchForPlaces()
                            }
                        }
                        .disabled(locationSearchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                        Button("Use My Current Location") {
                            currentLocationPicker.requestLocation()
                        }

                        if let coordinate = currentLocationPicker.currentCoordinate {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Current Location")
                                    .font(.headline)

                                Text(currentLocationPicker.currentLocationName)
                                    .font(.subheadline)

                                Text("Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Button("Use This Location") {
                                let placemark = MKPlacemark(coordinate: coordinate)
                                let mapItem = MKMapItem(placemark: placemark)
                                mapItem.name = currentLocationPicker.currentLocationName
                                selectMapItem(mapItem)
                            }
                        }

                        if let selectedMapItem {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Selected Location")
                                    .font(.headline)

                                Text(selectedMapItem.name ?? "Unknown Place")
                                    .font(.subheadline)
                            }
                        }

                        if !searchResults.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Search Results")
                                    .font(.headline)

                                ForEach(searchResults, id: \.self) { item in
                                    Button {
                                        selectMapItem(item)
                                    } label: {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.name ?? "Unknown Place")
                                                .foregroundStyle(.primary)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }

                        Map(position: $mapCameraPosition) {
                            if let selectedMapItem {
                                Marker(
                                    selectedMapItem.name ?? "Selected Location",
                                    coordinate: selectedMapItem.placemark.coordinate
                                )
                            }
                        }
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }

                Section("Reminder") {
                    Toggle("Enable Reminder", isOn: $reminderEnabled)

                    if reminderEnabled {
                        DatePicker(
                            "Reminder Time",
                            selection: reminderDateBinding,
                            displayedComponents: .hourAndMinute
                        )
                    }
                }

                Section {
                    Button("Save Goal") {
                        saveGoal()
                    }
                    .disabled(isSaveDisabled)
                }
            }
            .navigationTitle("Add Goal")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Could Not Save Goal", isPresented: $showingSaveError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(saveErrorMessage)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var reminderDateBinding: Binding<Date> {
        Binding<Date>(
            get: {
                var components = DateComponents()
                components.hour = reminderHour
                components.minute = reminderMinute
                return Calendar.current.date(from: components) ?? Date()
            },
            set: { newValue in
                let components = Calendar.current.dateComponents([.hour, .minute], from: newValue)
                reminderHour = components.hour ?? 9
                reminderMinute = components.minute ?? 0
            }
        )
    }

    private var isSaveDisabled: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        (type == .health && targetValueText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ||
        (type == .location && selectedMapItem == nil)
    }

    private func applyTemplate(_ template: GoalTemplate) {
        title = template.title
        category = template.category
        type = template.type

        if let targetValue = template.targetValue {
            targetValueText = String(Int(targetValue))
        } else {
            targetValueText = ""
        }

        if template.type != .location {
            locationSearchText = ""
            searchResults = []
            selectedMapItem = nil
        }
    }

    private func selectMapItem(_ item: MKMapItem) {
        selectedMapItem = item
        locationSearchText = item.name ?? ""

        mapCameraPosition = .region(
            MKCoordinateRegion(
                center: item.placemark.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }

    private func searchForPlaces() async {
        let trimmedQuery = locationSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = trimmedQuery

        do {
            let response = try await MKLocalSearch(request: request).start()
            await MainActor.run {
                searchResults = Array(response.mapItems.prefix(5))
                selectedMapItem = nil

                if let firstResult = searchResults.first {
                    mapCameraPosition = .region(
                        MKCoordinateRegion(
                            center: firstResult.placemark.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                        )
                    )
                }
            }
        } catch {
            await MainActor.run {
                searchResults = []
            }
        }
    }

    private func saveGoal() {
        let parsedTargetValue = Double(targetValueText)
        let coordinate = selectedMapItem?.placemark.coordinate

        let newGoal = Goal(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category.trimmingCharacters(in: .whitespacesAndNewlines),
            type: type,
            startDate: startDate,
            reminderEnabled: reminderEnabled,
            reminderHour: reminderHour,
            reminderMinute: reminderMinute,
            targetValue: parsedTargetValue,
            targetLocationName: selectedMapItem?.name,
            targetLatitude: coordinate?.latitude,
            targetLongitude: coordinate?.longitude
        )

        modelContext.insert(newGoal)

        do {
            try modelContext.save()
            print("Saved goal: \(newGoal.title)")
            dismiss()
        } catch {
            saveErrorMessage = error.localizedDescription
            showingSaveError = true
        }
    }
}

#Preview {
    AddGoalView()
        .modelContainer(for: [Goal.self, CheckIn.self], inMemory: true)
}
