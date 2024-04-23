//
//  URLSessionSwizzler.swift
//  LogObserver
//
//  Created by Franco Fantillo on 2024-04-21.
//

@objc public class URLSessionObserver: NSObject {
    
    private var observer = LogObserver()
    
    @objc public static let shared = URLSessionObserver()
    
    private override init() {}
    
    @objc public func start(){
        startSessionLogger()
    }
    
    private func startSessionLogger(){
        
        // Define the method to swizzle
        let selector = #selector(URLSessionTask.resume)
        
        // Swizzle the instance method
        RSSwizzle.swizzleInstanceMethod(selector, in: URLSessionTask.self, newImpFactory: { swizzleInfo in
            
            // Define the new implementation as a closure
            let newImplementation: @convention(block) (URLSessionTask) -> Void = { [weak self] task in
                
                // Cast the original implementation to the correct function pointer
                let originalIMP = unsafeBitCast(swizzleInfo!.getOriginalImplementation(), to: (@convention(c) (URLSessionTask, Selector) -> Void).self)
                
                // Call the original implementation
                originalIMP(task, selector)
                
                // Modify the behavior here if needed
                self!.observer.addObserver(dataTask: task)
            }
            
            // Return the new implementation as a block
            return unsafeBitCast(newImplementation, to: AnyObject.self)
        }, mode: .always, key: nil)
    }
}
