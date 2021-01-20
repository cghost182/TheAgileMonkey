//
//  ArtistTableViewCell.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 16/01/21.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {

    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistGenre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with artist: Artist?) {
        guard let artist = artist else { return }
        artistName.text = artist.artistName
        artistGenre.text = artist.primaryGenreName ?? "-"
    }
}
