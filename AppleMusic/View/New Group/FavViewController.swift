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
        cell.favButton.isEnabled = false
//        cell.setFav(true)

        cell.id = Int(self.appleMusicViewModel.favMusics[index].id)
        cell.nameLabel.text = self.appleMusicViewModel.favMusics[index].artistName
        cell.titleLabel.text = self.appleMusicViewModel.favMusics[index].name
        guard let data = self.appleMusicViewModel.favMusics[index].img else{
            fatalError("failed to get picture from core data")
        }
        cell.imageView.image = UIImage(data: data)
//        let cell = UICollectionViewCell()
        return cell
    }
    
    
}

extension FavViewController : UICollectionViewDelegate{
    
}
