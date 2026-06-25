import SwiftUI

struct SettingsContent: View {
    let selectedTab: SettingsTab
    var settings = SettingsManager.shared
    
    var body: some View {
        ScrollView {
            VStack {
                switch selectedTab {
                case .general:
                    GeneralSettingsPane()
                case .appearance:
                    AppearanceSettingsPane()
                case .widgets:
                    WidgetsSettingsPane()
                case .shortcuts:
                    ShortcutsSettingsPane()
                case .behavior:
                    BehaviorSettingsPane()
                case .about:
                    AboutSettingsPane()
                }
            }
            .padding(.bottom, 40)
        }
        .id(selectedTab)
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
    }
}

// MARK: - Panes

struct GeneralSettingsPane: View {
    var settings = SettingsManager.shared
    
    var body: some View {
        SettingsSectionView(title: "Startup") {
            SettingsToggle(
                title: "Launch at Login",
                subtitle: "Automatically start WidgetNote when you log in",
                isOn: Bindable(settings).launchAtLogin
            )
            Divider()
            SettingsToggle(
                title: "Restore Widgets",
                subtitle: "Restore previously open widgets on launch",
                isOn: Bindable(settings).restoreWidgetsOnLaunch
            )
        }
        
        SettingsSectionView(title: "Reset") {
            Button(action: {
                SettingsManager.shared.resetAllSettings()
            }) {
                Text("Reset All Settings to Default")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
    }
}

struct ShortcutsSettingsPane: View {
    var body: some View {
        SettingsSectionView(title: "Local Shortcuts") {
            Text("These shortcuts are only active when WidgetNote is in focus.")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
            
            Divider()
            
            HStack {
                Text("Quick Capture")
                    .font(.system(size: 13, weight: .medium))
                Spacer()
                Text("⌥ Space")
                    .font(.system(size: 11, design: .monospaced))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(4)
            }
            
            Divider()
            
            HStack {
                Text("New Widget")
                    .font(.system(size: 13, weight: .medium))
                Spacer()
                Text("⇧ ⌘ N")
                    .font(.system(size: 11, design: .monospaced))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(4)
            }
            
            Divider()
            
            HStack {
                Text("Show All Widgets")
                    .font(.system(size: 13, weight: .medium))
                Spacer()
                Text("⇧ ⌘ A")
                    .font(.system(size: 11, design: .monospaced))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(4)
            }
        }
    }
}

struct BehaviorSettingsPane: View {
    var settings = SettingsManager.shared
    
    var body: some View {
        SettingsSectionView(title: "Visibility") {
            SettingsToggle(
                title: "Auto-Hide",
                subtitle: "Hide widgets when other applications are active or fullscreen",
                isOn: Bindable(settings).autoHideWhenActive
            )
            Divider()
            SettingsSlider(
                title: "Fade Duration",
                subtitle: "How quickly widgets fade in/out (seconds)",
                value: Bindable(settings).desktopFadeDuration,
                range: 0.1...1.0
            )
        }
        
        SettingsSectionView(title: "Animations") {
            SettingsSlider(
                title: "Hover Scale",
                subtitle: "Amount of magnification when hovering over a widget",
                value: Bindable(settings).hoverAnimationStrength,
                range: 1.0...1.05
            )
            Divider()
            SettingsSlider(
                title: "Spring Speed",
                subtitle: "Physics response time for insertions and expansions",
                value: Bindable(settings).springAnimationSpeed,
                range: 0.1...0.5
            )
        }
    }
}

struct WidgetsSettingsPane: View {
    var settings = SettingsManager.shared
    
    var body: some View {
        SettingsSectionView(title: "Default Size") {
            SettingsSlider(
                title: "Width",
                value: Bindable(settings).defaultWidgetWidth,
                range: 200...500
            )
            Divider()
            SettingsSlider(
                title: "Height",
                value: Bindable(settings).defaultWidgetHeight,
                range: 200...800
            )
        }
        
        SettingsSectionView(title: "Task Widget") {
            SettingsToggle(
                title: "Show Headers",
                isOn: Bindable(settings).showHeaders
            )
            Divider()
            SettingsToggle(
                title: "Show Completed Tasks",
                isOn: Bindable(settings).showCompletedTasks
            )
            Divider()
            SettingsToggle(
                title: "Auto-Sort Completed",
                subtitle: "Move checked tasks to the bottom",
                isOn: Bindable(settings).autoSortCompletedTasks
            )
        }
    }
}

struct AboutSettingsPane: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "note.text")
                .font(.system(size: 64))
                .foregroundColor(.accentColor)
                .padding(.top, 40)
            
            Text("WidgetNote")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Version 3.0.0 (Build 30)")
                .foregroundColor(.secondary)
            
            SettingsSectionView(title: "System Info") {
                HStack {
                    Text("macOS")
                    Spacer()
                    Text(ProcessInfo.processInfo.operatingSystemVersionString)
                        .foregroundColor(.secondary)
                }
                Divider()
                HStack {
                    Text("Architecture")
                    Spacer()
                    #if arch(arm64)
                    Text("Apple Silicon")
                        .foregroundColor(.secondary)
                    #else
                    Text("Intel")
                        .foregroundColor(.secondary)
                    #endif
                }
            }
        }
    }
}
