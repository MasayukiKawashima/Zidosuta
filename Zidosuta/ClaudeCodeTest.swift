import Foundation

// MARK: - APIClient

enum APIClientError: Error {
    case invalidURL
    case encodingError
    case decodingError
    case invalidResponse
    case serverError(statusCode: Int)
    case networkError(Error)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Requestable {
    associatedtype Response: Decodable
    associatedtype HTTPBody: Encodable
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: HTTPBody? { get }
}

struct EmptyBody: Encodable {}

struct APIClient {
    func request<T: Requestable>(_ request: T) async throws -> T.Response {
        guard let url = URL(string: request.baseURL + request.path) else {
            throw APIClientError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers

        if let body = request.body {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw APIClientError.encodingError
            }
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: urlRequest)
        } catch {
            throw APIClientError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIClientError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.Response.self, from: data)
        } catch {
            throw APIClientError.decodingError
        }
    }
}

// MARK: - Open Food Facts API

struct OpenFoodFactsProductRequest: Requestable {
    typealias Response = OpenFoodFactsProductResponse
    typealias HTTPBody = EmptyBody

    let barcode: String

    var baseURL: String { "https://world.openfoodfacts.org" }
    var path: String { "/api/v2/product/\(barcode).json" }
    var method: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    var body: EmptyBody? { nil }
}

struct OpenFoodFactsProductResponse: Decodable {
    let code: String
    let status: Int
    let statusVerbose: String
    let product: Product?

    enum CodingKeys: String, CodingKey {
        case code
        case status
        case statusVerbose = "status_verbose"
        case product
    }
}

struct Product: Decodable {
    var productName: String?
    var nutriments: Nutriments?

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case nutriments
    }
}

struct Nutriments: Decodable {
    var calories: Double?
    var protein: Double?
    var fat: Double?
    var carbohydrates: Double?
    var sugars: Double?
    var fiber: Double?
    var salt: Double?

    var saturatedFat: Double?
    var transFat: Double?
    var cholesterol: Double?
    var omega3: Double?
    var omega6: Double?

    var calcium: Double?
    var iron: Double?
    var magnesium: Double?
    var potassium: Double?

    var vitaminC: Double?
    var vitaminD: Double?
    var vitaminB12: Double?

    enum CodingKeys: String, CodingKey {
        case calories = "energy-kcal_100g"
        case protein = "proteins_100g"
        case fat = "fat_100g"
        case carbohydrates = "carbohydrates_100g"
        case sugars = "sugars_100g"
        case fiber = "fiber_100g"
        case salt = "salt_100g"

        case saturatedFat = "saturated-fat_100g"
        case transFat = "trans-fat_100g"
        case cholesterol = "cholesterol_100g"
        case omega3 = "omega-3-fat_100g"
        case omega6 = "omega-6-fat_100g"

        case calcium = "calcium_100g"
        case iron = "iron_100g"
        case magnesium = "magnesium_100g"
        case potassium = "potassium_100g"

        case vitaminC = "vitamin-c_100g"
        case vitaminD = "vitamin-d_100g"
        case vitaminB12 = "vitamin-b12_100g"
    }
}
