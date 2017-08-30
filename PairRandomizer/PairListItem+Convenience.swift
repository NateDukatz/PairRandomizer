//
//  PairListItem+Convenience.swift
//  PairRandomizer
//
//  Created by Nate Dukatz on 8/29/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import Foundation
import CoreData

extension PairListItem {
    
    convenience init(name: String, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.name = name
    }
}
