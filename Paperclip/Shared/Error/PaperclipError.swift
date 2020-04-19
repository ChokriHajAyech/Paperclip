import Foundation

enum PaperclipError: Error {
    /// Generic error
    case unknow
    
    /// Unable to decode (eg: JSON decoding)
    case decoding

    /// The form is invalid
    case invalidForm

    /// Network connection error
    case networkConnection
    
    /// Server error
    case server

    /// Server timedOut
    case networkTimedOut
    
    /// Connection error host
    case networkCannotConnectToHost
    
    /// Lost Connection
    case networkConnectionLost
    
    /// Error network
    case networkNotConnectedToInternet
    
    /// Network cancelled
    case networkCancelled
    
    /// Generic http error
    case errorCodeHttp
    
    /// 401 http error
    case errorCodeHttp401
    
    /// 403 http error
    case errorCodeHttp403
    
    /// Technical error code
    case errorCodeTechnical
}

extension PaperclipError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknow: return NSLocalizedString("error.unknow", comment: "")
        case .decoding: return NSLocalizedString("error.decoding", comment: "")
        case .invalidForm: return NSLocalizedString("error.invalidForm", comment: "")
        case .networkConnection: return NSLocalizedString("error.networkConnection", comment: "")
        case .server: return NSLocalizedString("error.server", comment: "")
        case .networkTimedOut: return NSLocalizedString("error.network.timedOut", comment: "")
        case .networkConnectionLost: return NSLocalizedString("error.network.connectionLost", comment: "")
        case .networkNotConnectedToInternet: return NSLocalizedString("error.network.notConnectedToInternet", comment: "")
        case .networkCancelled: return NSLocalizedString("error.unknow", comment: "")
        case .errorCodeHttp: return NSLocalizedString("error.unknow", comment: "")
        case .errorCodeHttp401: return NSLocalizedString("error.http.401", comment: "")
        case .errorCodeHttp403: return NSLocalizedString("error.http.403", comment: "")
        case .errorCodeTechnical: return NSLocalizedString("error.technical.message", comment: "")
        case .networkCannotConnectToHost: return NSLocalizedString("error.network.cannotConnectToHost", comment: "")
        }
    }
}


