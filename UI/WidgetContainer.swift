import SwiftUI

struct WidgetContainer<Content: View>: View {
    let content: Content
    
    @State private var isHovered = false
    var settings = SettingsManager.shared
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(16)
            .background(
                VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow, state: .active)
                    .opacity(settings.blurIntensity)
            )
            .background(Color.white.opacity(0.001))
            .cornerRadius(settings.cornerRadius)
            .opacity(settings.widgetOpacity)
            // Hover Effects
            .shadow(color: .black.opacity(isHovered ? settings.shadowStrength * 1.5 : settings.shadowStrength), radius: isHovered ? 12 : 8, x: 0, y: isHovered ? 6 : 2)
            .scaleEffect(isHovered ? settings.hoverAnimationStrength : 1.0)
            .brightness(isHovered ? 0.02 : 0.0)
            .animation(.spring(response: settings.springAnimationSpeed, dampingFraction: 0.6), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
            // Add transparent padding so the window can hold the scaled widget without clipping
            .padding(8)
    }
}
