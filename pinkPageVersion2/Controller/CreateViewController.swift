
import UIKit
import SVProgressHUD
import Firebase
class CreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    var authService = AuthService()
    
    @IBAction func postButton(_ sender: Any) {
     
            signUp()
                print("POST")
    }
    
    //    //outlets
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    
    let pickOptions = ["San Francisco", "Los Angeles", "New York", "Miami", "Chicago", "Las Vegas"]
    let pickerView = UIPickerView()

    
    
    @IBOutlet weak var biography: UITextView!
    
    
    func showAlert(message : String) -> Void {
        let alert = UIAlertController(title: "So Sorry", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValid(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    func signUp(){
        if profileImage.image == nil{
            showAlert(message: "Please set your profile photo")
        }
        else if name.text == "" {
            showAlert(message: "Please enter your name.")
            
        }else if (name.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            showAlert(message: "Please enter a valid name.")
        }
        else if email.text == "" {
            showAlert(message: "Please enter a valid email.")
        }else if isValid(email.text!) != true{
            showAlert(message: "Please enter a valid email.")
        }
            
        else if password.text == ""{
            showAlert(message: "Please enter a password.")
        }
        else if password.text != confirmPassword.text {
            showAlert(message: "Passwords don't match.")
        }
            
        else if (password.text?.characters.count)! < 6{
            showAlert(message: "Password should be greater than 6 characters.")
        }
            
        else if phoneNumber.text == "" {
            showAlert(message: "Please enter your phone number.")
        }else if (phoneNumber.text?.characters.count)! != 10{
            showAlert(message: "Please enter a valid 10 digit phone number")
        }
        else{
            submitPressed()
            print("Set info")
        }
        
    }
    func submitPressed(){
        var pictureD: Data? = nil
        if let imageView = self.profileImage.image{
            pictureD = UIImageJPEGRepresentation(imageView, 0.4)
        }
        let nameText = self.name.text
        let emailField = self.email.text
        let finalEmail = emailField?.trimmingCharacters(in: .whitespacesAndNewlines)
        let locationInput = self.location.text
        let passwordText = self.password.text
        let biography = self.biography.text
        let phone = self.phoneNumber.text
        
        if  finalEmail!.isEmpty || pictureD == nil {
            self.view.endEditing(true)
            let alertController = UIAlertController(title: "So Sorry", message: " You must fill all the fields.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }else {
            
            SVProgressHUD.show()
                self.view.endEditing(true)
            self.authService.signUP(firstLastName: nameText!, email: finalEmail!, location: locationInput!, biography: biography!, password: passwordText!, phoneNumber: phone!, pictureData: pictureD! as NSData)
                
            }
              SVProgressHUD.dismiss()
    self.loadTabBarController(atIndex: 2)
      
    }
    
    var tabBarIndex: Int?
    
    //function that will trigger the **MODAL** segue
    private func loadTabBarController(atIndex: Int){
        self.tabBarIndex = atIndex
        self.performSegue(withIdentifier: "showTabBar", sender: self)
    }
    
    //in here you set the index of the destination tab and you are done
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showTabBar" {
            let tabbarController = segue.destination as! UITabBarController
            tabbarController.selectedIndex = self.tabBarIndex!
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
  
        let thePicker = UIPickerView()
        thePicker.delegate = self
        location.inputView = thePicker
       
        super.viewDidLoad()
        profileImage.isUserInteractionEnabled = true
        setGestureRecognizersToDismissKeyboard()
        // Do any additional setup after loading the view.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // TODO: Replace with data count
        return pickOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // TODO: Replace with proper data
        return pickOptions[row]
    }
   
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        location.text = pickOptions[row]
 Global.refString = pickOptions[row]
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setGestureRecognizersToDismissKeyboard(){
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.choosePictureAction(sender:)))
        imageTapGesture.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(imageTapGesture)
    }
    
    @objc func choosePictureAction(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add a Profile Picture", message: "Choose From", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
            
        }
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage]  as? UIImage{
            self.profileImage.image = image
        }else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profileImage.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}












