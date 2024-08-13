
import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func btnSignupAction(_ sender: UIButton) {
        let signupVC: SignupViewController = SignupViewController.instantiateViewController(identifier: .main)
        self.pushVC(signupVC)
    }
    
    func isEmailValid(_ email: String) -> Bool {
        let emailPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        return emailPredicate.evaluate(with: email)
    }

    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        if let text = txtEmail.text, text.isEmpty {
            self.showAlert(string: "Email can not be blank")
            return
        } else if let text = txtEmail.text, !self.isEmailValid(text) {
            self.showAlert(string: "Email is not valid")
            return
        } else if let text = txtPassword.text, text.isEmpty {
            self.showAlert(string: "Password can not be blank")
            return
        }
        Auth.auth().signIn(withEmail: txtEmail.text ?? "", password: txtPassword.text ?? "") { (authResult, error) in
            if let error = error {
                self.showAlert(string: "Email and password is not valid.")
                return
            }
            let vc: MovieListViewController = MovieListViewController.instantiateViewController(identifier: .main)
            self.pushVC(vc)
            
        }
    }
    
    
}
