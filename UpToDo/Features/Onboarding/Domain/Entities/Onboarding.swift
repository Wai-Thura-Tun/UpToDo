//
//  Onboarding.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 6/12/2568 BE.
//

import Foundation

nonisolated
struct Onboarding: Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let image: String
    let btnLabel: String
    
    init(title: String, subtitle: String, image: String, btnLabel: String) {
        self.id = .init()
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.btnLabel = btnLabel
    }
    
    static let data: [Onboarding] = [
        .init(
            title: "Manage your tasks",
            subtitle: "You can easily manage all of your daily tasks in DoMe for free",
            image: "onboarding1",
            btnLabel: "NEXT"
        ),
        .init(
            title: "Create daily routine",
            subtitle: "In UpToDo you can create your personalized routine to stay productive",
            image: "onboarding2",
            btnLabel: "NEXT"
        ),
        .init(
            title: "Organize your tasks",
            subtitle: "You can organize your daily tasks by adding your tasks into separate categories",
            image: "onboarding3",
            btnLabel: "GET STARTED"
        )
    ]
}
