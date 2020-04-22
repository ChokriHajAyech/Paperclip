
import Foundation

struct Listing: Codable {
    var id: Int?
    var categoryId: Int?
    var title: String?
    var price: Double?
    var smallUrlImage: String?
    var thumbUrlImage: String?
    var creationDate: String?
    var isUrgent: Bool?
}

extension Listing {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ListingCodingKeys.self)
        
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        categoryId = try container.decodeIfPresent(Int.self, forKey: .categoryId)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        let imageUrl = try container.nestedContainer(keyedBy:ImagesCodingKeys.self, forKey: .imagesUrl)
        smallUrlImage = try imageUrl.decodeIfPresent(String.self, forKey: .small)
        thumbUrlImage = try imageUrl.decodeIfPresent(String.self, forKey: .thumb)
        creationDate = try container.decodeIfPresent(String.self, forKey: .creationDate)
        isUrgent = try container.decodeIfPresent(Bool.self, forKey: .isUrgent)
    }
    
    // MARK: Codable
    
    enum ListingCodingKeys: String, CodingKey {
        case id
        case categoryId = "category_id"
        case title
        case price
        case imagesUrl = "images_url"
        case creationDate = "creation_date"
        case isUrgent = "is_urgent"
    }
    
    // MARK: Codable
    enum ImagesCodingKeys: String, CodingKey {
        case small
        case thumb
    }
}
