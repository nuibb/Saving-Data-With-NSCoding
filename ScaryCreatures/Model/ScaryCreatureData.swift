//
//  AppDelegate.swift
//  ScaryCreatures
//
//  Created by Steve JobsOne on 4/30/19.
//  Copyright © 2019 MobioApp Limited. All rights reserved.
//

import Foundation

class ScaryCreatureData: NSObject, NSCoding, NSSecureCoding {

    var title = ""
    var rating: Float = 0
    
    init(title: String, rating: Float) {
        super.init()
        self.title = title
        self.rating = rating
    }
    
    enum Keys: String {
        case title = "Title"
        case rating = "Rating"
    }
    
    //encoder
    func encode(with aCoder: NSCoder) {
        //NSSecureCoding
        aCoder.encode(title as NSString, forKey: Keys.title.rawValue)
        aCoder.encode(NSNumber(value: rating), forKey: Keys.rating.rawValue)

        //NSCoding
        //aCoder.encode(title, forKey: Keys.title.rawValue)
        //aCoder.encode(rating, forKey: Keys.rating.rawValue)
    }
    
    /*decoder : Keyword convenience here is not a requirement of NSCoding. It’s here because we want to call a designated initializer, init(title:rating:)
     */
    required convenience init?(coder aDecoder: NSCoder) {
        //NSSecureCoding
        let title = aDecoder.decodeObject(of: NSString.self, forKey: Keys.title.rawValue)
            as String? ?? ""
        let rating = aDecoder.decodeObject(of: NSNumber.self, forKey: Keys.rating.rawValue)
        self.init(title: title, rating: rating?.floatValue ?? 0)

        //NSCoding
        //let title = aDecoder.decodeObject(forKey: Keys.title.rawValue) as! String
        //let rating = aDecoder.decodeFloat(forKey: Keys.rating.rawValue)
        //self.init(title: title, rating: rating)
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
}
