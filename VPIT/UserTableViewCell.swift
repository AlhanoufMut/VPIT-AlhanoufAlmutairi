//
//  UserTableViewCell.swift
//  VPIT
//
//  Created by Alhanouf Khalid on 06/12/1442 AH.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var gender: UILabel!
    
    //MARK: - Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

} // End of the class
