import Foundation

class NetworkDataFetcher {

    let networkService = NetworkService()

    func fetchTracks(urlString: String, response: @escaping (SearchResponse?) -> Void ) {
        networkService.request(urlSrting: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let tracks = try JSONDecoder().decode(SearchResponse.self, from: data)
//                    print(tracks.results)
                    response(tracks)
                } catch let jsonError {
                    print(String(data: data, encoding: .utf8))
                    print("Failed to decode JSON", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
    }
}
}
