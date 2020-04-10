//
//  SeasonTableViewCell.swift
//  TableRxAnimated
//
//  Created by Jeans Ruiz on 3/31/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

class SeasonTableViewCell: UITableViewCell {
  
  @IBOutlet weak var seasonLabel: UILabel!
  @IBOutlet weak var wrapperView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setModel(seasonNumber: Int) {
    seasonLabel.text = String(seasonNumber)
  }
}
