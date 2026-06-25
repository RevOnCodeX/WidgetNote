import SwiftUI

struct TaskRowView: View {
    @Binding var task: TaskItem
    var onCommit: () -> Void
    var onDelete: () -> Void
    var noteID: UUID?
    
    @State private var isEditing: Bool = false
    @State private var isHovering: Bool = false
    var settings = SettingsManager.shared
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Button(action: {
                withAnimation(AnimationManager.standardSpring) {
                    task.isCompleted.toggle()
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .accentColor : .secondary.opacity(0.6))
                    .font(.system(size: 14))
            }
            .buttonStyle(.plain)
            .padding(.top, 2)
            
            if isEditing {
                AppKitTextField(
                    placeholder: "Task",
                    text: $task.text,
                    onCommit: {
                        isEditing = false
                        if task.text.isEmpty {
                            onDelete()
                        } else {
                            onCommit()
                        }
                        if let id = noteID, let window = DesktopWindowManager.shared.controllers[id]?.window {
                            InteractionManager.shared.leaveEditMode(for: window)
                        }
                    },
                    onEscape: {
                        isEditing = false
                        if task.text.isEmpty {
                            onDelete()
                        }
                        if let id = noteID, let window = DesktopWindowManager.shared.controllers[id]?.window {
                            InteractionManager.shared.leaveEditMode(for: window)
                        }
                    },
                    identifier: "TaskField-\(task.id)"
                )
                .frame(minHeight: 24)
            } else {
                Text(task.text.isEmpty ? "New Task" : task.text)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(task.isCompleted ? .regular : .medium)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary.opacity(0.5) : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2) {
                        isEditing = true
                        if let id = noteID, let window = DesktopWindowManager.shared.controllers[id]?.window {
                            InteractionManager.shared.enterEditMode(for: window, targetFieldID: "TaskField-\(task.id)")
                        } else {
                            NSApplication.shared.activate(ignoringOtherApps: true)
                        }
                    }
            }
            
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .foregroundColor(.secondary)
                    .font(.system(size: 11, weight: .bold))
                    .padding(4)
                    .background(Color.secondary.opacity(0.15))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .opacity(isHovering ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.15), value: isHovering)
            .onHover { hovering in
                if hovering {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
        }
        .padding(.vertical, 3)
        .contentShape(Rectangle())
        .onHover { hovering in
            isHovering = hovering
        }
    }
}
