//
//  LoadView.swift
//  PhotoFrame
//
//  Created by Viettasc Doan on 4/6/20.
//  Copyright © 2020 Viettasc Doan. All rights reserved.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct LoadView: View {
    @State var results = [Result]()
    @State var string = "Tyemtee"
    
    var body: some View {
        ScrollView {
            Text(string)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear(perform: loadData)
        }
        
//        List(results, id: \.trackId) { item in
//            VStack(alignment: .leading, spacing: 0) {
//                Text(item.trackName)
//                    .font(.headline)
//                Text(item.collectionName)
//            }
//        }
//        .onAppear(perform: loadData)
//        .foregroundColor(Color.pink.opacity(0.6))
    }
    
//    s640x640
    
    func bundle() {
        if let url = Bundle.main.url(forResource: "html", withExtension: "txt") {
            if let data = try? Data(contentsOf: url) {
                if let string = String(data: data, encoding: .utf8) {
                    let lines = string.components(separatedBy: [" ", "\n", "{", "\""])
                    for line in lines {
                        if line.contains("s640x640") {
                            print(line)
                            print("---")
                        }
                    }
//                    let lines = string.components(separatedBy: [" ", "\n", "{"])
//                    var draft: [String] = []
//                    for line in lines {
//                        if line.contains("\"config_width\":640,\"config_height\":640") {
//                            draft.append(line)
//                        }
//                    }
//                    self.string = "\(draft)"
//                    for item in draft {
//                        let component = item.components(separatedBy: ["\""])
//                        for sub in component {
//                            if sub.contains("https") {
//                                print(sub)
//                                print("---")
//                            }
//                        }
//                    }
                } else {
                    print("bundle string nil")
                }
            } else {
                print("bundle data nil")
            }
        } else {
            print("bundle url nil")
        }
    }
    
    func loadData() {
        guard let url = URL(string: "https://www.instagram.com/tyemtee/") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            //            print("response: ", response)
            if let data = data {
                if let string = String(data: data, encoding: .ascii) {
                    let lines = string.components(separatedBy: [" ", "\n", "{", "\""])
                    for line in lines {
                        if line.contains("s640x640") || line.contains("s1024x1024") {
                            let replace = line.replacingOccurrences(of: "\\u0026", with: "&")
                            print(replace)
                            print("---")
                            self.string += "\n\(replace)"
                        }
                    }
                } else {
                    print("string nil")
                }
//                let strings = String(data: data, encoding: .ascii) ?? "nil"
//                self.string = String(data: data, encoding: .ascii) ?? "nil"
//                print("string: ", self.string)
                
//                let search = "eLAPa RzuR0"
                
                
//                if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
//                    self.string = attributedString.string
//                } else {
//                    self.string = "attribute nil"
//                }
                
//                let array = strings.components(separatedBy: .whitespacesAndNewlines)
//                self.string = "\(array)"
//                print("string: ", self.string)
                
                //
                
                
//                if let response = try? JSONDecoder().decode(Response.self, from: data) {
//                    DispatchQueue.main.async {
//                        self.results = response.results
//                    }
//                    return
//                }
            }
            //            print("response: ", response)
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

//func getData() -> Void {
//
//    let data = try? Data(contentsOf: URL(string: "https://www.instagram.com/tyemtee")!)
//    let doc = TFHpple(htmlData: data!)
//    let path = "//ul[@class='fn-list']/li"
//    if let elements = doc?.search(withXPathQuery: path) as? [TFHppleElement] {
//        for element in elements {
//            DispatchQueue.global(qos: .default).async {
//                if let id = element.attributes["data-id"] as? String {
//                    let titlePath = "//h3/a"
//                    var titleString = ""
//                    if let titles = element.search(withXPathQuery: titlePath) as? [TFHppleElement] {
//                        titleString = titles[0].content!
//                    } else {
//                        print("Id: \(id) - titleString is empty.")
//                    }
//                    // Start: Artist
//                    let artistPath = "//h4[@class='title-sd-item txt-info fn-artist']/a"
//                    var artistString = ""
//
//                    if let artists = element.search(withXPathQuery: artistPath) as? [TFHppleElement] {
//                        var artistCount = 0
//                        for artist in artists {
//                            if artists.count <= 1 {
//                                artistString = artist.content!
//                            } else {
//                                artistString += ", \(artist.content!)"
//                            }
//                            artistCount += 1
//                        }
//                    } else {
//                        print("id: \(id) - artistString is empty.")
//                    }
//                    // End: Artist
//
//                    // Start: thumbnail
//                    let thumbnailPath = "//img"
//                    var thumbnailString = ""
//
//                    if let thumbnails = element.search(withXPathQuery: thumbnailPath) as? [TFHppleElement] {
//                        thumbnailString = thumbnails[0].attributes["src"] as! String
//                    } else {
//                        print("id: \(id) - thumbnailString is empty.")
//                    }
//
//                    let song = Song(id, "", titleString, artistString, thumbnailString, "")
//                    self.tempList.append(song)
//                    self.threadCount[id] = true
//                }
//            }
//        }
//
//        // Initial a timer as a thread to get song links
//        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerForCount(sender:)), userInfo: nil, repeats: true)
//    }
//}

struct LoadView_Previews: PreviewProvider {
    static var previews: some View {
        LoadView()
    }
}
