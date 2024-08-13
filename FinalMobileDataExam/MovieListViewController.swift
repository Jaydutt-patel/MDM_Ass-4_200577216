
import UIKit
import FirebaseFirestore
import FirebaseAuth



class MovieListViewController: UIViewController, MoviesTableViewCellProtocol {
    
    @IBOutlet weak var movieslist: UITableView!
    
    let db = Firestore.firestore()
    
    var movies: [AllMoviesModel] = []//[MoviesList] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        movieslist.register(UINib.init(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesTableViewCell")
        movieslist.rowHeight = UITableView.automaticDimension
        movieslist.estimatedRowHeight = 30;
        movieslist.tableFooterView = UIView()
        movieslist.delegate = self
        movieslist.dataSource = self
        movieslist.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.hidesBackButton = true
        movies = []//arr ?? []
        self.getMovies()
        movieslist.reloadData()
    }

    func getMovies() {
        db.collection("AllMovies").getDocuments { (querySnapshot, error) in
            if let error = error {
                
                return
            }
            var arr: [[String:Any]] = []
            for document in querySnapshot!.documents {
                var data = document.data()
                data["id"] = document.documentID
                arr.append(data)
            }
            print(arr)
            let arrModels = arr.compactMap({ AllMoviesModel(from: $0)})
            self.movies = arrModels
            DispatchQueue.main.async {
                self.movieslist.reloadData()
            }
        }
    }
    
    func deleteMovies(indexPath: IndexPath) {
        self.showAlertWithOkAndCancelHandler(string: "Are you sure you want to delete this movies?", strOk: "YES", strCancel: "NO") { isOkBtnPressed in
            if isOkBtnPressed {
                self.db.collection("AllMovies").document(self.movies[indexPath.row].id).delete()
                self.movies.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.movieslist.reloadData()
                }
                self.movieslist.reloadData()
            }
        }
        
    }

    func editMovies(indexPath: IndexPath) {
        let vc: AddEditViewController = AddEditViewController.instantiateViewController(identifier: .main)
        vc.movies = movies[indexPath.row]
        self.pushVC(vc)
    }
    
    @IBAction func plusAction(_ sender: UIBarButtonItem) {
        let vc: AddEditViewController = AddEditViewController.instantiateViewController(identifier: .main)
        self.pushVC(vc)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            // Navigate to the login screen or any other action after logout
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension MovieListViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell") as? MoviesTableViewCell {
            let modal = movies[indexPath.row]
            cell.title.text = modal.title
            cell.studio.text = modal.studio
            cell.rating.text = modal.criticsRating
            if let data = Data(base64Encoded: modal.imageData), let image = UIImage(data: data) {
                cell.moviesImage.image = image
            } else {
                cell.moviesImage.sd_setImageCustom(url: modal.image,placeHolderImage: UIImage(named: "image"))
            }
            
            cell.indexPath = indexPath
            cell.delegate = self
            return cell
            
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

