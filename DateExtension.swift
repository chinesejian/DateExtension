extension Date {
    func isBusinessDay() -> Bool {
        let calendar = Calendar.current
        if calendar.isDateInWeekend(self) {
            return false
        }

        let holidays = [
            "12/31+5", // New Year's Day on a saturday celebrated on previous friday
            "1/1",     // New Year's Day
            "1/2+1",   // New Year's Day on a sunday celebrated on next monday
            "1-3/1",   // Birthday of Martin Luther King, third Monday in January
            "2-3/1",   // Washington's Birthday, third Monday in February
            "5~1/1",   // Memorial Day, last Monday in May
            "7/3+5",   // Independence Day
            "7/4",     // Independence Day
            "7/5+1",   // Independence Day
            "9-1/1",   // Labor Day, first Monday in September
            "10-2/1",  // Columbus Day, second Monday in October
            "11/10+5", // Veterans Day
            "11/11",   // Veterans Day
            "11/12+1", // Veterans Day
            "11-4/4",  // Thanksgiving Day, fourth Thursday in November
            "12/24+5", // Christmas Day
            "12/25",   // Christmas Day
            "12/26+1"  // Christmas Day
        ]

        let dayOfMonth = calendar.component(.day, from: self)
        let dayOfWeek = calendar.component(.weekday, from: self)
        let month = calendar.component(.month, from: self)
        let monthDay = "\(month)/\(dayOfMonth)"

        if holidays.contains(monthDay) {
            return false
        }

        let monthDayDay = monthDay + "+\(dayOfWeek)"
        if holidays.contains(monthDayDay) {
            return false
        }

        let weekOfMonth = ((dayOfMonth - 1) / 7) + 1
        let monthWeekDay = "\(month)-\(weekOfMonth)/\(dayOfWeek)"
        if holidays.contains(monthWeekDay) {
            return false
        }

        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = NSTimeZone.default
        components.year = calendar.component(.year, from: self)
        components.month = month + 1
        components.day = 1

        if let date = calendar.date(from: components),
        let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: date) {
            let negWeekOfMonth = 1 + (calendar.component(.day, from: lastDayOfMonth) - dayOfMonth - 1) / 7
            let monthNegWeekDay = "\(month)~\(negWeekOfMonth)/\(dayOfWeek)"
            if holidays.contains(monthNegWeekDay) {
                return false
            }
        }

        return true
    }

    func addBusinessDays(_ daysToAdvance: Int) -> Date {
        var result = self
        var advance: Int = 0

        while advance < daysToAdvance {
            if let date = Calendar.current.date(byAdding: .day, value: 1, to: result) {
                result = date
                if result.isBusinessDay() {
                    advance += 1
                }
            }
        }

        return result
    }
}
