import Foundation

class NetworkService {

   func request(urlSrting: String, complition: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlSrting) else {return}
        URLSession.shared.dataTask(with: url) { data, responce, error in
            DispatchQueue.main.async {
                if let error = error {
                    complition(.failure(error))
                    return
                }
                guard let data = data else { return }
                complition(.success(data))
            }
        }.resume()
    }
}
