import os.log

struct Log {
    static var general = OSLog(subsystem: "com.leboncoin", category: "general")
    static var network = OSLog(subsystem: "com.leboncoin", category: "network")
}
