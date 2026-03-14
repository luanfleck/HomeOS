import SwiftUI

struct AutomationView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var theme: HOSTheme

    var body: some View {
        List {
            ForEach($appState.automations) { $automation in
                AutomationRow(automation: $automation)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Automações")
        .tint(theme.color)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {}) {
                    Label("Nova Automação", systemImage: "plus")
                }
            }
        }
    }
}

struct AutomationRow: View {
    @EnvironmentObject private var theme: HOSTheme
    @Binding var automation: Automation

    var body: some View {
        HStack(spacing: HOSSpacing.md) {
            Image(systemName: automation.trigger.icon)
                .font(.title3)
                .foregroundStyle(automation.isEnabled ? theme.color : .secondary)
                .frame(width: 40, height: 40)
                .background(
                    automation.isEnabled ? theme.color.opacity(0.12) : Color(.systemFill),
                    in: RoundedRectangle(cornerRadius: HOSRadius.xs)
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(automation.name)
                    .font(.hosBody)
                    .fontWeight(.medium)
                    .foregroundStyle(automation.isEnabled ? .primary : .secondary)
                HStack(spacing: 4) {
                    Text(automation.trigger.rawValue)
                        .font(.hosCaption)
                        .foregroundStyle(.secondary)
                    if let date = automation.lastTriggeredAt {
                        Text("·")
                            .font(.hosCaption)
                            .foregroundStyle(.secondary)
                        Text("Ativada \(date, style: .relative) atrás")
                            .font(.hosCaption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()

            Toggle("", isOn: $automation.isEnabled)
                .labelsHidden()
                .tint(theme.color)
                .onChange(of: automation.isEnabled) { _, _ in haptic(.light) }
        }
        .padding(.vertical, HOSSpacing.xs)
    }
}
