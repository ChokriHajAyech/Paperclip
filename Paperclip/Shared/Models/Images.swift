//
//import Foundation
//
//struct Images {
//    var small: String?
//    var thumb: String?
//}
//
//extension Images: Codable {
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: ImagesCodingKeys.self)
//        small = try container.decodeIfPresent(String.self, forKey: .small)
//        thumb = try container.decodeIfPresent(String.self, forKey: .thumb)
//    }
//    
//    // MARK: Codable
//    enum ImagesCodingKeys: String, CodingKey {
//        case small
//        case thumb
//    }
//}
