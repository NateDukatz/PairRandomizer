//
//  PairListItemTableViewCell.swift
//  PairRandomizer
//
//  Created by Nate Dukatz on 8/29/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit

class PairListItemTableViewCell: UITableViewCell {

    func update(pairListItem: PairListItem) {
        
        self.textLabel?.text = pairListItem.name
    }

}
