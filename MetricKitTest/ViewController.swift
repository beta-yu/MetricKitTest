//
//  ViewController.swift
//  MetricKitTest
//
//  Created by Yu Qi on 2024/3/29.
//

import UIKit
import MetricKit
import Meter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        MXMetricManager.shared.add(self)
        
        let t = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(t)
        
        view.backgroundColor = .blue
        
        print(libraryURL.path)
    }
    
    let symbolicator = DlfcnSymbolicator()
    lazy var libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
    
    @objc func didTap() {
        var a: String?
        print(a!)
    }

}

extension ViewController: MXMetricManagerSubscriber {
    
    func didReceive(_ payloads: [MXMetricPayload]) {
        
    }
    
    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        for payload in payloads {
            print("received payload 1")
            if let payload = try? DiagnosticPayload.from(payload: payload) {
                print("received payload")
                let symPayload = symbolicator.symbolicate(payload: payload)
                let fileName = [payload.timeStampBegin.ISO8601Format(), payload.timeStampEnd.ISO8601Format()].joined(separator: "-")
                let url = libraryURL.appendingPathComponent(fileName).appendingPathExtension("json")
                debugPrint(url.path)
                FileManager.default.createFile(atPath: url.path, contents: symPayload.jsonRepresentation())
            }
        }
        
    }

}

