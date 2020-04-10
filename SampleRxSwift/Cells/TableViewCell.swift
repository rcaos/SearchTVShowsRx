//
//  TableViewCell.swift
//  TableRxAnimated
//
//  Created by Jeans Ruiz on 3/31/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  public func setModel(entity: TVShow) {
    textLabel?.text = entity.name
    detailTextLabel?.text = String(entity.voteAverage ?? 0.0)
  }
}
