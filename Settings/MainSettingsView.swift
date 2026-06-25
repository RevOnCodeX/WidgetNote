import SwiftUI

enum SettingsTab: String, CaseIterable {
    case general = "General"
    case appearance = "Appearance"
    case widgets = "Widgets"
    case shortcuts = "Shortcuts"
    case behavior = "Behavior"
    case about = "About"
    
    var icon: String {
        switch self {
        case .general: return "gearshape"
        case .appearance: return "paintpalette"
        case .widgets: return "macwindow.on.rectangle"
        case .shortcuts: return "command"
        case .behavior: return "slider.horizontal.3"
        case .about: return "info.circle"
        }
    }
}

struct MainSettingsView: View {
    @State private var selectedTab: SettingsTab = .general
    
    var body: some View {
        HStack(spacing: 0) {
            // Sidebar
            SettingsSidebar(selectedTab: $selectedTab)
                .frame(width: 180)
            
            Divider()
            
            // Content
            ZStack {
                // Background material for content
                VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow, state: .active)
                    .edgesIgnoringSafeArea(.all)
                
                SettingsContent(selectedTab: selectedTab)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 680, height: 520)
        // Background material for the whole window
        .background(VisualEffectBlur(material: .sidebar, blendingMode: .behindWindow, state: .active))
    }
}


