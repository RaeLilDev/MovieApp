//
//  BaseModel.swift
//  Starter
//
//  Created by Ye Lynn Htet on 25/03/2022.
//

import Foundation

class BaseModel: NSObject {
    let networkAgent: MovieDBNetworkAgentProtocol = MovieDBNetworkAgent.shared
}
