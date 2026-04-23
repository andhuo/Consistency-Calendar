//
//  DayDetailView.swift
//  Consistency Calendar
//
//  Created by Andy Huoy on 4/23/26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct DayDetailView: View {
    let date: Date

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var checkIns: [CheckIn]

    @State private var noteText: String = ""
    @State private var isCompleted: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var photoData: Data?

    private let calendar = Calendar.current

    private var existingCheckIn: CheckIn? {
        checkIns.first(where: { calendar.isDate($0.date, inSameDayAs: date) })
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Date") {
                    Text(formattedDate(date))
                }

                Section("Progress") {
                    Toggle("Completed", isOn: $isCompleted)
                }

                Section("Notes") {
                    TextEditor(text: $noteText)
                        .frame(minHeight: 120)
                }

                Section("Photo") {
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Label("Select Photo", systemImage: "photo")
                    }

                    if let photoData,
                       let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }

                Section {
                    Button("Save Day Entry") {
                        saveDayEntry()
                    }
                }
            }
            .navigationTitle("Day Details")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadExistingCheckIn()
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        photoData = data
                    }
                }
            }
        }
    }

    private func loadExistingCheckIn() {
        if let checkIn = existingCheckIn {
            noteText = checkIn.note
            isCompleted = checkIn.isCompleted
            photoData = checkIn.photoData
        }
    }

    private func saveDayEntry() {
        if let checkIn = existingCheckIn {
            checkIn.note = noteText
            checkIn.isCompleted = isCompleted
            checkIn.photoData = photoData
        } else {
            let newCheckIn = CheckIn(
                date: date,
                isCompleted: isCompleted,
                note: noteText,
                photoData: photoData
            )
            modelContext.insert(newCheckIn)
        }

        dismiss()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

#Preview {
    DayDetailView(date: Date())
        .modelContainer(for: [Goal.self, CheckIn.self], inMemory: true)
}
