//
//  Controller.swift
//  HW9
//
//  Created by ？？？ on 4/16/23.
//

import Foundation
import SwiftUI


struct gotoFav:View{
    
    var body: some View{
        NavigationLink(destination: FavouriteView()) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .overlay(Circle().stroke(Color.blue, lineWidth: 1))
                Image(systemName: "heart.fill")
                    .foregroundColor(.blue)
            }.frame(width: 23, height: 23)
        }.padding(.trailing, 20)
            .navigationTitle("Event Search")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
    }
}






func process_table(kw:String,position:String,distance:Int,category:String,autoValue:Bool)->[[String:Any]]{
//    print("++++++++++++++++++++++++++++")
//    print(kw)
//    print(position)
//    print(distance)
//    print(category)
//    print("________________________")
    var urlString = ""
    if(category=="Default"){
//        let baseUrl = "http://12e11.us-west-2.elasticbeanstalk.com/"
        let baseUrl = "http://kdodw.us-west-2.elasticbeanstalk.com/"
        var keyword = kw.replacingOccurrences(of: " ", with: "+")
        var pos = position.replacingOccurrences(of: " ", with: "+")
        urlString = "\(baseUrl)\(keyword)/\(distance)/\(pos)"
//        print(urlString)
        
    }else{
        var cate = "";
        if(category=="Music"){
            cate = "KZFzniwnSyZfZ7v7nJ"
        }else if(category=="Art & Theatre"){
            cate = "KZFzniwnSyZfZ7v7na"
        }else if(category=="Sports"){
            cate = "KZFzniwnSyZfZ7v7nE"
        }else if(category=="Film"){
            cate = "KZFzniwnSyZfZ7v7nn"
        }else if(category=="Miscellaneous"){
            cate = "KZFzniwnSyZfZ7v7n1"
        }
//        let baseUrl = "http://12e11.us-west-2.elasticbeanstalk.com"
        let baseUrl = "http://kdodw.us-west-2.elasticbeanstalk.com"
        var keyword = kw.replacingOccurrences(of: " ", with: "+")
        var pos = position.replacingOccurrences(of: " ", with: "+")
        urlString = "\(baseUrl)/\(keyword)/\(cate)/\(distance)/\(pos)"
        
    }
    print(urlString)
    let url = URL(string:urlString)!
    
//    let session = URLSession.shared
//    var jsonArray: [[String: Any]] = []
    do{
        let data = try Data(contentsOf: url)
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
//        print(jsonArray)
//        print(urlString)
        return jsonArray
    }catch{
        print(urlString)
        print("Error: \(error.localizedDescription)")
        return []
    }
    
    
}

func listView(result:[[String: Any]],empty:Bool)->some View{
    if(empty){
        return Text("Nothings")
    }else{
        return Text("Yes")
    }
}

func find_singer(resultData:[[String:Any]]) -> [[[String:Any]]]{
    var collection : [[[String:Any]]] = []
    
    for event in resultData{
        let team = event["content"]! as! String
        let split_team = team.split(separator: " | ").map{$0.trimmingCharacters(in: .whitespaces)}
        
        
        if !split_team .isEmpty{
            for each_member in split_team{
                let replacedString = each_member.replacingOccurrences(of: " ", with: "+")
//                let baseUrl = "http://12e11.us-west-2.elasticbeanstalk.com/artist/\(replacedString)"
                let baseUrl = "http://kdodw.us-west-2.elasticbeanstalk.com/artist/\(replacedString)"
                print(baseUrl)
                
                let myurl = URL(string:baseUrl)!
                
                    
                    //    let session = URLSession.shared
                    //    var jsonArray: [[String: Any]] = []
                    do{
                        let data = try Data(contentsOf: myurl)
                        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
                        print(myurl)
                        print(jsonArray)
                        collection.append(jsonArray)
                    }catch{
                        print("Error: \(error.localizedDescription)")
                        collection.append([])
                    }
                }
        }else{
            return []
        }
        
    }
    return collection
    
}

func find_singer2(resultData:String) -> [[[String:Any]]]{
    var collection :[[[String:Any]]] = []
    var lst = resultData.split(separator: " | ").map{$0.trimmingCharacters(in: .whitespaces)}
    
    for member in lst{
        var noSpace = member.replacingOccurrences(of: " ", with: "+")
//        let baseUrl = "http://12e11.us-west-2.elasticbeanstalk.com/artist/\(noSpace)"
        let baseUrl = "http://kdodw.us-west-2.elasticbeanstalk.com/artist/\(noSpace)"
        
        
        let myurl = URL(string:baseUrl)!
        do{
            let data = try Data(contentsOf: myurl)
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
//            print(myurl)
//            print(jsonArray)
            collection.append(jsonArray)
        }catch{
            print("error at find singer2")
            print("Error: \(error.localizedDescription)")
            collection.append([])
        }
    }
    return collection
}
    
    

func getAlu(id:String)->[String]{
    let baseUrl = "http://kdodw.us-west-2.elasticbeanstalk.com/albums/\(id)"
    let url = URL(string: baseUrl)!

    do{
        let data = try Data(contentsOf: url)
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String] ?? []
//        print(jsonArray)
//        print(urlString)
        print(jsonArray)
        return jsonArray
    }catch{
        print(url)
        print("Error: \(error.localizedDescription)")
        return []
    }
}


func handleVenues(id:String)->[String:Any]{
    var baseURL = URL(string:"http://kdodw.us-west-2.elasticbeanstalk.com/venues/\(id)")!
    print("Venues: "+"http://kdodw.us-west-2.elasticbeanstalk.com/venues/\(id)")
    do{
        let data = try Data(contentsOf: baseURL)
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? ["":""]
//        print(jsonArray)
//        print(urlString)
        return jsonArray
    }catch{
        print(baseURL)
        print("Error: \(error.localizedDescription)")
        return ["error":"\(error.localizedDescription)"]
    }
}

//func autoGet(kw:String)->[String]{
//    var keyword = kw.replacingOccurrences(of: " ", with: "+")
//    var baseURL = URL(string:"http://localhost:8080/autoWord/\(keyword)")!
//    print("Venues: "+"http://localhost:8080/autoWord/\(kw)")
//    do{
//        let data = try Data(contentsOf: baseURL)
//        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String] ?? []
//        print(jsonArray)
////        print(urlString)
//        return jsonArray
//    }catch{
//        print(baseURL)
//        print("Error: \(error.localizedDescription)")
//        return ["\(error.localizedDescription)"]
//    }
//}

func autoGet(kw: String) -> [String] {
    var keyword = kw.replacingOccurrences(of: " ", with: "+")
    var baseURL = URL(string: "http://kdodw.us-west-2.elasticbeanstalk.com/autoWord/\(keyword)")!
    print("Venues: " + "http://kdodw.us-west-2.elasticbeanstalk.com/autoWord/\(kw)")
    
    let semaphore = DispatchSemaphore(value: 0)
    var jsonArray: [String] = []
    
    let request = URLRequest(url: baseURL, timeoutInterval: 2) // Set timeout to 10 seconds
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        defer {
            semaphore.signal()
        }
        
        if let error = error {
            print("error = ")
            print("Error: \(error.localizedDescription)")
            return
        }
        
        if let data = data {
            do {
                jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String] ?? []
                print(jsonArray)
            } catch {
                print("data Error")
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    task.resume()
    _ = semaphore.wait(timeout: .distantFuture)
    
    return jsonArray
}

func storeFav(data:[String:String]){
    var eventN = data["event"]! as! String
    UserDefaults.standard.set(data,forKey:eventN)
}

func check_inFav(name:String)->Bool{
    let dict = UserDefaults.standard.object(forKey: "favourite list")
    if UserDefaults.standard.object(forKey: name) as? [String: Any] != nil {
            return true
    } else {
            return false
    }
}

func remove_fav(name:String){
    UserDefaults.standard.removeObject(forKey: name)
}

func getAllUserDefaults() -> [String: [String: Any]] {
   
    let userDefaults = UserDefaults.standard
    let dictionary = userDefaults.dictionaryRepresentation()
    var final: [String: [String: Any]] = [:]

    if dictionary.keys.contains("favourite list") {
        let n = dictionary["favourite list"]! as! [String: [String: Any]]
        print(n.count)
        return n
    } else {
        UserDefaults.standard.set(final,forKey:"favourite list")
        let n = dictionary["favourite list"]! as! [String: [String: Any]]
        print(n.count)
        return n
    }
    
   
}

func clearUserDefaults() {
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
    print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
}
