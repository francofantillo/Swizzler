//
//  SwizzlerTests.swift
//  SwizzlerTests
//
//  Created by Franco Fantillo on 2024-04-22.
//

import XCTest
@testable import Swizzler

final class SwizzlerTests: XCTestCase {

    var observer = LogObserver()
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSessionID() throws {
        
        let date = observer.initDate
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd H:mm:ss.SSSS"
        let logName = formatter.string(from: date) + " " + PersistanceKeys.logs.rawValue
        XCTAssert(observer.sessionID == logName)
    }

    func testTaskObserver() throws {
        
        let orig = URLRequest(url: URL(string: "http:\\orig.com")!)
        let curr = URLRequest(url: URL(string: "http:\\curr.com")!)
        let mockTask = MockTask(taskIdentifier: 5, originalRequest: orig, currentRequest: curr, state: .running)
        
        print(mockTask.state)
        observer.addObserver(dataTask: mockTask)
        XCTAssert(!observer.observerDict.isEmpty)
        observer.observeValue(forKeyPath: "state", of: mockTask, change: [.newKey:3], context: nil)
        XCTAssert(observer.observerDict.isEmpty)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
