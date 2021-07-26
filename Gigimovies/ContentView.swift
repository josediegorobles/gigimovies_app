//
//  ContentView.swift
//  Gigimovies
//
//  Created by Jose Diego Robles on 7/25/21.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @ObservedObject var observed = Observer()
    @ObservedObject var favorites = Favorites()
    @State var searchText: String = ""
    var body: some View {
            TabView {
                VStack {
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                                    TextField("Search", text: $searchText,
                                    onCommit: {
                                        self.observed.getMovies(search: self.searchText)
                                    })
                                                .padding(7)
                                                .background(Color(.systemGray6))
                                                .cornerRadius(8)
                            if searchText != "" {
                                    Image(systemName: "xmark.circle.fill")
                                        .imageScale(.medium)
                                        .foregroundColor(Color(.systemGray3))
                                        .padding(3)
                                        .onTapGesture {
                                            withAnimation {
                                                self.searchText = ""
                                              }
                                        }
                                }
                        }
                    
                        List(observed.movies){ i in
                            HStack{
                                Text(i.title)
                                Spacer()
                                Button(action: {
                                    if self.favorites.favoriteMovies.contains(where: {$0.id == i.id}) {
                                        self.favorites.favoriteMovies.removeAll { value in
                                            return value.id == i.id
                                        }
                                        
                                        
                                    } else {
                                        self.favorites.favoriteMovies.append(i)
                                    }
                                }) {
                                    Image(systemName: self.favorites.favoriteMovies.contains(where: {$0.id == i.id}) ? "star.fill" : "star")
                                }
                                .padding()
                                .accessibility(identifier: self.favorites.favoriteMovies.contains(where: {$0.id == i.id}) ? "highlighted" : "button" )
                            }
                        }
                    }.tabItem {
                    Image(systemName: "bubble.left")
                    Text("Peliculas")
                }.tag(0)
                List(favorites.favoriteMovies){ i in
                    HStack{
                        Text(i.title)
                        Spacer()                        
                        Button(action: {
                            if self.favorites.favoriteMovies.contains(where: {$0.id == i.id}) {
                                self.favorites.favoriteMovies.removeAll { value in
                                    return value.id == i.id
                                }
                                
                                
                            } else {
                                self.favorites.favoriteMovies.append(i)
                            }
                        }) {
                            Image(systemName: self.favorites.favoriteMovies.contains(where: {$0.id == i.id}) ? "star.fill" : "star")
                        }
                        .padding()
                        .accessibility(identifier: self.favorites.favoriteMovies.contains(where: {$0.id == i.id}) ? "highlighted" : "button" )
                    }
                }
                .tabItem {
                    Image(systemName: "bubble.left")
                    Text("Favoritas")
                }.tag(1)
            }
        }
    func addMovie(){
        observed.getMovies()
    }
}

struct MoviesData : Identifiable{
    public var id: Int
    public var title: String
    public var poster_path: String
    public var favorite = false
}

class Favorites  : ObservableObject{
    @Published var favoriteMovies = [MoviesData]()

    init() {
        getFavoriteMovies()
    }
    

        
    func getFavoriteMovies()
    {

        
    }
}
class Observer : ObservableObject{
    @Published var movies = [MoviesData]()

    init() {
        getMovies()
    }
    

        
    func getMovies(search: String = "")
    {
        var requestString = "https://api.themoviedb.org/3/search/movie?api_key=acc3246eeaf96ed745a371693ddef3ad&language=es-ES&page=1&include_adult=false&query=" + search
        if search == "" {
            requestString = "https://api.themoviedb.org/3/movie/popular?api_key=acc3246eeaf96ed745a371693ddef3ad&language=es-ES&page=1"
            
        }
        AF.request(requestString)
            .responseJSON{
                response in
                if let json = response.value {
                    if  (json as? [String : AnyObject]) != nil{
                        if let dictionaryArray = json as? Dictionary<String, AnyObject?> {
                            let jsonArray = dictionaryArray["results"]

                            if let jsonArray = jsonArray as? Array<Dictionary<String, AnyObject?>>{
                                if jsonArray.count > 0 {
                                    self.movies.removeAll()
                                }
                                for i in 0..<jsonArray.count{
                                    let json = jsonArray[i]
                                    if let id = json["id"] as? Int, let title = json["title"] as? String, let poster_path = json["poster_path"] as? String{
                                        self.movies.append(MoviesData(id: id, title: title, poster_path: poster_path))
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
