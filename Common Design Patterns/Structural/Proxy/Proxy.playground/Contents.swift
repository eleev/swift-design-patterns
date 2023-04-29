//
//  Proxy.swift
//  swift-design-patterns
//
//  Created by Astemir Eleev on 25/08/2018.
//  Copyright © 2018 Astemir Eleev. All rights reserved.
//

import PlaygroundSupport
import Foundation

PlaygroundPage.current.needsIndefiniteExecution = true

let networking = Networking()
let url = URL(string: "http://www.google.com")!

networking.dataTask(for: url) { response in
    debugPrint(response as Any)
}


let backendProxy = BackendNetworkingProxy()
backendProxy.requestDataUpdate { dataUpdateStatus in
    debugPrint(dataUpdateStatus.debugDescription)
}
