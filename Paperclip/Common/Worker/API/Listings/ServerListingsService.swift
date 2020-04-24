import Foundation

class ServerListingsService: ServerService, ListingsService {

    func listings(_ completion: @escaping ServiceCompletionHandler) -> Void {
        let path = Conf.Services.listing
        invokeService(path: path, method: "GET", type: [ListingCodable].self, completion: completion)
    }
}
