//
//  API.swift
//  IntroduceBackpacker
//
//  Created by 으정이 on 2022/08/13.
//

import Foundation

protocol APIType {
    func reqeust(urlComponent: URLComponents?, failure: @escaping ((_ error: API.ErrorType)->Void), completion: @escaping ((_ response: Data)->Void))
}



class API: APIType {
    
    enum ErrorType {
        case urlDoesntExist
        case errorExist(_ error: Error)
        case statusCodeNotGood(_ statusCode: Int)
        case unowned
        case dataNotAvailable
    }
    
    
    static let shared: APIType = API()
    
    func reqeust(urlComponent: URLComponents?, failure: @escaping ((_ error: ErrorType)->Void), completion: @escaping ((_ response: Data)->Void)) {

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        guard let urlComponent = urlComponent, let requestUrl = urlComponent.url else {
            failure(.urlDoesntExist)
            return
        }
        
        let task = session.dataTask(with: requestUrl) { data, response, error in
            let successRange = 200..<300
            
            
            guard error == nil, let stateCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(stateCode) else {
                var errorType: ErrorType = .unowned
                
                if error != nil {
                    errorType = .errorExist(error!)
                } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    errorType = .statusCodeNotGood(statusCode)
                }
                
                failure(errorType)
                
                return
            }
            
            guard let resultData = data else {
                failure(.dataNotAvailable)
                return
            }
            
            completion(resultData)
            
        }
        
        task.resume()
    }
}
