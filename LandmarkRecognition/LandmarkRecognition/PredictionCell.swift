//
//  PredictionCell.swift
//  LandmarkRecognition
//
//

import UIKit

class PredictionCell: UITableViewCell {
    
    @IBOutlet weak var predictionName: UILabel!
    @IBOutlet weak var predictionConfidence: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
