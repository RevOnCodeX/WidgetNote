import SwiftUI

struct AppearanceSettingsPane: View {
    var settings = SettingsManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Live Preview Header
            VStack {
                Text("Live Preview")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
                
                SettingsPreview()
                    .frame(height: 140)
            }
            .padding(.top, 16)
            .padding(.bottom, 24)
            
            SettingsSectionView(title: "Material") {
                SettingsSlider(
                    title: "Blur Intensity",
                    value: Bindable(settings).blurIntensity,
                    range: 0.0...1.0
                )
                Divider()
                SettingsSlider(
                    title: "Opacity",
                    value: Bindable(settings).widgetOpacity,
                    range: 0.1...1.0
                )
            }
            
            SettingsSectionView(title: "Geometry") {
                SettingsSlider(
                    title: "Corner Radius",
                    value: Bindable(settings).cornerRadius,
                    range: 0.0...40.0
                )
                Divider()
                SettingsSlider(
                    title: "Shadow Strength",
                    value: Bindable(settings).shadowStrength,
                    range: 0.0...1.0
                )
            }
            
            SettingsSectionView(title: "Theme") {
                HStack {
                    Text("Appearance")
                        .font(.system(size: 13, weight: .medium))
                    Spacer()
                    Picker("", selection: Bindable(settings).appearanceMode) {
                        Text("System").tag(0)
                        Text("Light").tag(1)
                        Text("Dark").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 200)
                    .onChange(of: settings.appearanceMode) { _, _ in
                        AppearanceManager.shared.applyAppearance()
                    }
                }
            }
        }
    }
}

struct SettingsPreview: View {
    var settings = SettingsManager.shared
    
    var body: some View {
        // Reuse the WidgetContainer logic, but driven by settings explicitly
        ZStack {
            // Mock background wallpaper to show blur
            Image(systemName: "macwindow")
                .resizable()
                .scaledToFill()
                .opacity(0.05)
                .clipped()
            
            // The Preview Widget
            ZStack {
                VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow, state: .active)
                    .opacity(settings.blurIntensity)
                
                Color.black.opacity(0.01) // To catch clicks
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Circle()
                            .fill(Color(hex: settings.accentColorHex))
                            .frame(width: 12, height: 12)
                        Text("Preview Task")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                        Spacer()
                    }
                    
                    HStack(alignment: .top) {
                        Circle()
                            .stroke(Color.secondary, lineWidth: 1.5)
                            .frame(width: 16, height: 16)
                        Text("Edit widget properties below to see them update in real-time.")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 4)
                }
                .padding(20)
            }
            .frame(width: 280, height: 120)
            .background(Color.white.opacity(0.001))
            .cornerRadius(settings.cornerRadius)
            .opacity(settings.widgetOpacity)
            .shadow(color: Color.black.opacity(settings.shadowStrength), radius: 20, x: 0, y: 10)
        }
        .frame(maxWidth: .infinity)
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal, 24)
    }
}
