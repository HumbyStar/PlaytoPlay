//
//  GameViewController.swift
//  PlaytoPlay
//
//  Created by Humberto Rodrigues on 16/12/22.
//

import UIKit
import WebKit

class GameViewController: UIViewController {

    @IBOutlet weak var webPlayerView: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var webView: WKWebView!
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        prepareView()
        
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true
        DispatchQueue.main.async {
            self.webView = WKWebView(frame: self.webPlayerView.bounds, configuration: webViewConfiguration)
            self.webPlayerView.addSubview(self.webView)
            let gameLink = self.game.link ?? ""
            guard let URL = URL(string: gameLink) else {return}
            let request = URLRequest(url: URL)
            self.webView.load(request)
        }
    }
    
    func prepareView() {
        lbTitle.text = "\(game.title ?? "")"
        if let console = game.console?.name, let version = game.console?.version {
            lbConsole.text = "Console: \(console)  Versão do Console: \(version)"
        }
        if let releaseDate = game.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "pt-BR")
            lbReleaseDate.text = formatter.string(from: releaseDate)
        }
       
    }
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imgArray = game.galleryIMG as! [UIImage]
        print(imgArray.count)
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PicturesCollectionViewCell
        
        let imgArray = game.galleryIMG as! [UIImage]
        
        cell.ivPictures.image = imgArray[indexPath.row]
        
    
        
        return cell
    }
    
    
}
