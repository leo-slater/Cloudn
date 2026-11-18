// Cloudn · SPDX-License-Identifier: AGPL-3.0-or-later
import CloudnKit
import SwiftUI

/// 同一平台的多个账号：设为主账号、退出单个账号、添加账号
struct AccountListView: View {
    let kind: AccountKind
    let onAdd: (AccountKind) -> Void
    @Environment(AppModel.self) private var app
    @Environment(\.dismiss) private var dismiss
    @State private var removing: Int?

    var body: some View {
        let list = app.accounts.list(kind)
        NavigationStack {
            List {
                Section {
                        if list.isEmpty {
                            Text("No Accounts Signed In").font(.subheadline).foregroundStyle(Color.ink3)
                                .listRowBackground(Color.surface)
                        }
                        ForEach(Array(list.enumerated()), id: \.offset) { index, account in
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(account.nickname).foregroundStyle(Color.ink)
                                    Text("更新于 \(account.updatedAt.formatted(date: .numeric, time: .shortened))")
                                        .font(.caption).foregroundStyle(Color.ink3)
                                }
                                Spacer()
                                if index == 0 {
                                    Text("Primary Account").font(.caption.weight(.medium)).foregroundStyle(.tint)
                                }
                            }
                            // 每个账号自成一张圆角卡片：左滑时整张卡一起移动，右边不会露出直角的行底
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.surface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay { RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Color.hairline, lineWidth: 1) }
                            .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            // 不用 destructive 角色：它会触发列表删除动画，确认框刚弹出就被收回
                            .swipeActions(allowsFullSwipe: false) {
                                Button { removing = index } label: { Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right") }
                                    .tint(Color.swipeDestructive)
                                if index > 0 {
                                    Button { Task { await app.accounts.makePrimary(index, for: kind) } } label: { Label("Set as Primary", glyph: .star) }
                                        .tint(Color.swipeNeutral)
                                }
                            }
                            .contextMenu {
                                if index > 0 {
                                    Button { Task { await app.accounts.makePrimary(index, for: kind) } } label: { Label("Set as Primary", glyph: .star) }
                                }
                                Button(role: .destructive) { removing = index } label: { Label("Sign Out of This Account", systemImage: "rectangle.portrait.and.arrow.right") }
                            }
                            .rowDialog("Sign out of this account?", isPresented: presenting($removing) { $0 == index }, message: "Locally stored credentials for this account will be deleted.") {
                                Button("Sign Out", role: .destructive) { Task { await app.accounts.remove(index, for: kind) } }
                            }
                        }
                    } footer: {
                        Text("解析、转存和网盘管理使用主账号；开启「多账号下载」后，批量下载会轮换使用全部账号。")
                    }
                Section {
                    Button { onAdd(kind) } label: { Label("Add Account", glyph: .user) }
                        .listRowBackground(Color.surface)
                }
            }
            .paperList()
            .navigationTitle("\(kind.displayName)账号")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
    }
}
