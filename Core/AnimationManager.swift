import AppKit
import SwiftUI

struct AnimationManager {
    static let springResponse: Double = 0.25
    static let springDamping: Double = 0.8
    static let springDuration: TimeInterval = 0.15 // Requested quick-add expansion time
    
    // For SwiftUI
    static var standardSpring: Animation {
        .spring(response: springResponse, dampingFraction: springDamping)
    }
    
    static var quickSpring: Animation {
        .spring(response: 0.15, dampingFraction: 0.7)
    }
    
    // For AppKit Frame animations
    static func animate(duration: TimeInterval = springDuration, changes: @escaping () -> Void, completion: (() -> Void)? = nil) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = duration
            context.allowsImplicitAnimation = true
            // Approximate a spring curve matching SwiftUI's spring
            context.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.8, 0.4, 1.0)
            changes()
        }) {
            completion?()
        }
    }
}
