//
//  FavViewController.swift
//  AppleMusic
//
//  Created by Kun Niu on 11/29/22.
//

import UIKit

class FavViewController: UIViewController{
    
    let resuse = "CollectionCell"
    
    let appleMusicViewModel = AppleMusicViewModel()
    
    let detail = AppleMusicDetailViewController()
    
    @IBOutlet weak var favCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "FavMusic"
        self.favCollectionView.dataSource = self
        self.favCollectionView.delegate = self
        self.favCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.resuse)
        
        self.appleMusicViewModel.bindFav() {
            DispatchQueue.main.async {
                self.favCollectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appleMusicViewModel.loadFav()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let detail = segue.destination as?  AppleMusicDetailViewController else{
            return
        }
        guard let sender = sender as? AppleMusic else{
//            print(sender)
            return
        }
        DispatchQueue.main.async {
            detail.name?.text = sender.name
            detail.artistName?.text = sender.artistName
            detail.id? = Int(sender.id)
            detail.Image.image = UIImage(data: sender.img ?? Data())
            detail.date.text = sender.date
            detail.genres.text = sender.geners
            
        }
        print(sender)
//        self.appleMusicViewModel.getImage(for: sender, completion: { data in
//            guard let data = data else{
//                return
//            }
//        let temp = self.appleMusicViewModel.favMusics[sender]
//            DispatchQueue.main.async {
//                detail.name?.text = self.appleMusicViewModel.favMusics[sender].name
//                detail.artistName.text = self.appleMusicViewModel.favMusics[sender].artistName
//
////                detail.artistName?.text = self.appleMusicViewModel.getArtistName(for: sender)
////                detail.Image?.image = UIImage(data: self.appleMusicViewModel.getFavImg)
////                detail.date?.text = self.appleMusicViewModel.getDate(for: sender)
////                detail.genres?.text = self.appleMusicViewModel.getGenres(for: sender)
////                detail.id? = sender
//
////            }
//        }

        
//        detail?.detailString = info[index ?? 0]
//        detail?.delegate = self
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FavViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.appleMusicViewModel.favCount)
        print("Fav count")
        return self.appleMusicViewModel.favCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.resuse, for: indexPath) as? CollectionViewCell
        else{
            fatalError("Failed to create cell")
        }
        
        let index = indexPath.row
        //        cell.favButton.isEnabled = false
        //        cell.setFav(true)
        
        cell.id = Int(self.appleMusicViewModel.favMusics[index].id)
        cell.nameLabel.text = self.appleMusicViewModel.favMusics[index].artistName
        cell.titleLabel.text = self.appleMusicViewModel.favMusics[index].name
        cell.setFav(false)
        guard let data = self.appleMusicViewModel.favMusics[index].img else{
            fatalError("failed to get picture from core data")
        }
        cell.imageView.image = UIImage(data: data)
        //        let cell = UICollectionViewCell()
        return cell
    }
    
    
}

extension FavViewController : UICollectionViewDelegate{
//    print(self.appleMusicViewModel.favCount)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailFavSegue", sender: self.appleMusicViewModel.favMusics[indexPath.row])

    }

}
