
import UIKit
import CoreData
import FirebaseFirestore

class AddEditViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UITextField!
    @IBOutlet weak var studio: UITextField!
    @IBOutlet weak var rating: UITextField!
    @IBOutlet weak var button: UIButton!
    
    var movies: AllMoviesModel?
    var isImageUpdate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let movie = movies {
            movieTitle.text = movie.title
            studio.text = movie.studio
            rating.text = movie.criticsRating
            if let data =  Data(base64Encoded: movie.imageData), let image = UIImage(data: data) {
                moviePoster.image = image
            } else {
                moviePoster.sd_setImageCustom(url: movie.image ?? "",placeHolderImage: UIImage(named: "image"))
            }
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOnImage))
        moviePoster.isUserInteractionEnabled = true
        moviePoster.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func tapOnImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                moviePoster.image = pickedImage
                isImageUpdate = true
            }
            picker.dismiss(animated: true, completion: nil)
        }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func butonclick(_ sender: UIButton) {
        if movieTitle.text?.isEmpty ?? false {
            self.showAlert(string: "Title can not be blanked")
            return
        } else if studio.text?.isEmpty ?? false {
            self.showAlert(string: "Studio can not be blanked")
            return
        } else if rating.text?.isEmpty ?? false {
            self.showAlert(string: "Rating can not be blanked")
            return
        }
        
        if var movie = self.movies {
            movie.criticsRating = rating.text ?? ""
            movie.studio = studio.text ?? ""
            movie.title = movieTitle.text ?? ""
            if isImageUpdate {
                if let image = moviePoster.image, let data = image.jpegData(compressionQuality: .ulpOfOne)?.base64EncodedString() {
                    movie.imageData = data
                }
            }
            db.collection("AllMovies").document(movie.id).updateData(movie.dictionary)
        } else {
            var dictData : [String:Any] = [:]
            dictData["criticsRating"] = rating.text ?? ""
            dictData["studio"] = studio.text ?? ""
            dictData["title"] = movieTitle.text ?? ""
            if let image = moviePoster.image, let data = image.jpegData(compressionQuality: .ulpOfOne)?.base64EncodedString() {
                dictData["imageData"] = data
            }
            db.collection("AllMovies").addDocument(data: dictData)
        }
        
        self.popVC()
    }
    
}
