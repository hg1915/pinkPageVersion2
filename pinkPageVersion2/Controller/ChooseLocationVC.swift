

import UIKit

class ChooseLocationVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
   var usersLA = ["jenn", "Rebevcca"]
    var usersSF = ["a", "b"]
    var usersNY = ["N", "Y"]
    var usersMiami = ["Mi"]
    var usersLV = ["LV"]
    var usersChi = ["CH"]
    
    
    
    
    @IBAction func chooseButton(_ sender: Any) {
        
        if pageControl.currentPage == 0{
            Global.Location = "LOS ANGELES"
            Global.usersListSent = usersLA
            tabBarController!.selectedIndex = 1
            
            print("LA")
            
        }
        else if pageControl.currentPage == 1{
            Global.Location = "San Francisco"
            Global.usersListSent = usersSF
            tabBarController!.selectedIndex = 1
            print("SF")
        }else if pageControl.currentPage == 2{
            Global.Location = "New York"
            Global.usersListSent = usersNY
            tabBarController!.selectedIndex = 1
            print("NY")
        }else if pageControl.currentPage == 3{
            Global.Location = "Miami"
            Global.usersListSent = usersMiami
            tabBarController!.selectedIndex = 1
            print("Miami")
        }else if pageControl.currentPage == 4{
            Global.Location = "Las Vegas"
            Global.usersListSent = usersLV
            tabBarController!.selectedIndex = 1
            print("LasVegas")
        }else if pageControl.currentPage == 5{
            Global.Location = "Chicago"
            Global.usersListSent = usersChi
            tabBarController!.selectedIndex = 1
            print("Chicago")
        }
    }
    
    
    
    var imageArray = [UIImage(named: "LA"),UIImage(named: "SF"), UIImage(named: "NY"), UIImage(named: "Miami"), UIImage(named: "LasVegas"), UIImage(named: "Chicago")]
    override func viewDidLoad() {
        super.viewDidLoad()
 
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.locationImage.image = imageArray[indexPath.row]
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
       // setLabels()
        print(pageControl.currentPage)
    }
     var thisWidth:CGFloat = 0
 
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    

}
