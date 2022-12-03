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
    
    var id : Int?
    
    var delegate : CoreDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.name.text = self.nameString
//        self.reloadInputViews()
        // Do any additional setup after loading the view.
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
