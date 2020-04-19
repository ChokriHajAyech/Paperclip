import Foundation

class DemoService: Service {
    
    /// Cancel the service.
    public func cancel() {
    }
    
    /// Invoke the service.
    ///
    /// - parameter file: The file (JSON).
    /// - parameter type: The type of the class used for the decodage.
    /// - parameter completion: The completion handler.
    public func invokeService<T: Decodable>(file: String, type: T.Type, completion: @escaping ServiceCompletionHandler) {
        do {
            guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
                throw PaperclipError.unknow
            }
            
            let dataEncoded = try Data(contentsOf: url)
            let dataDecoded = try JSONDecoder().decode(type, from: dataEncoded)
            
            completion(dataDecoded, nil)
        }catch {
            completion(nil, PaperclipError.unknow)
        }
    }
}
