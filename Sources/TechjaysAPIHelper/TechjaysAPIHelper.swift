public class TechjaysAPIHelper {
    public static let shared = TechjaysAPIHelper()
    public func setupApiHelper(baseUrl: String, version: String) {
        URLFactory.shared.baseUrl = baseUrl
        URLFactory.shared.version = version
    }
}
