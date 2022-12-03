//
//  CollectionViewCell.swift
//  AppleMusic
//
//  Created by Kun Niu on 11/20/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
//    var img : Data?
//    var name : String?
//    var artistName : String?
//    var date : String?
//    var genres : String?
    var id : Int?
    
    private var notFav = true
    private var like = UIImage(systemName: "heart.fill")//UIImage(named: "like")
    private var dislike = UIImage(systemName: "heart")
    
//    var coredataManager = CoreDataManager()
    
    var delegate : CoreDataDelegate?
    
    
//    init
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.favButton.sizeToFit()
        // Initialization code
//        self.favButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
//        self.imageView.image = UIImage(named: "garen")
//        self.nameLabel.text = "Default"
        self.show()
    }
    
    
    @IBAction func favButton(_ sender: Any) {
        self.setFav(!self.getFav())
        self.show()
        print("fav selected")
        self.delegate?.delegateCoreData(data: self.imageView.image!.pngData()!, id: self.id)
        
//        self.coredataManager.saveContext()
    }
    
    func show(){

        if !self.notFav{
            self.favButton.setImage(self.like, for: .normal)
        }
        else{
            self.favButton.setImage(self.dislike, for: .normal)
        }
    }
    
    func setFav(_ b : Bool){
        self.notFav = b
        self.show()
        
    }
    
    func getFav() -> Bool{
        return self.notFav
    }
    
//    func config(title : String?, image : Data?, name : String?){
//        guard let title = title else{
//            return
//        }
//        guard let name = name else{
//            return
//        }
//        self.titleLabel.text = title
//        self.nameLabel.text = name
//        guard let image = image else{
//            print("empty data")
////            fatalError(NetworkError.badData)
//            return
//        }
//        DispatchQueue.main.async {
//            self.imageView.image = UIImage(data: image)
//        }
//    }
}


