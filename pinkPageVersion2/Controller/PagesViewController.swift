
import UIKit

class PagesViewController: UIViewController {
    
    var usersList = [String]()
    
    @IBOutlet weak var labelLocation: UILabel!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
        if Global.Location != ""
        {
            self.labelLocation.text = Global.Location
            usersList = Global.usersListSent
            print(usersList)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
