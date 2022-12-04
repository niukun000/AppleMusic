//
//  MusicViewController.swift
//  AppleMusic
//
//  Created by Kun Niu on 11/20/22.
//

import UIKit

class MusicViewController: UIViewController {

    let resuse = "CollectionCell"
    let appleMusicViewModel = AppleMusicViewModel()
    
    let detail = AppleMusicDetailViewController()

    @IBOutlet weak var musicCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        self.title = "Music"
        self.musicCollectionView.dataSource = self
        self.musicCollectionView.delegate = self
        self.musicCollectionView.prefetchDataSource = self
        self.musicCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.resuse)
        
        if let layout = self.musicCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        self.appleMusicViewModel.bind {
            DispatchQueue.main.async {
                self.musicCollectionView.reloadData()
            }
        }
        
        self.appleMusicViewModel.requestNextPage()
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let detail = segue.destination as?  AppleMusicDetailViewController else{
            return
        }
        guard let id = sender as? Int else{
            return
        }
        guard var sender = sender as? Int else{
            print(sender)
            return
        }
        let temp = self.appleMusicViewModel.musics[sender]
        self.appleMusicViewModel.getImage(for: temp.artworkUrl100, completion: { data in
            guard let data = data else{
                return
            }
            print("************")

            DispatchQueue.main.async {
                detail.name?.text = temp.name
                detail.artistName?.text = temp.artistName
                detail.Image?.image = UIImage(data: data)
                detail.date?.text = self.appleMusicViewModel.getDate(for: temp.releaseDate)
                detail.genres?.text = "\(temp.genres)"
                detail.id? = id
                if self.appleMusicViewModel.checkCordata(id: id){
                    detail.setFav()
                }
                
//                detail.f
                
            }
        })

        
//        detail?.detailString = info[index ?? 0]
//        detail?.delegate = self
    }
    

}

extension MusicViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appleMusicViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.resuse, for: indexPath) as? CollectionViewCell else {
            print(indexPath)
            fatalError("Failed to create cell")
        }

//        if cell.getFav() {
//            self.cordataMamager.bindCoreData {
//                self.cordataMamager.bindCoreData {
//                    <#code#>
//                }
//            }
//        }
        let index = indexPath.row
        
        cell.id = index
        cell.nameLabel.text = self.appleMusicViewModel.getArtistName(for: index)
        
        cell.titleLabel.text = self.appleMusicViewModel.getName(for: index)

        if self.appleMusicViewModel.checkCordata(id: index){
            cell.setFav(false)
//            print(index)
        }
        else{
            cell.setFav(true)
        }
        self.appleMusicViewModel.getImage(for: self.appleMusicViewModel.musics[index].artworkUrl100) { data in
            if let data = data{
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: data)
                }
            }
        }
        cell.delegate = self
        return cell
    }
    
    
}

extension MusicViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let i = indexPath.row
//        self.detail.name.text = self.appleMusicViewModel.getName(for: i)
//        self.detail.artistName.text = self.appleMusicViewModel.getArtistName(for: i)
//        self.detail.date.text = self.appleMusicViewModel.getDate(for: i)
//        self.detail.genres.text = self.appleMusicViewModel.getGenres(for: i)
//        self.appleMusicViewModel.getImage(for: i, completion: { data in
//            DispatchQueue.main.async {
//                guard let data = data else{
//                    return
//                }
//                self.detail.Image.image = UIImage(data: data)
//            }
//        })
//        self.navigationController?.pushViewController(detail, animated: true)
        self.performSegue(withIdentifier: "detailSegue", sender: indexPath.row)
//        print(indexPath)
    }
}

extension MusicViewController: UICollectionViewDataSourcePrefetching{
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(123465)
        print("prefeching index \(indexPaths.count)")

        let lastIndex = IndexPath(row: self.appleMusicViewModel.count-5, section: 0 )
        guard indexPaths.contains(lastIndex) else{
            return
        }
        self.appleMusicViewModel.requestNextPage()
    }
    
    
}

extension MusicViewController : CoreDataDelegate {
    func delegateCoreData(data: Data, id: Int?) {
        guard let id = id else{
//            print("empty id when delegate")
            return
        }
//        print("adding to coredata")
        self.appleMusicViewModel.addToCoreData(id: id, data: data)
    }
    
    
}
