//
//  SwiftUIDemoView.swift
//  PinterestSegmentDemo
//

import PinterestSegment
import SwiftUI

struct SwiftUIDemoView: View {

    @State private var defaultSelection = 0
    @State private var iconSelection = 0
    @State private var customSelection = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                DemoSection("Default") {
                    PinterestSegmentPicker(selection: $defaultSelection, titles: DemoData.titles)
                    DemoStatusText("Default -> \(defaultSelection)")
                }

                DemoSection("Rich text") {
                    PinterestSegmentPicker(selection: $iconSelection, items: iconItems)
                        .frame(height: 44)
                    DemoStatusText("Icon -> \(iconSelection)")
                }

                DemoSection("Customization") {
                    PinterestSegmentPicker(
                        selection: $customSelection, titles: ["New", "Popular", "Following"], style: customStyle)
                    DemoStatusText("Custom -> \(customSelection)")
                }
            }
            .padding()
        }
        .navigationTitle("PinterestSegment")
    }

    private var iconItems: [PinterestSegmentPicker.Item] {
        zip(DemoData.iconTitles, DemoData.iconSymbolNames).map { title, symbolName in
            PinterestSegmentPicker.Item(title: title, icon: Image(systemName: symbolName))
        }
    }

    private var customStyle: PinterestSegmentPicker.Style {
        var style = PinterestSegmentPicker.Style()
        style.indicatorColor = .blue
        style.normalTitleColor = .gray
        style.selectedTitleColor = .white
        style.selectedBorderColor = .blue
        style.minimumWidth = 64
        return style
    }
}

private struct DemoSection<Content: View>: View {

    private let title: String
    private let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content
        }
        .padding(.bottom, 12)
    }
}

private struct DemoStatusText: View {

    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundColor(.secondary)
    }
}

struct SwiftUIDemoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SwiftUIDemoView()
        }
    }
}
