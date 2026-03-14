import SwiftUI

struct AutomationView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        List {
            ForEach($appState.automations) { $automation in
                AutomationRow(automation: $automation)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Automações")
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
    @Binding var automation: Automation

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: automation.trigger.icon)
                .font(.title3)
                .foregroundStyle(automation.isEnabled ? .blue : .secondary)
                .frame(width: 40, height: 40)
                .background(
                    (automation.isEnabled ? Color.blue.opacity(0.12) : Color(.systemFill)),
                    in: RoundedRectangle(cornerRadius: 10)
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(automation.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(automation.isEnabled ? .primary : .secondary)
                HStack(spacing: 4) {
                    Text(automation.trigger.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if let date = automation.lastTriggeredAt {
                        Text("·")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("Última vez \(date, style: .relative) atrás")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()

            Toggle("", isOn: $automation.isEnabled)
                .labelsHidden()
                .tint(.blue)
        }
        .padding(.vertical, 4)
    }
}
