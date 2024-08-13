import Foundation

struct AllMoviesModel: Codable {
    var criticsRating: String
    var image: String
    var imageData: String
    var title: String
    var studio: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case criticsRating
        case image
        case title
        case studio
        case id
        case imageData
    }
    
    // Initializer from dictionary
    init(from dictionary: [String: Any]) {
        self.criticsRating = dictionary["criticsRating"] as? String ?? ""
        self.image = dictionary["image"] as? String ?? ""
        self.imageData = dictionary["imageData"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.studio = dictionary["studio"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
    }
    
    
    var dictionary: [String: Any] {
        return [
            "criticsRating": criticsRating,
            "image": image,
            "imageData": imageData,
            "title": title,
            "studio": studio
        ]
    }
}
