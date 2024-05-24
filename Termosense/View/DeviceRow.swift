//
//  DeviceRow.swift
//  Termosense
//
//  Created by trc vpn on 24.05.2024.
//

import SwiftUI
struct DeviceRow: View {
    var device: Device
    var onTap: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(device.name)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.white)
                
                Text(device.mac)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(Color.white)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("backGreen").opacity(0.8))
                .shadow(color: Color("backGreen").opacity(0.4), radius: 10, x: 0, y: 5)
        )
        .onTapGesture {
            onTap()
        }
    }
}

