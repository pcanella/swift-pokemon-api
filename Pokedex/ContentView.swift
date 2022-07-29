//
//  ContentView.swift
//  Shared
//
//  Created by Canella, Patrick on 7/27/22.
//

import SwiftUI

struct ContentView: View {
    @State var currentPokemon: JsonResponse?
    @State var inputText: String = ""
    @State var isLoading: Bool = false
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Text("Please Enter a Pokemon")
                TextField("Please Enter a Pokemon", text: $inputText, onEditingChanged: {editingChanged in
                    if editingChanged {
                        print("TextField focused")
                    } else {
                        Task {
                            let apiCall = PokedexAPI()
                            do {
                                isLoading = true
                                currentPokemon = nil
                                let result = try await apiCall.makeApiCall(pokemonName: inputText.lowercased())
                                currentPokemon = result
                                isLoading = false
                            } catch {
                                print("cannot find api")
                            }
                        }
                    }
                }).padding(5)
                    .disableAutocorrection(true)
                    .multilineTextAlignment(.center)
                    .border(.gray, width: 1.0)
                
                if (isLoading) {
                    ProgressView()
                }
                    
                if (currentPokemon != nil) {
                    let currentPokemonName = currentPokemon?.name
                    let currentPokemonId = String(currentPokemon?.id ?? 1)
                    Text(currentPokemonName ?? "Unknown Pokemon").font(.title)
                    Text(currentPokemonId)
                }
                
            
                Spacer()
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
