// Cloudn · SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI
import UIKit

struct BookmarksView: View {
    @Environment(AppModel.self) private var app
    @Environment(\.dismiss) private var dismiss
    let onOpen: (Bookmark) -> Void
    @State private var renaming: Bookmark?
    @State private var newTitle = ""

    var body: some View {
        NavigationStack {
            List {
                if app.bookmarks.bookmarks.isEmpty {
                    EmptyStateCard(icon: .star, title: "No Bookmarks Yet", detail: "Tap the star in a share view to save a bookmark.").inList()
                }
                Group {
                    ForEach(app.bookmarks.bookmarks) { b in
                        Button { onOpen(b) } label: {
                            HStack(spacing: 12) {
                                // 与解析页「最近」一致：前面是平台图标
                                if let mark = ResolveView.mark(for: b.text) {
                                    PlatformTile(mark: mark, size: 32)
                                } else {
                                    RoundedRectangle(cornerRadius: 9, style: .continuous).fill(Color.fillMuted).frame(width: 32, height: 32)
                                        .overlay { IconView(.link, size: 16).foregroundStyle(Color.ink) }
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(b.title).foregroundStyle(Color.ink).lineLimit(2)
                                    Text("\(b.source) · \(b.createdAt.formatted(date: .numeric, time: .omitted))")
                                        .font(.caption).foregroundStyle(Color.ink3)
                                }
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) { app.bookmarks.remove([b.id]) } label: { Label("Delete", glyph: .trash) }
                                .tint(Color.swipeDestructive)
                            Button { newTitle = b.title; renaming = b } label: { Label("Rename", glyph: .pencil) }
                                .tint(Color.swipeNeutral)
                        }
                        .contextMenu {
                            Button { Clipboard.copy(b.text); app.show("Link Copied") } label: { Label("Copy Link", glyph: .link) }
                            Button { newTitle = b.title; renaming = b } label: { Label("Rename", glyph: .pencil) }
                            Button(role: .destructive) { app.bookmarks.remove([b.id]) } label: { Label("Delete", glyph: .trash) }
                        }
                    }
                }
                .paperRow()
            }
            .paperList()
            .navigationTitle("Bookmarks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } }
            }
            .alert("Rename", isPresented: Binding(get: { renaming != nil }, set: { if !$0 { renaming = nil } })) {
                TextField("Name", text: $newTitle)
                Button("Cancel", role: .cancel) {}
                Button("Save") {
                    let title = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                    if let r = renaming, !title.isEmpty { app.bookmarks.rename(r.id, title: title) }
                }
                .disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
}
