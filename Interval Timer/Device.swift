//
//  Model.swift
//  Interval Timer
//
//  Created by Wiley Conte on 6/8/20.
//  Copyright © 2020 Wiley Conte. All rights reserved.
//

import Combine

final class Device: ObservableObject {
    @Published var isLandscape: Bool = false
}
