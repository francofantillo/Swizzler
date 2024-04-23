
//  LogObserver.swift
//  LogObserver
//
//  Created by Franco Fantillo on 2024-04-21.
//


protocol ObservedTask: NSObject {
    
    var taskIdentifier: Int { get }
    var originalRequest: URLRequest? { get }
    var currentRequest: URLRequest? { get }
    var response: URLResponse? { get }
    var state: URLSessionTask.State { get }
}

class MockTask: NSObject, ObservedTask {
    
    var state: URLSessionTask.State
    var taskIdentifier: Int
    var originalRequest: URLRequest?
    var currentRequest: URLRequest?
    @NSCopying var response: URLResponse?
    
    init(taskIdentifier: Int, originalRequest: URLRequest? = nil, currentRequest: URLRequest? = nil, response: URLResponse? = nil, state: URLSessionTask.State) {
        
        self.taskIdentifier = taskIdentifier
        self.originalRequest = originalRequest
        self.currentRequest = currentRequest
        self.response = response
        self.state = state
    }
}

extension URLSessionTask : ObservedTask {}

// Create a class that conforms to NSObject and KVO protocol
class LogObserver: NSObject {

    private let stateLabel = "state"
    let initDate = Date()
    var observerDict = [Int: (task: ObservedTask, start: Date)]()
    var logs = [LogItem]()
    
    var sessionID: String {
        let date = initDate
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd H:mm:ss.SSSS"
        return formatter.string(from: date) + " " + PersistanceKeys.logs.rawValue // -> "2016-11-17 17:51:15.1720"
    }
   
    func addObserver(dataTask: ObservedTask) {
        
        // Add observer for the specified key path
        guard observerDict[dataTask.taskIdentifier] == nil else { return } // Swizzle called twice.  Prevents from hadnling twice
        dataTask.addObserver(self, forKeyPath: stateLabel, options: .new, context: nil)
        observerDict[dataTask.taskIdentifier] = (dataTask, Date())
    }
    
    // Implement observeValue(forKeyPath:of:change:context:) method
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let task = object as? ObservedTask, keyPath == stateLabel else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        // Get the task state from the change dictionary
        if let newStateValue = change?[.newKey] as? Int, let newState = URLSessionTask.State(rawValue: newStateValue) {
            switch newState {
            
            case .running:
                    print("Task is running")
            case .suspended:
                    print("Task is suspended")
            case .canceling:
                    print("Task is canceling")
            case .completed:
                    print("Task is completed\n")
                
                // print and store log data
                let log = handleTask(task: task)
                print(log)
                logs.append(log)
                
                // save log
                DocumentStorage.store(logs, to: .documents, as: sessionID)

                // remove observer
                task.removeObserver(self, forKeyPath: stateLabel)
                observerDict.removeValue(forKey: task.taskIdentifier)
                
            @unknown default:
                
                print("Unknown state")
            }
        }
    }

    func handleTask(task: ObservedTask) -> LogItem {
        
        // Collect log Data
        let time = observerDict[task.taskIdentifier]?.start.distance(to: Date())
        let ms = Int(time! * 1_000)
        let initial = task.originalRequest?.description ?? "none"
        let final = task.currentRequest?.description ?? "none"
        let httpResponseCode = (task.response as? HTTPURLResponse)?.statusCode ?? 500
        let result: ResultStatus = (200...299).contains(httpResponseCode) ? .SUCCESS : .FAIL
        let log = LogItem(initialURL: initial, finalURL: final, time: ms, result: result)
        return log
    }
}
