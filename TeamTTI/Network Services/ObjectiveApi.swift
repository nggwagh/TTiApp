//
//  ObjectiveApi.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 12/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum ObjectiveApi {
   
    case list
    
    case schedule(objectiveArray: [AnyObject])
    
    case submitObjective(storeID: Int, objectiveID: Int, submitJson: [String: Any])
    
    case uploadStoreObjectiveImage(image: UIImage, storeID: Int, objectiveID: Int)
}

/*
struct JsonArrayEncoding: Moya.ParameterEncoding {
    
    public static var `default`: JsonArrayEncoding { return JsonArrayEncoding() }
    
    
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `AFError.parameterEncodingFailed` error if encoding fails.
    ///
    /// - returns: The encoded request.
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var req = try urlRequest.asURLRequest()
        let json = try JSONSerialization.data(withJSONObject: parameters!["jsonArray"]!, options: JSONSerialization.WritingOptions.prettyPrinted)
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.httpBody = json
        return req
    }
    
}
*/

extension ObjectiveApi: TargetType {
    
    var baseURL: URL {
        return Constant.API.baseURL
    }

    var path: String {
        switch self {
            
        case .list:
            return Constant.API.Objective.path
            
        case .schedule(_):
            return "api/v1/store_objective/schedule"
            
        case .submitObjective(let storeID, let objectiveID,_):
            return "api/v1/store/\(storeID)/objective/\(objectiveID)"
            
        case .uploadStoreObjectiveImage(image: _, let storeID, let objectiveID):
            return "api/v1/store/\(storeID)/objective/\(objectiveID)/images"
        }
    }

    var method: Moya.Method {
        
        switch self {
            
        case .list:
            return .get
            
        case .schedule(_):
            return .post
            
        case .submitObjective(_,_,_):
            return .put
            
        case .uploadStoreObjectiveImage(_,_,_):
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        
        switch self {
        
        case .list:
            return .requestPlain
            
        case .schedule(let objectiveArray):
            return .requestParameters(parameters:
                ["objectives": objectiveArray],encoding: JSONEncoding.default)
            
            
        case .submitObjective(_,_, let submitJson):
            return .requestParameters(parameters: submitJson, encoding: JSONEncoding.default)

        case .uploadStoreObjectiveImage(let image, _, _):
            
//            let vName = "Taken at store"
//            let vNameData = Moya.MultipartFormData(provider: MultipartFormData.FormDataProvider.data(vName.data(using: .utf8)!), name: "comments")
            
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            print("Upload image size\(String(describing: imageData?.count))")
            let data = MultipartFormData(provider: MultipartFormData.FormDataProvider.data(imageData!), name: "file", fileName: "objectives.jpeg", mimeType: "image/jpeg")
         // return .uploadMultipart([vNameData, data])
            return .uploadMultipart([data])

            
            
        }
    }
    
    var headers: [String : String]? {
        
        switch self {
            
        case .list:
            return ["Content-type" : "application/json"]
            
        case .schedule(_):
            return ["Content-type" : "application/json"]
            
        case .submitObjective(_,_,_):
            return ["Content-type" : "application/json"]
            
        case .uploadStoreObjectiveImage(_,_,_):
            return ["Content-type" : "multipart/form-data"]
            
        }
    }
    /*
    var parameters: [String: AnyObject]? {

        switch self {
            case .schedule(let objectiveArray):
                return ["jsonArray": objectiveArray as AnyObject]
        case .list:
            return nil
        }
    }

    var parameterEncoding: Moya.ParameterEncoding {
    
        switch self {
        case .schedule(_):
            return JsonArrayEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    */

}

