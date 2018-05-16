//
//  ViewController.swift
//  MOB9GCD
//
//  Created by Bob De Kort on 5/9/18.
//  Copyright © 2018 Bob De Kort. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        deadlock()
//        stringArray()
        intArray()
    }
    
    func stringArray() {
        let array = ["Test", "Test2", "Test3"]
        print(array.parallelMap({return $0.uppercased()}))
    }
    
    func intArray() {
        let array = [0, 1, 2, 3, 4]

        print(array.parallelMap({return $0 * 5}))
    }
    
    func deadlock() {
        let dispatchGroup = DispatchGroup()
        
        for i in 0..<3 {
            dispatchGroup.enter()
            print("At the door of Group: \(i)")
            // Dispatching on the main SERIAL queue
            DispatchQueue.main.async {
                print("Enter Group: \(i)")
                // Do work
                sleep(2)
                print("Exit Group: \(i)")
                dispatchGroup.leave()
            }
        }
        
        print("Start Waiting")
        /*
         Makes the main thread wait until the group in completed.
         Group will never complete because the main thread is waiting until tasks on the main thread is completed.
         */
        dispatchGroup.wait()
        print("Done waiting")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Array {

    // Use an sequence of elements to perform a transformation on each element
    func parallelMap<T>(_ transform: (Element) -> T) -> [T] {
        
        // Create a resultArray with the same lenght as self
        var resultArray = Array<Element?>.init(repeating: nil, count: self.count)
        
        // Perform each iteration concurrently
        DispatchQueue.concurrentPerform(iterations: self.count) { (index) in
            // Assign the transformed element from self to the same index in the result array
            resultArray[index] = transform(self[index]) as? Element
        }
        
        // Return the resultArray
        return resultArray as! [T]
    }
}

