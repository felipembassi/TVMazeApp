// AiringScheduleView.swift

import SwiftUI

struct AiringScheduleView: View {
    let schedule: Schedule

    var body: some View {
        Text("Airs: \(schedule.time) on \(schedule.days.map { $0.rawValue }.joined(separator: ", "))")
            .font(.subheadline)
            .foregroundColor(DesignSystem.Colors.foreground)
    }
}

#Preview {
    AiringScheduleView(schedule: Schedule(time: "21:00", days: [.friday]))
}
