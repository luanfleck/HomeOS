import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var locationEnabled = true
    @State private var darkMode = false
    @State private var hapticFeedback = true
    @State private var homeName = "Minha Casa"

    var body: some View {
        Form {
            Section("Casa") {
                LabeledContent("Nome da Casa") {
                    TextField("Nome", text: $homeName)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(.secondary)
                }
                LabeledContent("Localização", value: "São Paulo, SP")
                LabeledContent("Fuso Horário", value: "America/Sao_Paulo")
            }

            Section("Preferências") {
                Toggle(isOn: $darkMode) {
                    Label("Modo Escuro", systemImage: "moon.fill")
                }
                Toggle(isOn: $hapticFeedback) {
                    Label("Feedback Háptico", systemImage: "hand.tap.fill")
                }
            }

            Section("Notificações e Privacidade") {
                Toggle(isOn: $notificationsEnabled) {
                    Label("Notificações", systemImage: "bell.fill")
                }
                Toggle(isOn: $locationEnabled) {
                    Label("Localização", systemImage: "location.fill")
                }
            }

            Section("Conectividade") {
                LabeledContent {
                    HStack(spacing: 6) {
                        Circle().fill(.green).frame(width: 8, height: 8)
                        Text("Conectado").foregroundStyle(.green)
                    }
                } label: {
                    Label("Status da Rede", systemImage: "wifi")
                }
                LabeledContent("Gateway", value: "192.168.1.1")
                LabeledContent("Dispositivos na Rede", value: "14")
            }

            Section("Sobre") {
                LabeledContent("Versão", value: "1.0.0")
                LabeledContent("Build", value: "2026.03.14")
                Button("Termos de Uso") {}
                Button("Política de Privacidade") {}
            }
        }
        .navigationTitle("Configurações")
    }
}
