import Foundation

public enum DiskDirectory: Equatable {
    /// Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored in the <Application_Home>/Documents directory.
    /// Files in this directory are automatically backed up by iCloud. To disable this feature for a specific file, use the .doNotBackup(:in:) method.
    case documents

    /// Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications.
    /// Use this directory to write any application-specific support files that you want to persist between launches of the application or during application updates. Your application is generally responsible for adding and removing these files. It should also be able to re-create these files as needed because iTunes removes them during a full restoration of the device. In iOS 2.2 and later, the contents of this directory are not backed up by iTunes.
    /// Note that the system may delete the Caches/ directory to free up disk space, so your app must be able to re-create or download these files as needed.
    case caches
}
