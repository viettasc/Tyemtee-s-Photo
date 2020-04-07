//
//  FrameView.swift
//  PhotoFrame
//
//  Created by Viettasc Doan on 4/6/20.
//  Copyright © 2020 Viettasc Doan. All rights reserved.
//

import SwiftUI

struct FitImage: View {
    var image: Image
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct FrameView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Photo.entity(), sortDescriptors: []) var photos: FetchedResults<Photo>
    var body: some View {
        VStack {
            Text("Tyemtee \(photos.count)")
                .font(.largeTitle)
                .onAppear {
                    self.urls()
            }
            Button("Description") {
                self.description()
            }
            ForEach(photos, id: \.self) { item in
                HStack {
                    FitImage(image: Image(uiImage: UIImage(data: Data(base64Encoded: item.first ?? Data()) ?? Data()) ?? UIImage()))
                    FitImage(image: Image(uiImage: UIImage(data: Data(base64Encoded: item.second ?? Data()) ?? Data()) ?? UIImage()))
                    FitImage(image: Image(uiImage: UIImage(data: Data(base64Encoded: item.third ?? Data()) ?? Data()) ?? UIImage()))
                }
                .padding()
            }
            Spacer()
        }
        .foregroundColor(Color.pink.opacity(0.6))
    }
    
    func description() {
        if !photos.isEmpty {
            let last = photos.count - 1
            for i in 0...last {
                print("photo \(i)")
                print("url1: \(String(describing: photos[i].url1))")
                print("url1: \(String(describing: photos[i].url2))")
                print("url1: \(String(describing: photos[i].url3))")
            }
        }
    }
    
    func download(string: String, number: Int, photo: Photo) {
        if let url = URL(string: string) {
            URLSession.shared.downloadTask(with: url) { local, response, unexpect in
                if let local = local,
                    let data = try? Data(contentsOf: local) {
                    switch number {
                    case 0:
                        photo.url1 = string
                        photo.first = data.base64EncodedData()
                        break
                    case 1:
                        photo.url2 = string
                        photo.second = data.base64EncodedData()
                        break
                    default:
                        photo.url3 = string
                        photo.third = data.base64EncodedData()
                        break
                    }
                    if !self.photos.contains(photo) {
                        try? self.moc.save()
                    }
                }  else {
                    print("Unexpected: \(self) - \(#function) - \(#line) - \(unexpect?.localizedDescription ?? "url nil")")
                    self.download(string: string, number: number, photo: photo)
                }
            }.resume()
        } else {
            print("Unexpected: \(self) - \(#function) - \(#line) - url nil")
        }
    }
    
    func clear() {
        if !photos.isEmpty {
            for photo in photos {
                if photo.url1 == nil ||
                    photo.url2 == nil ||
                    photo.url3 == nil ||
                    photo.first == nil ||
                    photo.second == nil ||
                    photo.third == nil {
                    self.moc.delete(photo)
                }
            }
        }
    }
    
    func remove(for draft: inout [String]) {
        if !draft.isEmpty {
            let last2 = draft.count - 1
            for i in 0...last2 {
                if self.contain(for: draft[i]) {
                    draft.remove(at: i)
                    remove(for: &draft)
                    break
                }
            }
        }
    }
    
    func urls() -> Void {
        //
        clear()
        guard let url = URL(string: "https://www.instagram.com/tyemtee/") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        // = dispatch
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let string = String(data: data, encoding: .ascii) {
                    let lines = string.components(separatedBy: [" ", "\n", "{", "\""])
                    let last = lines.count - 1
                    var draft: [String] = []
                    for i in 0...last {
                        let line = lines[i]
                        if line.contains("s640x640") {
                            let replace = line.replacingOccurrences(of: "\\u0026", with: "&")
                            if !draft.contains(replace), !self.contain(for: replace) {
                                draft.append(replace)
                            }
                        }
                    }
                    self.remove(for: &draft)
                    
                    if !draft.isEmpty {
                        let last2 = draft.count - 1
                        
                        let size = last2 / 3
                        for i in 0...size {
                            let new = Photo(context: self.moc)
                            for j in 0...2 {
                                let index = i * 3 + j
                                if last >= index {
                                    let string = draft[index]
                                    print("string: ", string)
                                    print("contain: ", self.contain(for: string))
                                    self.download(string: draft[index], number: j, photo: new)
                                }
                            }
                        }
                    }
                } else {
                    print("string nil")
                }
            } else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                self.urls()
            }
        }.resume()
    }
    
    func contain(for string: String) -> Bool {
        if !photos.isEmpty {
            for photo in photos {
                if let url1 = photo.url1,
                    url1 == string {
                    return true
                }
                if let url2 = photo.url2,
                    url2 == string {
                    return true
                }
                if let url3 = photo.url3,
                    url3 == string {
                    return true
                }
            }
        }
        return false
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView()
    }
}
