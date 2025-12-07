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
    
    init(title: String, subtitle: String, image: String) {
        self.id = .init()
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
    
    static let data: [Onboarding] = [
        .init(
            title: "Manage your tasks",
            subtitle: "You can easily manage all of your daily tasks in DoMe for free",
            image: "onboarding1"
        ),
        .init(
            title: "Create daily routine",
            subtitle: "In UpToDo you can create your personalized routine to stay productive",
            image: "onboarding2"
        
        ),
        .init(
            title: "Organize your tasks",
            subtitle: "You can organize your daily tasks by adding your tasks into separate categories",
            image: "onboarding3"
        )
    ]
}
