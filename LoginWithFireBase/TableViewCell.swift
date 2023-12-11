//
//  TableViewCell.swift
//  LoginWithFireBase
//
//  Created by apple on 30/07/2023.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var FBRimageView: UIImageView!
    
    @IBOutlet weak var FBRtitleNm: UILabel!
    
    @IBOutlet weak var FBRgmailId: UILabel!
    
    @IBOutlet weak var FBRpass: UILabel!
    
    @IBOutlet weak var FBREditBtn: UIButton!
    
    @IBOutlet weak var FBRDeleteBtn: UIButton!
    
    
    var chatModel: ChattModel? {
        didSet{
            FBRtitleNm.text = chatModel?.Name
            FBRgmailId.text = chatModel?.Gmail
            FBRpass.text = chatModel?.Password
            
            let url = URL(string: (chatModel?.profileImgUrl)!) //URL(string: chatModel?.profileImgUrl ?? "")
        
            if let url = url {
                KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, downloadTaskUpdated: nil, completionHandler: { (result) in
                    switch result {
                    case .success(let value):
                        self.FBRimageView.image = value.image
                        self.FBRimageView.kf.indicatorType = .activity
                    case .failure(let error):
                        print("Error retrieving image: \(error)")
                    }
                })
            }
        }
        
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



