//
//  CSVDemo.swift
//  test
//
//  Created by joel fleuren on 12-12-16.
//  Copyright © 2016 joel fleuren. All rights reserved.
//

import UIKit

class CSVDemo: NSObject {
    
    func readStringFromURL(stringURL:String)-> String!{
        // convert the string of the url
        if let url = NSURL(string: stringURL) {
            do {
                //set the csv file from the api to a string 
                return try String(contentsOf: url as URL)
            } catch {
                print("Cannot load contents")
                return nil
            }
        } else {
            print("String was not a URL")
            return nil
        }
    }
    


}
