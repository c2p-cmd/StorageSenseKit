# StorageSenseKit

StorageSenseKit is a lightweight Swift library that simplifies tracking and displaying device storage information. It provides an intuitive API to access storage status, enabling developers to create polished and user-friendly UI components for storage management.

## Features
    • Retrieve current storage usage and availability with minimal effort.
    • Preformatted descriptions for easy display.
    • Seamless integration with SwiftUI and UIKit projects.
    • Modern Swift API design.

## Installation
    1. Add StorageSenseKit to your project using Swift Package Manager (SPM):
    2. Open your project in Xcode.
    3. Go to File > Add Packages....
    4. Enter the URL for this repository: [https://github.com/c2p-cmd/StorageSenseKit/].
    5. Select version v1.0.1, and click Add Package.

## Usage

Here’s an example of how to integrate StorageSenseKit into a SwiftUI view:
```swift
import OSLog
import StorageSenseKit
import SwiftUI

fileprivate let logger = Logger(subsystem: "com.yourapp", category: "StorageSettingsView")

struct StorageSettingsView: View {
    @State private var storageStatus: StorageStatus?

    var body: some View {
        List {
            if let storageStatus = storageStatus {
                ProgressView(value: storageStatus.usedFraction) {
                    Text("Space Available")
                        .font(.headline)
                }
                Text("\(storageStatus.description)")
                Text("\(storageStatus.formattedFreeSpace) Available")
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            do {
                storageStatus = try .create()
                logger.info("Storage status: \(storageStatus!.description)")
            } catch {
                logger.error("Failed to get storage status: \(error.localizedDescription)")
            }
        }
    }
}
```

## API Reference

### StorageStatus

A struct that provides device storage details:
    - `usedFraction`: A Double representing the fraction of used storage space.
    - `description`: A String summarizing the storage status.
    - `formattedFreeSpace`: A String indicating available storage.

### Methods
    - StorageStatus.create()
        - Initializes and returns a StorageStatus instance. This may throw an error if the storage data cannot be retrieved.

### Contributing

Contributions are welcome! If you encounter a bug or have a feature request, feel free to create an issue or submit a pull request.

### License

This project is licensed under the MIT License. See the LICENSE file for details.
