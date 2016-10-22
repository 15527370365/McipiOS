//
//  CommonFunction.swift
//  McipNews
//
//  Created by MAC on 16/4/24.
//  Copyright © 2016年 MAC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


struct NetworkRequster<T> {
    
    typealias ResultType = Result<T>
    typealias Completion = ResultType -> ()
    typealias AsyncOperation = Completion -> ()
    
    //(Result<T> -> Void) -> Void
    let operation: AsyncOperation
    
}

extension NetworkRequster {
    func start(completion: Completion) {
        self.operation { result in
            completion(result)
        }
    }
}

extension NetworkRequster {
    func jsonToModel<U>(failure: (ErrorType -> Void)?,success: (T -> U)?) {
        self.start { result in
            switch result {
            case .Success(let v):
                success?(v)
            case .Failure(let e):
                failure?(e)
            }
        }
    }
}


extension NetworkRequster {
    func map<U>(f: T -> U) -> NetworkRequster<U> {
        return NetworkRequster<U> { completion in
            self.start { result in
                completion(result.map(f))
            }
        }
    }
    
    func flatMap<U>(f: T -> NetworkRequster<U>) -> NetworkRequster<U> {
        return NetworkRequster<U> { completion in
            self.start { result in
                switch result {
                case .Success(let v):
                    f(v).start(completion)
                case .Failure(let e):
                    completion(.Failure(e))
                }
            }
        }
    }
}

func fetchJsonFromNet(urlStr: String, _ parameters: [String: AnyObject]? = nil,_ headers: [String: String]? = nil)
    -> NetworkRequster<JSON> {
        return NetworkRequster { completion in
            Alamofire.request(.POST, urlStr, parameters: parameters,headers:headers).responseJSON { (response) -> Void in
                print(response.request)
                guard response.result.error == nil else {
                    print(response.result.error)
                    print("Alamofire error!")
                    completion(.Failure(Error.NetworkError))
                    return
                }
                let value = JSON(response.result.value!)
                completion(Result.Success(value))
            }
        }
}


func jsonWithKey(key: String) -> (JSON -> JSON) {
    return { json in
        json[key]
    }
}




