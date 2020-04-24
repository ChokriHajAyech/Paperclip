
import Foundation

protocol ProductProtocol {}
protocol listingProtocol: ProductProtocol {
    var listingTitle: String? { get set}
    var listingPrice: String? { get set}
    var thumbUrl: URL? { get set}
    var smallUrl: URL? { get set}
    var isUrgent: Bool? { get set}
}
protocol listingDetailsProtocol: listingProtocol {
    var listingDescription: String? { get }
    var listingSiret: String? { get set}
    var listingCreationDate: String? { get set}
}
