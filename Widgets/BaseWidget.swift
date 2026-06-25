import SwiftUI

protocol BaseWidget: Identifiable {
    var id: UUID { get }
    var title: String { get set }
    var minSize: CGSize { get }
    var maxSize: CGSize { get }
    
    associatedtype CollapsedViewType: View
    @ViewBuilder var collapsedView: CollapsedViewType { get }
    
    associatedtype ExpandedViewType: View
    @ViewBuilder var expandedView: ExpandedViewType { get }
    
    // Future additions for Settings, Toolbar, Persistence
}
