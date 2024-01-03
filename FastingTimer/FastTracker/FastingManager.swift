import Foundation

enum FastingState: Int {
    case notStarted
    case fasting
    case feeding
}

enum FastingPlan: String {
    case beginner = "12:12"
    case intermediate = "16:8"
    case advanced = "20:4"

    var fastingPeriod: Double {
        switch self {
        case .beginner:
            return 12
        case .intermediate:
            return 16
        case .advanced:
            return 20
        }
    }
}

class FastingManager: ObservableObject {
    var fastingState: FastingState = .notStarted
    var fastingPlan: FastingPlan = .intermediate
    var startTime: Date {
        didSet {
            if fastingState == .fasting {
                endTime = startTime.addingTimeInterval(fastingTime)
            } else {
                endTime = startTime.addingTimeInterval(feedingTime)
            }
            saveData()
        }
    }

    @Published private(set) var endTime: Date {
        didSet {
            print("endTime", endTime.formatted(.dateTime.month().day().hour().minute().second()))
        }
    }

    @Published private(set) var elapsed: Bool = false
    @Published private(set) var elapsedTime: Double = 0.0
    @Published private(set) var progress: Double = 0.0

    var fastingTime: Double {
        return fastingPlan.fastingPeriod * 60 * 60
    }

    var feedingTime: Double {
        return 24 - fastingPlan.fastingPeriod * 60 * 60
    }

    init() {
        let calendar = Calendar.current
        let components = DateComponents(hour: 20)
        let scheduledTime = calendar.nextDate(after: .now, matching: components, matchingPolicy: .nextTime)!
        print("scheduledTime", scheduledTime.formatted(.dateTime.month().day().hour().minute().second()))
        startTime = scheduledTime
        endTime = scheduledTime.addingTimeInterval(FastingPlan.intermediate.fastingPeriod * 60 * 60)
        loadSavedData()
    }

    func toggleFastingState() {
        fastingState = fastingState == .fasting ? .feeding : .fasting
        startTime = Date()
        elapsedTime = 0.0
    }

    func track() {
        guard fastingState != .notStarted else { return }
        print("now", Date().formatted(.dateTime.month().day().hour().minute().second()))

        if endTime >= Date() {
            print("Not elapsed")
            elapsed = false
        } else {
            print("elapsed")
            elapsed = true
        }

        elapsedTime += 1
        print("elapsedTime", elapsedTime)

        let totalTime = fastingState == .fasting ? fastingTime : feedingTime
        progress = (elapsedTime / totalTime * 100).rounded() / 100
        print("progress", progress)

        saveData()
    }

    private func loadSavedData() {
        let defaults = UserDefaults.standard

        if let savedStateRawValue = defaults.value(forKey: "fastingState") as? Int,
           let savedState = FastingState(rawValue: savedStateRawValue) {
            fastingState = savedState
        }

        if let savedPlanRawValue = defaults.value(forKey: "fastingPlan") as? String,
           let savedPlan = FastingPlan(rawValue: savedPlanRawValue) {
            fastingPlan = savedPlan
        }

        if let savedStartTime = defaults.value(forKey: "startTime") as? Date {
            startTime = savedStartTime
        }

        if fastingState == .fasting {
            endTime = startTime.addingTimeInterval(fastingTime)
        } else {
            endTime = startTime.addingTimeInterval(feedingTime)
        }
    }

    private func saveData() {
        let defaults = UserDefaults.standard
        defaults.set(fastingState.rawValue, forKey: "fastingState")
        defaults.set(fastingPlan.rawValue, forKey: "fastingPlan")
        defaults.set(startTime, forKey: "startTime")
        defaults.set(elapsedTime, forKey: "elapsedTime")
        defaults.set(progress, forKey: "progress")
    }
}
