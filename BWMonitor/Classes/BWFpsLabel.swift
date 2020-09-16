//
//  BWFpsLabel.swift
//  BWMonitor
//
//  Created by bairdweng on 2020/9/16.
//

import UIKit

open class BWFpsLabel: UILabel {
    
    fileprivate var displayLink: CADisplayLink?
    fileprivate var lastTime: TimeInterval = 0
    fileprivate var count: Int = 0
    deinit {
        displayLink?.invalidate()
    }
    open override func didMoveToSuperview() {
        frame = CGRect(x: 15, y: 150, width: 60, height: 60)
        layer.cornerRadius = 30
        clipsToBounds = true
        backgroundColor = UIColor.black
        textColor = UIColor.green
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 20)
        run()
    }
    func run() {
        displayLink = CADisplayLink(target: self, selector: #selector(BWFpsLabel.tick(_:)))
        displayLink?.add(to: .current, forMode: .common)
    }
    @objc func tick(_ displayLink: CADisplayLink) {
        if lastTime == 0 {
            lastTime = displayLink.timestamp
            return
        }
        
        count += 1
        let timeDelta = displayLink.timestamp - lastTime
        if timeDelta < 0.25 {
            return
        }
        
        lastTime = displayLink.timestamp
        let fps: Double = Double(count) / timeDelta
        count = 0
        DispatchQueue.main.async {
            self.text = String(format: "%.1f", fps)
            self.textColor = fps > 50 ? UIColor.green : UIColor.red
        }
        
    }
}
