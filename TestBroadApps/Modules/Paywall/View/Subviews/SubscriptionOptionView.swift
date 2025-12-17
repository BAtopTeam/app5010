//
//  SubscriptionOptionView.swift
//  TestBroadApps
//
//  Created by Abylaikhan Abilkayr on 15.10.2025.
//

import SwiftUI

struct SubscriptionOptionView: View {
    var title: String
    var subtitle: String
    var price: String
    var discountText: String? = nil
    var isSelected: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(.orangeF86B0D, lineWidth: 1)
                    .frame(width: 20, height: 20)
                if isSelected {
                    Circle()
                        .fill(.orangeF86B0D)
                        .frame(width: 12, height: 12)
                }
            }
            
            VStack(alignment: .leading, spacing: .zero) {
                Text(title)
                    .font(.interMedium(size: 15))
                    .foregroundColor(.white)
                
                if discountText != nil {
                    Text(subtitle)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
            if let text = discountText {
                Text(text)
                    .font(.interMedium(size: 15))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 2)
                    .background(.black0D0F0D)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.orangeF86B0D, lineWidth: 1)
                    )
                    .padding(.trailing, 4)
            }
            Text(price)
                .font(.interSemiBold(size: 16))
                .foregroundColor(.white)
        }
        .padding(.vertical, (discountText != nil) ? 8 : 12)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray212321)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.orangeF86B0D : Color.gray212321, lineWidth: isSelected ? 2 : 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
