//
//  GameInfoTableViewCell.swift
//  PlaytoPlay
//
//  Created by Humberto Rodrigues on 16/12/22.
//

import UIKit

class GameInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var ivCapa: UIImageView!
    @IBOutlet weak var lbTitulo: UILabel!
    @IBOutlet weak var lbPlataforma: UILabel!
    @IBOutlet weak var lbAno: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func prepare(game: Game){
        lbTitulo.text = game.title
        if let DateString = game.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "pt-BR")
            lbAno.text = formatter.string(from: DateString)
        }
        if let image = game.capeIMG as? UIImage {
            ivCapa.image = image
        }
        
        if let consoleName = game.console?.name {
            lbPlataforma.text = consoleName
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
