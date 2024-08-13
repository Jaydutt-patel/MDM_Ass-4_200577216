
import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignupViewController: UIViewController {

    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmpassword: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func isEmailValid(_ email: String) -> Bool {
        let emailPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        return emailPredicate.evaluate(with: email)
    }
    
    @IBAction func signupAction(_ sender: Any) {
        if let text = email.text, text.isEmpty {
            self.showAlert(string: "Email can not be blanked")
            return
        } else if let text = email.text, !isEmailValid(text) {
            self.showAlert(string: "Email is not valid")
            return
        } else if let text = password.text, text.isEmpty {
            self.showAlert(string: "Password can not be blanked")
            return
        } else if let text = password.text, text.count < 6 {
            self.showAlert(string: "password length should be at least 6 character")
            return
        } else if let text = confirmpassword.text, text.isEmpty {
            self.showAlert(string: "confirm password can not be blanked")
            return
        } else if let textPassword = password.text, let textConfirm = confirmpassword.text, textPassword != textConfirm {
            self.showAlert(string: "Password and confirm password should be same")
            return
        }
        Auth.auth().createUser(withEmail: email.text ?? "", password: password.text ?? "") { (authResult, error) in
            if let error = error {
                self.showAlert(string: error.localizedDescription)
                return
            }
            let vc: MovieListViewController = MovieListViewController.instantiateViewController(identifier: .main)
            self.pushVC(vc)
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.popVC()
    }
    
}
