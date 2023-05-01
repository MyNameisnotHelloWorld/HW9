//
//  ViewSmallPart.swift
//  HW9
//
//  Created by ？？？ on 4/30/23.
//

import Foundation
import SwiftUI

struct VenueMap : View{
    var map:[String]
    var body: some View{
        VStack {
            HStack {
                Spacer()
                Button(action: {
                            print("click")
                            // Perform action
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
            }
            // Rest of the code...
        }
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
            // Rest of the code...
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
            // Rest of the code...
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
            // Rest of the code...
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
            VStack {
                Spacer()
                Text(phone)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                Spacer()
            }
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



