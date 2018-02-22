
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import Firebase

class MyPageViewController: UIViewController {
    
    
    @IBAction func logOut(_ sender: Any) {
        
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "logOut", sender: self)
  
        }
    
    
    var authService = AuthService()
    var user: User!
    
    var dataBaseRef: DatabaseReference!{
        return Database.database().reference()
    }
    var storageRef: StorageReference!{
        return Storage.storage().reference()
    }
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    var phone = Int()
    
    override func viewDidLoad() {
   
        loadUserInfo()
        
        print(phone)

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
     //  locationRef = Global.refString
        print(phone)
      //  loadUserInfo()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     //  var locationRef = Global.refString
    func loadUserInfo(){
        
    let locationRef = Global.refString
      let userRef = dataBaseRef.child(locationRef).child(Auth.auth().currentUser!.uid)
        
   //  let userRef = dataBaseRef.child("Users/\(Auth.auth().currentUser!.uid)")
        
        userRef.observe(.value, with: { (snapshot) in
            
            let user = Users(snapshot: snapshot)
            
            if let username = user.name{
                self.nameLabel.text = username
            }
//
//            if let pass = user.password{
//                self.passwordOld = pass
//            }
            
                        if let number = user.phoneNumber{
                            self.phone = Int(number)
                        }
            if let userLocation = user.location{
                self.bioLabel.text = userLocation
            }
//            if let bio = user.biography{
//                self.biog.text = bio
//                self.bioOld = bio
//            }
//            if let interests = user.interests{
//                self.interests.text = interests
//                self.interestsOld = interests
//            }
            
            if let imageOld = user.photoURL{
                
                
                //  let imageURL = user.photoURL!
                
            
                
                self.storageRef.storage.reference(forURL: imageOld).getData(maxSize: 10 * 1024 * 1024, completion: { (imgData, error) in
                    
                    if error == nil {
                        DispatchQueue.main.async {
                            if let data = imgData {
                                self.avatar.image = UIImage(data: data)
                            }
                        }
                        
                    }else {
                        print(error!.localizedDescription)
                        
                    }
                    
                }
                    
                    
                )}
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        }
        
    }


