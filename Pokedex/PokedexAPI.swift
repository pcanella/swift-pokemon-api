//
//  PokedexAPI.swift
//  Pokedex
//
//  Created by Canella, Patrick on 7/29/22.
//

import Foundation

struct JsonResponse: Codable {
    var name: String?
    var id: Int?
}

class PokedexAPI {
    func makeApiCall(pokemonName: String) async throws -> JsonResponse? {
        let baseUrl = "https://pokeapi.co/api/v2/pokemon/\(pokemonName)"
        let urlComponent = URLComponents(string: baseUrl)
        
        guard let serviceUrl = (urlComponent?.url) else {return nil}
        do {
            let (data, _) = try await URLSession.shared.data(from: serviceUrl)
            let pokeData = self.decodeToJson(rawData: data)
            return pokeData
        } catch {
            print("Pokedex API Error", error.localizedDescription)
            return nil
        }
    }
    
    func decodeToJson(rawData: Data) -> JsonResponse? {
        let decoder = JSONDecoder()
        
        do {
            let decodedResponse = try decoder.decode(JsonResponse.self, from: rawData)
            return decodedResponse;
        } catch {
            print("decoding error: ", error.localizedDescription)
            return nil
        }
    }
}
