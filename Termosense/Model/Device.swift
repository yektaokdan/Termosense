//
//  Device.swift
//  Termosense
//
//  Created by trc vpn on 24.05.2024.
//

import Foundation
struct Device: Identifiable {
    let id = UUID()
    let name: String
    let mac: String
}
