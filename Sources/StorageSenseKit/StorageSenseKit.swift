import Foundation
import OSLog

fileprivate let logger = Logger(subsystem: "StorageSenceKit", category: "StorageStatus")

/// StorageSenseKit is a library for getting storage status of the device
/// - Note: This library is only available on iOS, watchOS, macOS, tvOS, and visionOS
/// - Version: 1.0.0
public struct StorageStatus: CustomStringConvertible {
    /// Size of the file system in bytes
    public let systemSize: Int64
    
    /// Free space in bytes
    public let freeSpace: Int64
    
    /// Create a new storage status object by passing system size and free space (in bytes)
    public init(systemSize: Int64, freeSpace: Int64) {
        self.systemSize = systemSize
        self.freeSpace = freeSpace
        
        // create formatter
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB]
        formatter.countStyle = .file
        self.byteFormatter = formatter
    }
    
    /// Formatter for bytes
    private let byteFormatter: ByteCountFormatter
    
    /// Used space in bytes
    public var usedSpace: Int64 {
        systemSize - freeSpace
    }
    
    /// Formatted free space
    public var formattedFreeSpace: String {
        byteFormatter.string(fromByteCount: freeSpace)
    }
    
    /// Used space as a fraction of the system size
    public var usedFraction: Double {
        Double(usedSpace) / Double(systemSize)
    }
    
    /// Formatted description of the storage status
    public var description: String {
        let usedSpace = byteFormatter.string(fromByteCount: usedSpace)
        let systemSize = byteFormatter.string(fromByteCount: systemSize)
        let usedPercentage = String(format: "%.2f", usedFraction * 100)
        return "\(usedSpace) used out of \(systemSize) (\(usedPercentage)%)"
    }
}


/// Create a new storage status object
extension StorageStatus {
    /// Create a new storage status object
    /// - Throws: `StorageError` if the storage status cannot be retrieved
    /// - Returns: A new `StorageStatus` object
    public static func create() throws(StorageError) -> StorageStatus {
        let url = URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
        do {
            let values = try url.resourceValues(
                forKeys: [.volumeAvailableCapacityForImportantUsageKey]
            )
            guard let freeSpace = values.volumeAvailableCapacityForImportantUsage else {
                throw StorageError()
            }
            let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            guard let systemSize = systemAttributes[.systemSize] as? Int64 else {
                throw StorageError()
            }
            return StorageStatus(systemSize: systemSize, freeSpace: freeSpace)
        } catch {
            logger.error("Failed with error: \(error)")
            throw StorageError()
        }
    }
}

/// Storage error
/// - Note: This error is thrown when the storage status cannot be retrieved
public struct StorageError: LocalizedError, CustomStringConvertible {
    /// Error description
    public var errorDescription: String? { description }
    
    /// Description of the error
    public var description: String {
        "Failed to get storage status"
    }
}
