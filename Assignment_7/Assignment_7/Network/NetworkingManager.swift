import Foundation

class NetworkingManager {
    
    static let shared = NetworkingManager()
    
    func fetchBookAPI(query: String, completion: @escaping (Result<Book, Error>) -> Void) {
        guard var url = URL(string: "https://dapi.kakao.com/v3/search/book") else { return }
        url = URL(string: url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!

        url.append(queryItems: [URLQueryItem(name: "query", value: query)])
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("KakaoAK 527ac6b8eb24a6dc1ccc6c431fa84b3e", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Error Occurred", error)
            }
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            
            do {
                let bookResult = try JSONDecoder().decode(Book.self, from: data)
                completion(.success(bookResult))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
