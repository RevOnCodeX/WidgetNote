import SwiftUI

struct NoteCardView: View {
    var noteID: UUID
    
    private var noteBinding: Binding<Note>? {
        guard let index = DataStore.shared.notes.firstIndex(where: { $0.id == noteID }) else { return nil }
        return Binding(
            get: { DataStore.shared.notes[index] },
            set: { DataStore.shared.notes[index] = $0 }
        )
    }
    
    var body: some View {
        Group {
            if let binding = noteBinding {
                NoteContentView(note: binding)
            } else {
                Text("Note not found")
                    .padding()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct NoteContentView: View {
    @Binding var note: Note
    
    @State private var isHovering: Bool = false
    @State private var isEditingTitle: Bool = false
    var settings = SettingsManager.shared
    
    var body: some View {
        WidgetContainer {
            VStack(alignment: .leading, spacing: 10) {
                // Header
                if settings.showHeaders {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 12, height: 12)
                        
                        Button(action: {
                            SettingsWindowController.shared.openSettings()
                        }) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.secondary)
                                .font(.system(size: 11))
                        }
                        .buttonStyle(.plain)
                        .help("WidgetNote Settings")
                        
                        Spacer().frame(width: 4)
                        
                        if isEditingTitle {
                            AppKitTextField(
                                placeholder: "Title",
                                text: $note.title,
                                onCommit: {
                                    isEditingTitle = false
                                    if let window = DesktopWindowManager.shared.controllers[note.id]?.window {
                                        InteractionManager.shared.leaveEditMode(for: window)
                                    }
                                },
                                onEscape: {
                                    isEditingTitle = false
                                    if let window = DesktopWindowManager.shared.controllers[note.id]?.window {
                                        InteractionManager.shared.leaveEditMode(for: window)
                                    }
                                },
                                identifier: "TitleField-\(note.id)"
                            )
                            .frame(height: 24)
                            .font(.system(.title3, design: .rounded).weight(.semibold))
                        } else {
                            Text(note.title.isEmpty ? "New Note" : note.title)
                                .font(.system(.title3, design: .rounded, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture(count: 2) {
                                    if let window = DesktopWindowManager.shared.controllers[note.id]?.window {
                                        InteractionManager.shared.enterEditMode(for: window, targetFieldID: "TitleField-\(note.id)")
                                    }
                                    isEditingTitle = true
                                }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            DesktopWindowManager.shared.createNewNote()
                        }) {
                            Image(systemName: "square.and.pencil")
                                .foregroundColor(.secondary)
                                .padding(4)
                                .background(Color.secondary.opacity(isHovering ? 0.1 : 0.0))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .animation(.easeInOut(duration: 0.15), value: isHovering)
                        
                        Button(action: {
                            DesktopWindowManager.shared.closeWindow(for: note.id)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary.opacity(isHovering ? 1.0 : 0.6))
                        }
                        .buttonStyle(.plain)
                        .help("Close Note")
                        .animation(.easeInOut(duration: 0.15), value: isHovering)
                    }
                    .padding(.bottom, 6)
                    .onHover { h in isHovering = h }
                    
                    Divider()
                        .opacity(0.3)
                }
                
                // Tasks
                if note.tasks.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 32))
                            .foregroundColor(Color.accentColor.opacity(0.4))
                            .padding(.bottom, 8)
                        Text("No tasks yet")
                            .font(.system(.body, design: .rounded, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("Press + to add one")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary.opacity(0.6))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 4) {
                            let filteredTasks = note.tasks.filter { settings.showCompletedTasks || !$0.isCompleted }
                            let sortedTasks = settings.autoSortCompletedTasks ? filteredTasks.sorted(by: { t1, t2 in
                                if t1.isCompleted == t2.isCompleted {
                                    return t1.order < t2.order
                                }
                                return !t1.isCompleted && t2.isCompleted
                            }) : filteredTasks.sorted(by: { $0.order < $1.order })
                            
                            ForEach(sortedTasks) { task in
                                if let index = note.tasks.firstIndex(where: { $0.id == task.id }) {
                                    TaskRowView(task: Binding(
                                        get: { self.note.tasks[index] },
                                        set: { self.note.tasks[index] = $0 }
                                    ), onCommit: {
                                        // Handled
                                    }, onDelete: {
                                        deleteTask(at: index)
                                    }, noteID: note.id)
                                    .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .opacity))
                                }
                            }
                        }
                        .animation(AnimationManager.standardSpring, value: note.tasks.map { "\($0.id)-\($0.isCompleted)-\($0.order)" })
                    }
                }
                
                Divider()
                    .opacity(0.3)
                
                // Expansion Logic
                if WidgetExpansionManager.shared.expandedNoteID == note.id {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "circle")
                                .foregroundColor(.secondary.opacity(0.4))
                                .font(.system(size: 14))
                            
                            AppKitTextField(
                                placeholder: "New task...",
                                text: Bindable(WidgetExpansionManager.shared).newTaskText,
                                onCommit: { commitQuickAdd() },
                                onEscape: { DesktopWindowManager.shared.collapseWindow(for: note.id, discardText: true) },
                                identifier: "QuickAddField-\(note.id)"
                            )
                            .frame(height: 24)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                        
                        HStack {
                            Button("Cancel") {
                                DesktopWindowManager.shared.collapseWindow(for: note.id, discardText: true)
                            }
                            .buttonStyle(.plain)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(6)
                            
                            Spacer()
                            
                            Button("Add") {
                                commitQuickAdd()
                            }
                            .buttonStyle(.plain)
                            .foregroundColor(.white)
                            .font(.system(.body, weight: .bold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color.accentColor)
                            .cornerRadius(6)
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.top, 4)
                } else {
                    // Collapsed State Add Task Button
                    Button(action: {
                        DesktopWindowManager.shared.expandWindow(for: note.id)
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.accentColor)
                            Text("Add Task")
                                .font(.system(.footnote, design: .rounded, weight: .medium))
                        }
                        .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 4)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.spring(response: settings.springAnimationSpeed, dampingFraction: 0.8), value: WidgetExpansionManager.shared.expandedNoteID)
            .animation(.spring(response: settings.springAnimationSpeed, dampingFraction: 0.8), value: note.tasks.isEmpty)
        }
    }
    
    private func commitQuickAdd() {
        let text = WidgetExpansionManager.shared.newTaskText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !text.isEmpty {
            let newTask = TaskItem(text: text, order: note.tasks.count)
            note.tasks.append(newTask)
        }
        DesktopWindowManager.shared.collapseWindow(for: note.id, discardText: true)
    }
    
    private func deleteTask(at index: Int) {
        note.tasks.remove(at: index)
        // reorder
        for i in 0..<note.tasks.count {
            note.tasks[i].order = i
        }
    }
}
