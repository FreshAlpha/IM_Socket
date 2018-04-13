//
//  NetworkPlugin.swift
//  IM_SocketIO_Demo
//
//  Created by Wang on 2018/4/13.
//  Copyright © 2018年 Wang. All rights reserved.
//

import Foundation
import Moya
import Result
class NetworkPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        guard let target = target as? UserApi else {return}
        #if DEBUG
        var requestString = "--RequestUrl: \(target.baseURL.absoluteString)\(target.path)\n--Method: \(target.method.rawValue)"
        if let params = target.parameters {
            requestString += "\n--Params: \(params)"
        }
        if let header = request.request?.allHTTPHeaderFields {
            requestString += "\n--RequestHeader:\(header)"
        }
        print(requestString)
        #endif
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            guard let target = target as? UserApi else {return}
            if response.serverCodeType == .invalidResponse {
                print(response.serverCode)
                if let message = response.responseJSON?["message"].string {
                    print(message)
                }
            }
            #if DEBUG
            var requestString = "--RequestUrl: \(target.baseURL.absoluteString)\(target.path)\n--Method: \(target.method.rawValue)"
            if let params = target.parameters {
                requestString += "\n--Params: \(params)"
            }
            requestString += "\n--ResponseData:\(response.responseJSON ?? "空")"
            print(requestString)
            #endif
        case .failure(let error):
            #if DEBUG
            print("TireDetail response case error:")
            print(error)
            #endif
        }
    }
}
