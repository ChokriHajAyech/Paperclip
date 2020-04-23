struct Conf {
	static let brand = "Paperclip"
	static let version = "1.0"
	static let build = "1"
	static let platform = "dev"
    static let cacheDiskCapacity = 10000000 * 10
    static let cacheMemoryCapacity = 512000 * 10

	struct Services {

		static let mode = "demo" //static let mode = "server"
		static let baseURL = "https://raw.githubusercontent.com"
		static let listing = "/leboncoin/paperclip/master/listing.json"
		static let categories = "/leboncoin/paperclip/master/categories.json"
	}
}
