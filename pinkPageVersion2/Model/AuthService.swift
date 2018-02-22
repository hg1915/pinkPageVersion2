import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import UIKit
//import SVProgressHUD

struct AuthService{

    var dataBaseRef: DatabaseReference!{
        return Database.database().reference()
    }
    var storageRef: StorageReference!{
        return Storage.storage().reference()
    }


    func signUP(firstLastName: String, email: String, location: String, biography: String, password: String, phoneNumber: String, pictureData: NSData!) {
       
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil, let unwrappedUser = user{
             
                self.setUserInfo(firstLastName: firstLastName, user: unwrappedUser, location: location, phoneNumber: phoneNumber, biography: biography, password: password, pictureData: pictureData)

            }



            else{
                print(error?.localizedDescription)
            }
        }


    }

    func setUserInfo(firstLastName: String, user: User, location: String, phoneNumber: String, biography: String, password: String, pictureData: NSData!){

        let imagePath = "profileImage\(user.uid)/userPic.jpg"
        let imageRef = storageRef.child(imagePath)

        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        imageRef.putData(pictureData as Data, metadata: metaData){(newMetaData, error)
            in
            if error == nil{
                let changeRequest = User.createProfileChangeRequest(user)()
                changeRequest.displayName = firstLastName
                if let photoURL = newMetaData!.downloadURL(){
                    changeRequest.photoURL = photoURL

                }
                changeRequest.commitChanges(completion: { (error) in
                    if error == nil{

                        self.saveUserInfo(firstLastName: firstLastName, user: user, location: location, biography: biography, password: password, phoneNumber: phoneNumber)

                        print("user info set")

                    }else{
                        print(error?.localizedDescription)
                    }
                })

            }else{
                print(error?.localizedDescription)
            }

        }

    }
    
    let locationRef = Global.refString
 
    private func saveUserInfo(firstLastName: String, user: User!, location: String, biography: String, password: String, phoneNumber: String){
 let locationRef = Global.refString
        let userInfo = ["firstLastName": firstLastName,  "email": user.email!, "password": password, "location": location, "phoneNumber": phoneNumber, "biography": biography, "uid": user.uid, "photoURL": String(describing: user.photoURL!)] as [String : Any]

        let userRef = dataBaseRef.child(locationRef!).child(user.uid)
        userRef.setValue(userInfo) { (error, ref) in
            if error == nil{
                print("USER SAVED")


                self.logIn(email: user.email!, password: password)
            }else{
                print(error?.localizedDescription)

            }
        }

    }

    func logIn(email: String, password: String){

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                if let user = user {
                    print("\(user.displayName!) has been signed in")

            

                    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDel.logUser()

                }else{
                    print(error?.localizedDescription)

                }

            }
        }
    }

//    func getCurrentUserInfo() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        dataBaseRef.child("locationRef/\(uid)").observeSingleEvent(of: .value, with: { snapshot in
//            print("GOTTY!")
//            currentUser = Users(snapshot: snapshot)
//        })
//    }


}

