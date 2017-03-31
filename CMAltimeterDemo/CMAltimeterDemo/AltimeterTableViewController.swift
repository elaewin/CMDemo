//
//  AltimeterTableViewController.swift
//  CMAltimeterDemo
//
//  Created by Erica Winberry on 3/31/17.
//  Copyright © 2017 Erica Winberry. All rights reserved.
//

import UIKit
import CoreMotion

class AltimeterTableViewController: UITableViewController {

    var pressureData: [Float] = []
    
    let altimeter = CMAltimeter()
    
    @IBOutlet weak var pressureReadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pressureReadingLabel.text = ""
        
        collectPressureData()
    }
    
    func collectPressureData() -> () {
        if (CMAltimeter.isRelativeAltitudeAvailable()) {
            print("Altitude data is available.")
            
            let altimeterQueue = OperationQueue()
            
            self.altimeter.startRelativeAltitudeUpdates(to: altimeterQueue, withHandler: { (data, error) in
                
                if let pressureReading = data?.pressure as? Float {
                    self.pressureData.append(pressureReading)
                    print("Pressure: \(pressureReading)")
                }
                
                OperationQueue.main.addOperation {
                    
                    if self.pressureData.count > 0 {
                        let pressure = self.pressureData.last!
                        self.pressureReadingLabel.text = "\(self.formatToDecimals(pressure * 10)) hPa"
                    } else {
                        self.pressureReadingLabel.text = "No pressure readings found."
                    }
                }
            })
        } else {
            print("Altitude data not available.")
        }
    }

    func formatToDecimals(_ initial: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.allowsFloats = true
        formatter.usesSignificantDigits = false
        formatter.minimumFractionDigits = 4
        formatter.maximumFractionDigits = 4
        let number = NSNumber(value: initial)
        return formatter.string(from: number)!
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}
