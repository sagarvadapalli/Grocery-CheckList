//
//  ViewControllerTableViewCell.swift
//  Grocery CheckList
//
//  Created by sagar vadapalli on 6/8/17.
//  Copyright © 2017 sagar vadapalli. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {
     
  
    @IBOutlet weak var Items: UILabel!
   
    @IBOutlet weak var txt: UILabel!

    @IBAction func stepper(_ sender: UIStepper) {
        txt.text = String(Int(sender.value))
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
