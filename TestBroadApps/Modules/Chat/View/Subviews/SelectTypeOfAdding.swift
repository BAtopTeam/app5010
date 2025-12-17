import SwiftUI

struct SelectTypeOfAddingSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var gallerySelect: () -> Void
    var cameraSelect: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.white.opacity(0.3))
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            VStack(spacing: 8) {
                Button {
                    gallerySelect()
                    dismiss()
                } label: {
                    Text("Add from Gallery")
                        .font(.interMedium(size: 16))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.gray212321)
                        )
                }
                .buttonStyle(.plain)
                
                Button {
                    cameraSelect()
                    dismiss()
                } label: {
                    Text("Add from Camera")
                        .font(.interMedium(size: 16))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.gray212321)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(height: 180)
        .background(Color.black0D0F0D)
        .clipShape(RoundedRectangle(cornerRadius: 40))
    }
}
