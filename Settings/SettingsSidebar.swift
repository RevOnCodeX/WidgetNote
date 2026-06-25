import SwiftUI

struct SettingsSidebar: View {
    @Binding var selectedTab: SettingsTab
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Settings")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 12)
            
            ForEach(SettingsTab.allCases, id: \.self) { tab in
                SidebarRow(
                    title: tab.rawValue,
                    icon: tab.icon,
                    isSelected: selectedTab == tab
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        selectedTab = tab
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct SidebarRow: View {
    let title: String
    let icon: String
    let isSelected: Bool
    
    @State private var isHovering = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 20, alignment: .center)
            
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .medium : .regular))
                .foregroundColor(isSelected ? .white : .primary)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isSelected ? Color.accentColor : (isHovering ? Color.secondary.opacity(0.1) : Color.clear))
        )
        .padding(.horizontal, 12)
        .onHover { hovering in
            isHovering = hovering
        }
        .contentShape(Rectangle())
    }
}
