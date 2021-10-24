public class TechjaysAPIHelper {
    public let shared = TechjaysAPIHelper()
    public func setupApiHelper(baseUrl: String, version: String) {
        URLFactory.shared.baseUrl = baseUrl
        URLFactory.shared.version = version
    }
}
