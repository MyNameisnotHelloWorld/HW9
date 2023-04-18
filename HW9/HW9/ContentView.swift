//
//  ContentView.swift
//  HW9
//
//  Created by ？？？ on 4/3/23.
//

import SwiftUI
import UIKit


struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
        
    }
}



        

struct ContentView: View {
//    @State var chooseOption = "Default"
//    @State var kw = ""
//    @State var selectedOption = ""
//    @State var position = ""
//
//    @State var autoValue = false
//    @State var distance: Int = 10
//    @State var option_lst = ["Default","Music","Sports","Arts & Theatre","Film","Miscellaneous"]
    var body: some View {
        NavigationView {
            VStack{
                ZStack(alignment: .topTrailing) {
                    
                    formView()
                    
                    gotoFav()
                }
                
                
                
            }
            
        }
    }
    
    
    
}

//func formView(kw:Binding<String>,distance:Binding<Int>,chooseOption:Binding<String>,position:Binding<String>,autoValue:Binding<Bool>,isSubmit:Binding<Bool>,isClean:Binding<Bool>)->some View{

struct formView : View{
    @State var chooseOption = "Default"
    @State var kw = ""
    @State var selectedOption = ""
    @State var position = ""
    @State var isClean = false
    @State var isSubmit = false
    @State var autoValue = false
    @State var distance: Int = 10
    @State var totalResult: [[String:Any]] = []
    @State var option_lst = ["Default","Music","Sports","Arts & Theatre","Film","Miscellaneous"]
    @State var showTableView = false
    var body: some View{
        
        VStack{

            Form{
                
                Section(header:  SwiftUI.VStack(alignment: .leading, spacing: 0) {
                    Text("Event Search")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .textCase(.none)
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGroupedBackground))
                ) {
                    Section{
                        HStack {
                            Text("Keyword: ")
                                .font(.headline)
                                .foregroundColor(Color.gray)
                            TextField("Required", text: $kw)
                                .textFieldStyle(PlainTextFieldStyle())
                                .keyboardType(.default)
                            
                        }
                        HStack {
                            Text("Distance:")
                                .font(.headline).foregroundColor(Color.gray)
                            TextField("Required", value: $distance, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        HStack {
                            Text("Category")
                                .font(.headline).foregroundColor(Color.gray)
                            Picker("", selection: $chooseOption) {
                                ForEach(option_lst, id: \.self) { option in Text(option).tag(option)}
                            }.pickerStyle(.menu)
                        }
                        if(autoValue == false){
                            HStack {
                                Text("Location: ")
                                    .font(.headline)
                                    .foregroundColor(Color.gray)
                                TextField("Required", text: $position)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .keyboardType(.default)
                            }
                        }
                        
                        HStack{
                            Toggle(isOn: $autoValue) {
                                Text("Auto-detected my location")
                                    .foregroundColor(Color.gray)
                            }
                        }
                        
                        
                        
                    }
                        Section{
                            HStack{
                                VStack{
                                    Button(action: {
                                        if(autoValue==true){
                                            position = "auto_detected"
                                        }
                    
                                        if(kw.isEmpty){
                                            print("no kw")
                                            let alertController = UIAlertController(title: "Alert", message: "Keywords is empty", preferredStyle: .alert)
                                            let okAction = UIAlertAction(title: "OK", style: .default,handler: nil)
                                            alertController.addAction(okAction)
                                            UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
                                            isSubmit = false
                                        }else if(kw.isEmpty == false && position.isEmpty && autoValue==false){
                                            print("no loc")
                                            isSubmit = false
                                            let alertController = UIAlertController(title: "Alert", message: "Location is empty", preferredStyle: .alert)
                                            let okAction = UIAlertAction(title: "OK", style: .default,handler: nil)
                                            alertController.addAction(okAction)
                                            UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
                    
                                        }else{
                                            totalResult = process_table(kw:kw,position:position,distance:distance,category:chooseOption,autoValue:autoValue)
                    
                    
                                            isSubmit = true
                                            isClean = false
                    
                    
                                        }
                    
                    
                                    }, label: {
                                        Rectangle()
                                            .foregroundColor(.red)
                                            .frame(width: 100, height: 50)
                                            .cornerRadius(10)
                                            .overlay(Text("Submit").foregroundColor(.white))
                                           
                                    }).buttonStyle(BorderedButtonStyle())
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 30)
                                }
                                VStack{
                                    Button(action: {
                                        chooseOption = "Default"
                                        kw = ""
                                        position = ""
                                        autoValue = false
                    
                                        distance = 10
                                        isClean = true
                                        isSubmit = false
                                        showTableView = false
                                        
                                        let alertController = UIAlertController(title: "Alert", message: "Everythings clean", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "OK", style: .default,handler: nil)
                                        alertController.addAction(okAction)
                                        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
                    
                                        //
                                    }, label: {
                                        Rectangle()
                                            .foregroundColor(.blue)
                                            .frame(width: 100, height: 50)
                                            .cornerRadius(10)
                                            .overlay(Text("Clear").foregroundColor(.white))
                                            
                                    }).buttonStyle(BorderedButtonStyle())
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 20)
                                        
                                }
                            }
                        }
                    
                    

                    
                }
                if(isSubmit && isClean == false){
                    
                    Section{
                        Text("Result").font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black)
                            .textCase(.none)
                        if showTableView {
                                TableView(details: totalResult)
                        } else {
                            VStack (alignment: .center){
                                
                                    Spacer()
                                    ProgressView()
                                    
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                showTableView = true
                                            }
                                        }
                                    
                                    Spacer()
                                    Text("Please wait").foregroundColor(Color.gray)
                                
                                
                            }
                        }
                            
                    }
                }
            
                
            
                
            }

            
            
            
        }
    }
    
}

struct detailView: View{
    var event_details:[String:Any]
    
    var body: some View{
        
        VStack{
            Section{
                if let event = event_details["event"]! as? String {
                    Text(event).font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .textCase(.none)
                }
            }
        }
        TabView {
            
                Text("Events")
                    .tabItem {
                        Image(systemName: "text.bubble.fill")
                        Text("Events")
                }
                Text("Artist/Team")
                    .tabItem {
                        Image(systemName: "guitars.fill")
                        Text("Artist/Team")
                }
                Text("Nearby Screen")
                    .tabItem {
                        Image(systemName: "location.fill")
                        Text("Venue")
                }
        }
    }
}

struct TableView : View{
    var details:[[String:Any]]
    
    var body: some View{
        if(details.count>0){
            List(details.indices, id:\.self){
                index in
                NavigationLink(destination: detailView(event_details: details[index])){
                    HStack{
                        if let date = details[index]["localDate"]! as? String {
                            if let time = details[index]["localTime"]! as? String {
                                Text("\(date) | \(time)")
                            }
                        }
                        
                        //Reference https://www.appcoda.com.tw/asyncimage/
                        Section{
                            if let img = details[index]["image"]! as? String {
                                AsyncImage(url: URL(string: img)){ phase in
                                    switch phase{
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
                            }
                            
                        }
                        .frame(width: 20, height: 20)
                        
                        Section{
                            if let event = details[index]["event"]! as? String {
                                Text(event)
                            }
                        }
                        Section{
                            if let classifications = details[index]["classifications"]! as? String {
                                Text(classifications)
                            }
                        }
                        
                    }
                }
                
                
            }
        }else{
            
            List((0...0), id:\.self){
                index in
                Text("No result available").foregroundColor(.red)
            }
        }
    }
    
}


func gotoFav()->some View{
    NavigationLink(destination: FavouriteView()) {
                ZStack {
                Circle()
                .fill(Color.white)
                .overlay(Circle().stroke(Color.blue, lineWidth: 1))
                Image(systemName: "heart.fill")
                .foregroundColor(.blue)
            }.frame(width: 23, height: 23)
        }.padding(.trailing, 10)
    
    
}




struct FavouriteView: View {
    var body: some View {
        Text("This is the second view")
    }
}




func process_table(kw:String,position:String,distance:Int,category:String,autoValue:Bool)->[[String:Any]]{
    print("++++++++++++++++++++++++++++")
    print(kw)
    print(position)
    print(distance)
    print(category)
    print("________________________")
    var urlString = ""
    if(category=="Default"){
        let baseUrl = "http://localhost:8080/"
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
        let baseUrl = "http://localhost:8080/"
        var keyword = kw.replacingOccurrences(of: " ", with: "+")
        var pos = position.replacingOccurrences(of: " ", with: "+")
        urlString = "\(baseUrl)\(keyword)/\(cate)/\(distance)/\(pos)"
    }
    
    let url = URL(string:urlString)!
    
    let session = URLSession.shared
    var jsonArray: [[String: Any]] = []
    do{
        let data = try Data(contentsOf: url)
        let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
        
        return jsonArray
    }catch{
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
