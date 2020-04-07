////
////  New.swift
////  PhotoFrame
////
////  Created by Viettasc Doan on 4/6/20.
////  Copyright © 2020 Viettasc Doan. All rights reserved.
////
//
//import SwiftUI
//
//struct New: View {
//    
//    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(entity: Photo.entity(), sortDescriptors: []) var photos: FetchedResults<Photo>
//    @State var string = "Tyemtee"
////    @State var image = UIImage()
////    @State var image1 = UIImage()
////    @State var image2 = UIImage()
////    @State var image3 = UIImage()
//    var body: some View {
//        VStack {
//            Text(string)
//                .onAppear {
//                    let image = UIImage(named: "tyemtee")
//                    let data3 = image?.pngData()
//                    let new = Photo(context: self.moc)
//                    new.data = data3?.base64EncodedData()
////                    new.string = data3?.base64EncodedString()
//                    try? self.moc.save()
//            }
//            ForEach(photos, id: \.self) { photo in
//                HStack {
////                    Image(uiImage: UIImage(data: Data(base64Encoded: photo.string ?? "") ?? Data()) ?? UIImage())
////                        .resizable()
////                        .scaledToFit()
//                    Image(uiImage: UIImage(data: Data(base64Encoded: photo.data ?? Data()) ?? Data()) ?? UIImage())
//                        .resizable()
//                        .scaledToFit()
//                }
//
//            }
//        }
//        
//    }
//}
//
////struct New_Previews: PreviewProvider {
////    static var previews: some View {
////        New()
////    }
////}
//
////struct New_Previews: PreviewProvider {
////    static var previews: some View {
////        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
////    }
////}
