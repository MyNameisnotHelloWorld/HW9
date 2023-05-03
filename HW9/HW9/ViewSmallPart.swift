//
//  ViewSmallPart.swift
//  HW9
//
//  Created by ？？？ on 4/30/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit


struct VenueMap : View{
    var themap:[String]
    @State private var isMap = false
    var body: some View{
        VStack {
            HStack {
                Spacer()
                let _ = print(themap)
                Button(action: {
                    isMap.toggle()
                        }, label: {
                            Rectangle()
                                .foregroundColor(.red)
                                .frame(width: 200, height: 50)
                                .cornerRadius(10)
                                .overlay(Text("Show venue maps").foregroundColor(.white))
                        })
                        .buttonStyle(BorderedButtonStyle())
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                Spacer()
            }.popover(isPresented: $isMap, arrowEdge: .top) {
                SheetView(lat: Double(themap[1])!, long: Double(themap[0])!)
            }
            // Rest of the code...
        }
    }
}

struct SheetView: View {
    var lat:Double
    var long:Double
    var body: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
            .frame(maxWidth:900, maxHeight: 700)
            .ignoresSafeArea()
    }
}

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        view.addAnnotation(annotation)
        view.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)), animated: true)
    }
}

struct VenueChildRule : View{
    var childRule:String
    var body: some View{
        VStack {
            HStack {
                Spacer()
                Text("Child Rule")
                    .foregroundColor(.black)
                    .font(.system(size: 25, weight: .bold))
                Spacer()
            }
            ScrollView {
                
                Text(childRule)
                .foregroundColor(.gray)
                .padding()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                
            }.frame(height: 50)
        }
    }
}

struct VenueGeneralRule : View{
    var generalRule:String
    var body: some View{
        VStack {
            HStack {
                Spacer()
                Text("General Rule")
                    .foregroundColor(.black)
                    .font(.system(size: 25, weight: .bold))
                Spacer()
            }
            ScrollView {
                
                Text(generalRule)
                .foregroundColor(.gray)
                .padding()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                
            }.frame(height: 50)
        }
    }
}

struct VenueOpenHour : View{
    var openhour:String
    var body: some View{
        VStack {
            HStack {
                Spacer()
                Text("Open Hours")
                    .foregroundColor(.black)
                    .font(.system(size: 25, weight: .bold))
                Spacer()
            }
            ScrollView {
                
                Text(openhour)
                .foregroundColor(.gray)
                .padding()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                
            }.frame(height: 50)
        }
    }
}

struct VenuePhone : View{
    var phone:String
    var body: some View{
        VStack {
            HStack {
                Spacer()
                Text("Phone Number")
                    .foregroundColor(.black)
                    .font(.system(size: 25, weight: .bold))
                Spacer()
            }
            ScrollView {
                Text(phone)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            }.frame(height: 30)
        }
    }
}


struct VenueN : View{
    var name:String
    var body: some View{
        VStack {
            HStack {
                Spacer()
                Text("Name")
                    .foregroundColor(.black)
                    .font(.system(size: 25, weight: .bold))
                Spacer()
            }
            HStack {
                Spacer()
                Text(name)
                    .foregroundColor(.gray)
                    .font(.system(size: 25, weight: .bold))
                    .textCase(.none)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }
    }
}

struct VenueAddress : View{
    var address:String
    var body: some View{
        VStack {
            HStack {
                Spacer()
                Text("Address")
                    .foregroundColor(.black)
                    .font(.system(size: 25, weight: .bold))
                Spacer()
            }
            HStack {
                Spacer()
                Text(address)
                    .foregroundColor(.gray)
                    .font(.system(size: 25, weight: .bold))
                    .textCase(.none)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            // Rest of the code...
        }
    }
}

struct AlumnView: View {
    var pic_lst: [String]
    
    var body: some View {
        HStack {
            ForEach(0..<min(pic_lst.count, 3)) { index in
                AsyncImage(url: URL(string: pic_lst[index])) { phase in
                    switch phase {
                    case .empty:
                        Color.purple.opacity(0.1)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        Image(systemName: "exclamationmark.icloud")
                            .resizable()
                            .scaledToFit()
                    @unknown default:
                        Image(systemName: "exclamationmark.icloud")
                    }
                }
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            }
        }
    }
}

struct SpotifyView:View{
    var link: String
    
    var body: some View{
        HStack{
            
            Image("spotify_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            Link("Spotify", destination: URL(string: link)!)
                            .foregroundColor(Color.green)
        }
    }
}
struct Popularity: View{
    var popul: Int
    var body: some View{
        ZStack {
            Circle().stroke(Color.orange.opacity(0.3), lineWidth: 10).frame(width: 50, height: 50)
                           
            Circle()
                .trim(from: 0, to: Double(popul)*0.01)
                                .stroke(Color.orange, lineWidth: 10)
                                .rotationEffect(.degrees(-90))
                                .frame(width: 50, height: 50)
                           
            Text("\(popul)").font(.headline).foregroundColor(.white)
        }.padding()
    }
}

struct AutoComplete: View {
    @State private var selectedOption = 0
    var theW : String
    let options : [String]
    func findAuto(){
        if(!theW.isEmpty){
            
        }
    }

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(0..<options.count) { index in
                    Button(action: {
                        self.selectedOption = index
                    }) {
                        Text(options[index])
                            .font(.headline)
                            .padding(10)
                            .background(selectedOption == index ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            
            Text("Selected Option: \(options[selectedOption])")
                .font(.headline)
                .padding()
        }
    }
}

struct SuggestionsView: View{
    var kw:String
    @State private var loading = true
    @State private var theS:[String] = []
    @State public var choose = ""
    var body: some View{
        VStack{
            if(loading){
                
                VStack{
                    
                    Spacer()
                    HStack{
                        Spacer()
                        ProgressView().onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    theS = autoGet(kw: kw)
                                    loading = false
                                }
                            }
                        Spacer()
                    }
                    Spacer()
                }
            }else{
                Section{
                    VStack{
                        Spacer()
                        Form{
                            Picker("",selection: $choose){
                            ForEach(0..<theS.count, id: \.self) { index in
                            Text(theS[index]).tag(theS[index])}
                            }.pickerStyle(.inline).background(Color.clear).accentColor(Color.white)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}



//struct AddFav: View{
//    var item:[String:Any]
//    @State public var isFav = false
//    var body: some View{
//        Section{
//            Button(action: {
//                storeFav(data: item)
//                isFav = true
//            }, label: {
//                Rectangle()
//                    .foregroundColor(.blue)
//                    .frame(width: 100, height: 50)
//                    .cornerRadius(10)
//                    .overlay(Text("save event").foregroundColor(.white))
//
//            }).buttonStyle(BorderedButtonStyle())
//                .padding(.vertical, 8)
//                .padding(.horizontal, 20)
//
//        }.padding(.bottom)
//    }
//}

//struct removeFav: View{
//    var name: String
//    @State public var isFav = true
//    var body: some View{
//        Section{
//            Button(action: {
//                remove_fav(name: name)
//                isFav = false
//            }, label: {
//                Rectangle()
//                    .foregroundColor(.red)
//                    .frame(width: 100, height: 50)
//                    .cornerRadius(10)
//                    .overlay(Text("Remove Favourite").foregroundColor(.white))
//                
//            }).buttonStyle(BorderedButtonStyle())
//                .padding(.vertical, 8)
//                .padding(.horizontal, 20)
//            
//        }.padding(.bottom)
//    }
//}



