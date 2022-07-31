import Foundation

struct NetworkService {

   func request(urlSrting: String, complition: @escaping (Result<SearchResponse, Error>) -> Void) {
        guard let url = URL(string: urlSrting) else {return}
        URLSession.shared.dataTask(with: url) { data, responce, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("error")
                    complition(.failure(error))
                    return
                }
                guard let data = data else { return }
                do {
                    let tracks = try JSONDecoder().decode(SearchResponse.self, from: data)
                    complition(.success(tracks))
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    complition(.failure(jsonError))
                }
            }
        }.resume()
    }
}
