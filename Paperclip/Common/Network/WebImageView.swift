import UIKit
import os.log

protocol LoadImageDelegate {
    func willLoadImage()
}

public class WebImageView: UIImageView {
    private var task: URLSessionDataTask?
    public var placeHolderImage: UIImage? = UIImage(named: "default_thumb")
    public var errorImage:UIImage? = UIImage(named: "default_thumb")
    
    // MARK: - Public
    
    public func cancel() {
        if task != nil {
            task!.cancel()
            task = nil
        }
    }
    
    public func loadImage(url: URL, completionHandler: ((Data?)->Void)? = nil) {
        cancel()
 
            let session = getSession()
            let request = requestFor(url: url)
            
            if let cachedImage = cachedImageFrom(request: request) {
                os_log("image loaded from cache: %{PRIVATE}@",
                       log: Log.network,
                       type: .debug,
                       url.absoluteString)
                
                displayImage(image: cachedImage)
                
                if let completionHandler = completionHandler {
                    completionHandler(image?.pngData())
                }
                
            }else {
                os_log("load image from web: %{PRIVATE}@...",
                       log: Log.network,
                       type: .debug,
                       url.absoluteString)
                
                displayPlaceHolderImage()
                
                task = session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in

                    if error == nil {
                        let httpResponse = response as? HTTPURLResponse
                        
                        if httpResponse?.isStatusCode200() == true {
                            if let data = data {
                                if let image = UIImage(data: data) {
                                    os_log("image loaded from web: %{PRIVATE}@",
                                           log: Log.network,
                                           type: .debug,
                                           url.absoluteString)
                                    
                                    self?.displayImage(image: image)
                                }else {
                                    self?.displayError()
                                }
                            }else {
                                self?.displayError()
                            }
                        }else {
                            self?.displayError()
                        }
                    }else {
                        self?.displayError()
                    }
                })
                
                task?.resume()
            }
    }
    
    // MARK: - Private (Network)
    
    private func getSession() -> URLSession {
        return URLSession.shared
    }
    
    private func requestFor(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        return request
    }
    
    // MARK: - Private (Cache)
    
    private func cachedImageFrom(request: URLRequest) -> UIImage? {
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return UIImage(data: cachedResponse.data)
        }
        
        return nil
    }
    
    // MARK: - Private (Display)
    
    private func displayPlaceHolderImage() {
        if let placeHolderImage = placeHolderImage {
            self.displayImage(image: placeHolderImage)
        } else {
            self.displayImage(image: nil)
        }
    }
    
    private func displayError() {
        if let url = self.task?.originalRequest?.url {
            os_log("image loading fail: %{PRIVATE}@",
                   log: Log.network,
                   type: .debug,
                   url.absoluteString)
        }else {
            os_log("image loading fail",
                   log: Log.network,
                   type: .debug)
        }
        
        if let errorImage = errorImage {
            self.displayImage(image: errorImage)
        }else {
            self.displayImage(image: nil)
        }
    }
    
    private func displayImage(image: UIImage?) {
        if Thread.current.isMainThread {
            self.image = image
        }else {
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

extension HTTPURLResponse {
    public func isStatusCode200() -> Bool {
        if statusCode == 200 {
            return true
        }
        
        return false
    }
}
