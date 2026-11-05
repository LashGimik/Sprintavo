import Foundation

enum TaskDeadlineLabel {
    static func text(for date: Date, isCompleted: Bool, now: Date = Date(), calendar: Calendar = .current) -> String {
        let today = calendar.startOfDay(for: now)
        let day = calendar.startOfDay(for: date)
        if calendar.isDate(day, inSameDayAs: today) { return "Сегодня" }
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: today), calendar.isDate(day, inSameDayAs: tomorrow) {
            return "Завтра"
        }
        var format = Date.FormatStyle.dateTime.day().month(.abbreviated).locale(Locale(identifier: "ru_RU"))
        if calendar.component(.year, from: date) != calendar.component(.year, from: now) {
            format = format.year()
        }
        let label = "До " + date.formatted(format)
        return day < today && !isCompleted ? label + " · просрочено" : label
    }
}
