//
//  model.swift
//  MVCHW9
//
//  Created by ？？？ on 4/29/23.
//

import Foundation

class TheModel{
    var category : String
    var kw : String
    var position : String
    var distance: Int
    
    init() {
        self.kw = ""
        self.position = ""
        self.distance = 10
        self.category = "Default"
    }
    
    func updateKw(newKw:String){
        self.kw = newKw
    }
    
    func updateDis(dis:Int){
        self.distance = dis
    }
    
    func updatePos(pos:String){
        self.position = pos
    }
    
    func updateCat(cat:String){
        self.category = cat
    }
    
    func searchResult()->[[String:Any]]{
        var urlString = ""
        if(self.category=="Default"){
            let baseUrl = "http://localhost:8080/"
            var keyword = kw.replacingOccurrences(of: " ", with: "+")
            var pos = position.replacingOccurrences(of: " ", with: "+")
            urlString = "\(baseUrl)\(keyword)/\(distance)/\(pos)"
    //        print(urlString)
            
        }else{
            var cate = "";
            if(self.category=="Music"){
                cate = "KZFzniwnSyZfZ7v7nJ"
            }else if(self.category=="Art & Theatre"){
                cate = "KZFzniwnSyZfZ7v7na"
            }else if(self.category=="Sports"){
                cate = "KZFzniwnSyZfZ7v7nE"
            }else if(self.category=="Film"){
                cate = "KZFzniwnSyZfZ7v7nn"
            }else if(self.category=="Miscellaneous"){
                cate = "KZFzniwnSyZfZ7v7n1"
            }
            let baseUrl = "http://localhost:8080/"
            var keyword = kw.replacingOccurrences(of: " ", with: "+")
            var pos = position.replacingOccurrences(of: " ", with: "+")
            urlString = "\(baseUrl)\(self.kw)/\(cate)/\(self.distance)/\(self.position)"
        }
        
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
}
