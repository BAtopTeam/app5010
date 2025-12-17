import SwiftUI
import Kingfisher

struct SharePayload: Identifiable {
    let id = UUID()
    let items: [Any]
}

struct ResultView: View {
    
    @ObservedObject var viewModel: ResultViewModel
    @State private var sharePayload: SharePayload?
    
    var body: some View {
        ZStack {
            Color.black0D0F0D.ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                Spacer()
                
                if let result = viewModel.result, !result.isEmpty {
                    if result.starts(with: "http") {
                        KFImage(URL(string: result))
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal)
                            .padding(.bottom)
                    } else {
                        if let image = UIImage(contentsOfFile: result) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal)
                                .padding(.bottom)
                        } else {
                            Text("⚠️ Unable to load image")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                } else {
                    Text("⚠️ No image found")
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Spacer()
                
            }
        }
        .safeAreaInset(edge: .bottom) {
            resultButtons
                .padding(.horizontal)
                .padding(.top, 8)
                .background(Color.black0D0F0D.ignoresSafeArea(edges: .bottom))
        }
        .sheet(item: $sharePayload) { payload in
            ShareSheet(items: payload.items)
        }
        .overlay {
            alertView
        }
        .navigationBarHidden(true)
    }
    
    private var header: some View {
        let isLocal = !(viewModel.result?.starts(with: "http") ?? false)
        
        return HStack {
            Image(.backIcon)
                .resizable()
                .frame(width: 48.fitW, height: 48.fitW)
                .onTapGesture { viewModel.pop() }
            Spacer()
        }
        .overlay {
            Text(isLocal ? "Image" : "Effects")
                .font(.interSemiBold(size: 18))
                .foregroundStyle(.white)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }

    
    private var resultButtons: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 24)
                .fill(.orangeF86B0D)
                .frame(height: 44)
                .overlay {
                    HStack {
                        Image(.downloadIcon).resizable().frame(width: 24, height: 24)
                        Text("Download").font(.interMedium(size: 16)).foregroundStyle(.black0D0F0D)
                    }
                }
                .onTapGesture {
                    Task {
                        await viewModel.download()
                    }
                }
            
            RoundedRectangle(cornerRadius: 24)
                .fill(.black0D0F0D)
                .strokeBorder(Color.orangeF86B0D, lineWidth: 1.5)
                .frame(height: 44)
                .overlay {
                    HStack {
                        Image(.shareIcon).resizable().frame(width: 24, height: 24)
                        Text("Share").font(.interMedium(size: 16)).foregroundStyle(.white)
                    }
                }
                .onTapGesture {
                    Task {
                        guard let image = await viewModel.downloadImage() else { return }
                        await share(image)
                    }
                }
        }
    }
    
    
    // MARK: - Share logic
    private func share(_ image: UIImage) async {
        if let data = image.jpegData(compressionQuality: 0.95) {
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("effect-\(UUID().uuidString).jpg")
            do {
                try data.write(to: url, options: .atomic)
                await MainActor.run {
                    sharePayload = SharePayload(items: [url])
                }
                return
            } catch {
                print("⚠️ write temp failed:", error.localizedDescription)
            }
        }
        await MainActor.run {
            sharePayload = SharePayload(items: [image])
        }
    }
    @ViewBuilder
    private var alertView: some View {
        switch viewModel.showAlert {
        case .error:
            CustomAlertGenerationError(
                title: "Generation error",
                message: "Something went wrong. Try again",
                primaryButtonTitle: "Cancel",
                onPrimary: {
                    viewModel.showAlert = .none
                },
                secondaryButtonTitle: "Retry") {
                    print("Повторить")
                }
        case .save:
            CustomAlertView(
                title: "Saved",
                message: "The file has been successfully saved.",
                primaryButtonTitle: "Done"
            ) {
                viewModel.showAlert = .none
            }
        case .failed:
            CustomAlertView(
                title: "Failed",
                message: "The file could not be saved.",
                primaryButtonTitle: "Done"
            ) {
                viewModel.showAlert = .none
            }
        case .none:
            EmptyView()
        case .delete:
            CustomAlertDelete {
                viewModel.showAlert = .none
            } onSecondary: {
                print("Delete")
            }
            
        }
    }
}
