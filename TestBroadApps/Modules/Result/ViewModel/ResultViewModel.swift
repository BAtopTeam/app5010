import Foundation
import UIKit
import Kingfisher
import Photos

@MainActor
final class ResultViewModel: ObservableObject {

    @Published var result: String?
    @Published var showAlert: AlertType = .none

    private var router: Router

    init(result: String?, router: Router) {
        self.result = result
        self.router = router
    }

    func pop() { router.pop() }

    func loadUIImage() async -> UIImage? {
        guard let result, !result.isEmpty else { return nil }

        if result.starts(with: "http") {
            guard let url = URL(string: result) else { return nil }
            do {
                return try await KingfisherManager.shared.retrieveImage(with: url).image
            } catch {
                print("❌ Failed to load from network:", error.localizedDescription)
                return nil
            }
        } else {
            return UIImage(contentsOfFile: result)
        }
    }

    // ✅ permission check
    private func ensureAddToPhotosPermission() async -> Bool {
        if #available(iOS 14, *) {
            let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
            switch status {
            case .authorized:
                return true
            case .notDetermined:
                let newStatus = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
                return newStatus == .authorized
            default:
                return false
            }
        } else {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                return true
            case .notDetermined:
                let newStatus = await withCheckedContinuation { cont in
                    PHPhotoLibrary.requestAuthorization { cont.resume(returning: $0) }
                }
                return newStatus == .authorized
            default:
                return false
            }
        }
    }

    // MARK: - Download (Save to Photos)
    func download() async {
        guard let image = await loadUIImage() else {
            showAlert = .failed
            return
        }

        let allowed = await ensureAddToPhotosPermission()
        guard allowed else {
            showAlert = .failed   // или сделай отдельный тип алерта "no access"
            return
        }

        await withCheckedContinuation { cont in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.showAlert = .save
                    } else {
                        self.showAlert = .failed
                        print("❌ Save failed:", error?.localizedDescription ?? "unknown")
                    }
                    cont.resume()
                }
            }
        }
    }

    func downloadImage() async -> UIImage? {
        await loadUIImage()
    }
}
