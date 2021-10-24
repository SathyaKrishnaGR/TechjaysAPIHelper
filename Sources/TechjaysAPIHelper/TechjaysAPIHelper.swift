public class TechjaysAPIHelper {
    public static let shared = TechjaysAPIHelper()
    public func setupApiHelper(baseUrl: String, version: String, token: String) {
        URLFactory.shared.baseUrl = baseUrl
        URLFactory.shared.version = version
        APIClient.shared.token = token
    }
}
