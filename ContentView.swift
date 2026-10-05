import SwiftUI

struct ContentView: View {
    @State private var uid = ""
    @State private var loading = false
    @State private var title = ""
    @State private var rows: [(String, String)] = []
    @State private var error: String?
    @FocusState private var focused: Bool

    var body: some View {
        ZStack {
            Background()
            ScrollView {
                VStack(spacing: 20) {
                    header
                    inputCard
                    if loading { ProgressView().controlSize(.large).padding() }
                    if let error { errorCard(error) }
                    if !rows.isEmpty { resultCard }
                    footer
                }
                .padding(20)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .preferredColorScheme(.dark)
    }

    var header: some View {
        VStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .font(.system(size: 34))
                .foregroundStyle(.orange)
                .frame(width: 76, height: 76)
                .glassEffect(.regular, in: .circle)
            Text("FF Tool").font(.largeTitle.bold())
            Text("Buff like & xem thông tin tài khoản").font(.subheadline).foregroundStyle(.secondary)
        }
        .padding(.top, 30)
    }

    var inputCard: some View {
        GlassEffectContainer(spacing: 16) {
            VStack(spacing: 14) {
                HStack {
                    Image(systemName: "person.text.rectangle").foregroundStyle(.secondary)
                    TextField("Nhập ID Free Fire", text: $uid)
                        .keyboardType(.numberPad)
                        .focused($focused)
                    if !uid.isEmpty {
                        Button { uid = "" } label: { Image(systemName: "xmark.circle.fill") }
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 16).padding(.vertical, 14)
                .glassEffect(.regular, in: .capsule)

                HStack(spacing: 12) {
                    Button { run(.like, "Buff Like") } label: {
                        Label("Buff Like", systemImage: "hand.thumbsup.fill").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.glassProminent).tint(.pink)

                    Button { run(.info, "Thông tin") } label: {
                        Label("Info", systemImage: "info.circle.fill").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.glass)
                }
                .controlSize(.large)
                .disabled(uid.trimmingCharacters(in: .whitespaces).isEmpty || loading)
            }
        }
        .padding(18)
        .glassEffect(.regular, in: .rect(cornerRadius: 28))
    }

    var resultCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)
            ForEach(Array(rows.enumerated()), id: \.offset) { _, r in
                HStack(alignment: .top) {
                    Text(r.0).foregroundStyle(.secondary).font(.subheadline)
                    Spacer(minLength: 12)
                    Text(r.1).font(.subheadline.weight(.medium)).multilineTextAlignment(.trailing).textSelection(.enabled)
                }
                Divider().opacity(0.3)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: 28))
    }

    func errorCard(_ msg: String) -> some View {
        Label(msg, systemImage: "exclamationmark.triangle.fill")
            .foregroundStyle(.red)
            .padding(16).frame(maxWidth: .infinity)
            .glassEffect(.regular.tint(.red.opacity(0.2)), in: .rect(cornerRadius: 22))
    }

    var footer: some View {
        VStack(spacing: 8) {
            Text("Cre: Nguyen Minh Huy").font(.footnote.weight(.semibold))
            Link(destination: URL(string: "https://t.me/mh_nguyen")!) {
                Label("@mh_nguyen", systemImage: "paperplane.fill").font(.footnote)
            }
            .buttonStyle(.glass)
        }
        .padding(.vertical, 16)
    }

    func run(_ ep: Endpoint, _ name: String) {
        focused = false
        error = nil; rows = []; loading = true; title = name
        let id = uid.trimmingCharacters(in: .whitespaces)
        Task {
            do { rows = try await API.call(ep, uid: id) }
            catch { self.error = error.localizedDescription }
            loading = false
        }
    }
}

struct Background: View {
    @State private var move = false
    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.03, blue: 0.10).ignoresSafeArea()
            Circle().fill(.purple).frame(width: 300).blur(radius: 90)
                .offset(x: move ? -90 : 80, y: move ? -240 : -160)
            Circle().fill(.pink).frame(width: 260).blur(radius: 90)
                .offset(x: move ? 110 : -60, y: move ? 120 : 220)
            Circle().fill(.blue).frame(width: 240).blur(radius: 90)
                .offset(x: move ? -100 : 100, y: move ? 300 : 180)
        }
        .ignoresSafeArea()
        .onAppear { withAnimation(.easeInOut(duration: 7).repeatForever(autoreverses: true)) { move = true } }
    }
}
