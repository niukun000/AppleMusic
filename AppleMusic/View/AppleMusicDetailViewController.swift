//
//  AppleMusicDetailViewController.swift
//  AppleMusic
//
//  Created by Kun Niu on 11/26/22.
//

import UIKit

protocol CoreDataDelegate: AnyObject{
    func delegateCoreData(data : Data, id : Int?)
}

class AppleMusicDetailViewController: UIViewController {

    @IBOutlet weak var Image: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var artistName: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var genres: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    var id : Int?
    
    var fav = false
    
    private var like = UIImage(systemName: "heart.fill")//UIImage(named: "like")
    private var dislike = UIImage(systemName: "heart")
    
    var delegate : CoreDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.name.text = self.nameString
//        self.reloadInputViews()
        // Do any additional setup after loading the view.
        self.showFav()
    }
    
    func setFav(){
        //        if self.notFav == false{
        //            guard let obj = self.obj else{
        //                print("fav but no object saved")
        //                return
        //            }
        //
        //        }
        
        self.fav = true
        self.showFav()
        print("fav selected")
        self.delegate?.delegateCoreData(data: self.Image.image!.pngData()!, id: self.id)
        
        //        self.coredataManager.saveContext()
    }

    func showFav(){
        if self.fav{
            self.favButton.setImage(self.like, for: .normal)
            self.favButton.setTitle("like", for: .normal)
        }
        else{
            self.favButton.setImage(self.dislike, for: .normal)
            self.favButton.setTitle("like", for: .normal)
        }
    }
    @IBAction func favButtonclicked(_ sender: Any) {
        print("crash")
        self.setFav()
//        self.showFav()
    }
    /*
    // MARK: - Navigation

     @IBAction func favButton(_ sender: Any) {
     }
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
