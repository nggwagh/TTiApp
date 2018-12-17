//
//  ObjectiveDataProvider.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 17/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation
import Moya

class ObjectiveDataProvider {

    static let shared = ObjectiveDataProvider()

    var objectiveList: [Objective]? = nil

    func loadData(completion: @escaping (_ success: Bool) -> ()) {
        MoyaProvider<ObjectiveApi>(plugins: [AuthPlugin()]).request( .list) { result in
            switch result {
            case let .success(response):
                if case 200..<400 = response.statusCode {
                    do {
                        let jsonDict =   try JSONSerialization.jsonObject(with: response.data, options: []) as! [[String: Any]]
                        print(jsonDict)

                        //TODO: Parse Objectives
                        self.objectiveList = Objective.build(from: jsonDict)
                        completion(true)
                    }
                    catch let error {
                        print(error.localizedDescription)
//                        Alert.show(alertType: .parsingFailed, onViewContoller: self)
                        completion(false)
                    }
                } else {
                    print("unhandled status code\(response.statusCode)")
                    //TODO:- handle an invaild status code
//                    Alert.show(alertType: .wrongStatusCode(response.statusCode), onViewContoller: self)
                    completion(false)

                }

            case let .failure(error):
                print(error.localizedDescription) //MOYA error
            }
        }
    }

}
