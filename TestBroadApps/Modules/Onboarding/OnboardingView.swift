//
//  OnboardingView.swift
//  TestBroadApps
//
//  Created by Abylaikhan Abilkayr on 12.10.2025.
//

import Foundation
import SwiftUI
import StoreKit
import ApphudSDK

struct OnboardingView: View {
    
    @State private var step: Int = 0
    @State private var isShowingAlert: Bool = false
    @AppStorage("didShowPaywallAfterStep2") private var didShowPaywallAfterStep2 = false
    @State private var showPaywall = false

    var closeOnboard: () -> Void
    
    var body: some View {
        ZStack {
            Group {
                if step == 0 {
                    VStack {
                        Spacer()
                        
                        Image(.onb1)
                            .resizable()
                            .frame(maxWidth: .infinity)
                            .frame(height: 474.fitH)
                        bottomButtonFirst
                    }
                    
                } else if step == 1 {
                    VStack {
                        Spacer()
                        Image(.onb2)
                            .resizable()
                            .frame(maxWidth: .infinity)
                            .frame(height: 474.fitH)
                        
                        bottomButtonSecond
                    }
                    
                } else if step == 2 {
                    VStack {
                        Spacer()
                        
                        Image(.onb3)
                            .resizable()
                            .frame(maxWidth: .infinity)
                            .frame(height: 530.fitH)
                        
                        bottomButtonThird
                    }
                    
                }
            }
            .background(.black0D0F0D)
            .overlay(alignment: .top) {
                progressHeader
            }
            
            if showPaywall {
                PaywallView {
                    withAnimation {
                        closeOnboard()
                    }
                }
                .transition(.opacity)
                .zIndex(2)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: showPaywall)
    }

    private var bottomButtonFirst: some View {
        VStack(alignment: .center) {
            Text("Welcome to the app")
                .font(.interSemiBold(size: 26.fitW))
                .foregroundStyle(.white)
                .padding(.bottom, 12)
            
            Text("Turn your ideas into stunning visuals and bring your imagination to life with AI.")
                .font(.interMedium(size: 16.fitW))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40.fitW)
                .padding(.bottom, 24)
            
            Button {
                step = 1
            } label: {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.orangeF86B0D)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .overlay {
                        Text("Continue")
                            .font(.interMedium(size: 16))
                            .foregroundStyle(.black0D0F0D)
                    }
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .padding(.top)
        .background(.black0D0F0D)
        .clipShape(.rect(topLeadingRadius: 24, topTrailingRadius: 24))
    }
    
    private var bottomButtonSecond: some View {
        VStack(alignment: .center) {
            Text("Just describe your idea")
                .font(.interSemiBold(size: 26.fitW))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30.fitW)
                .padding(.bottom)
            
            Text("Type what you imagine, and Velora brings it to life.")
                .font(.interMedium(size: 16.fitW))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40.fitW)
                .padding(.bottom, 24)
            
            Button {
                step = 2
                requestReviewOrOpenStore()
            } label: {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.orangeF86B0D)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .overlay {
                        Text("Continue")
                            .font(.interMedium(size: 16))
                            .foregroundStyle(.black0D0F0D)
                    }
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .padding(.top)
        .background(.black0D0F0D)
        .clipShape(.rect(topLeadingRadius: 24, topTrailingRadius: 24))
    }

    private var bottomButtonThird: some View {
        VStack(alignment: .center) {
            Text("Discover & share")
                .font(.interSemiBold(size: 26.fitW))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30.fitW)
                .padding(.bottom)

            Text("Explore trending styles or share your favorites with friends.")
                .font(.interMedium(size: 16.fitW))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40.fitW)
                .padding(.bottom, 24)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                if !didShowPaywallAfterStep2 {
                    didShowPaywallAfterStep2 = true
                    if !Apphud.hasPremiumAccess() {
                        showPaywall = true
                    }
                } else {
                    closeOnboard()
                }
            } label: {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.orangeF86B0D)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .overlay {
                        Text("Continue")
                            .font(.interMedium(size: 16))
                            .foregroundStyle(.black0D0F0D)
                    }
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .padding(.top)
        .background(.black0D0F0D)
        .clipShape(.rect(topLeadingRadius: 24, topTrailingRadius: 24))
    }

    
    private var bottomButtonFourth: some View {
        VStack(alignment: .center) {
            Text("Loved by creators")
                .font(.interSemiBold(size: 26.fitW))
                .foregroundStyle(.white)
                .padding(.bottom)
            
            Text("See why people enjoy creating with Velora.")
                .font(.interMedium(size: 16.fitW))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40.fitW)
                .padding(.bottom, 24)
            
            Button {
                closeOnboard()
            } label: {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.orangeF86B0D)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .overlay {
                        Text("Get Started")
                            .font(.interMedium(size: 16))
                            .foregroundStyle(.black0D0F0D)
                    }
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .padding(.top)
        .background(.black0D0F0D)
        .clipShape(.rect(topLeadingRadius: 24, topTrailingRadius: 24))
    }
    
    private let totalSteps = 3

    private var progressHeader: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack(spacing: 4) {
                ForEach(0..<totalSteps, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(index <= step ? Color.orangeF86B0D : Color.grayB9B9B9.opacity(0.3))
                        .frame(height: 2)
                }
            }
            
            if step != 2 {
                Text("Skip")
                    .font(.interSemiBold(size: 16))
                    .foregroundStyle(.black101010.opacity(0.5))
                    .padding(.horizontal, 13)
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        step = 3
                        requestReviewOrOpenStore()
                    }
            }
        }
        .padding(.top, 8)
        .padding(.horizontal)
    }
    
    func requestReviewOrOpenStore() {
        if let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

#Preview {
    OnboardingView {
        print("S")
    }
}
