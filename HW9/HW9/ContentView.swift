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
    @State var getteam = "Big Bang"
    
    var body: some View {
        NavigationView {
            VStack{
                VStack{
                    HStack{
                        Spacer()
                        gotoFav()
                    }
                    formView()
                    
//                    let all = "Ed Sheeran | Russ | Maisie Peters"
//                    let all_team = all.split(separator: " | ").map{$0.trimmingCharacters(in: .whitespaces)}
//                    let test = find_singer2(resultData: all)
//                    teamView(theTeam: test, correctName: all_team)
                }.background(Color(.systemGroupedBackground))



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
    @State var teamResult: [[[String:Any]]] = []
    @State var totalResult: [[String:Any]] = []
    @State var option_lst = ["Default","Music","Sports","Arts & Theatre","Film","Miscellaneous"]
    @State var showTableView = false
    var body: some View{
        
        VStack{

            Form{
                
                Section(header:  SwiftUI.VStack(alignment: .leading, spacing: 0) {
                    Text("Event Search")
                        .font(.system(size: 40, weight: .bold))
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
                    let totalResult = process_table(kw:kw,position:position,distance:distance,category:chooseOption,autoValue:autoValue)
                    
//                    let theResult = find_singer(resultData: totalResult)
                    Section{
                        Text("Results").font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black)
                            .textCase(.none)
                        if showTableView {
                            TableView(details: totalResult,theTeam: teamResult)
                        } else {
                            
                            VStack (alignment: .center){
                                HStack(alignment:.center){
                                    Spacer()
                                    ProgressView()
                                    
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                showTableView = true
                                            }
                                        }
                                    
                                    Spacer()
                                    
                                }
                                HStack(alignment:.center){
                                    Text("Please wait").foregroundColor(Color.gray)
                                }
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
//    var team_details:[[String:Any]]
    @State var loading:Bool
    var singer_lst:[[[String:Any]]]
    
    var body: some View{
        if(loading){
            VStack (alignment: .center){
                HStack(alignment:.center){
                    Spacer()
                    ProgressView()
                    
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                loading = false
                            }
                        }
                    
                    Spacer()
                    
                }
                HStack(alignment:.center){
                    Text("Please wait").foregroundColor(Color.gray)
                }
            }
        }else{
            TabView {
                let _ = print(event_details)
                eventsView(event_details: event_details)
                    .tabItem {
                        Image(systemName: "text.bubble.fill")
                        Text("Events")
                    }
                let all = event_details["content"]! as! String
//                let team_details = find_singer2(resultData: all)
                let all_team = all.split(separator: " | ").map{$0.trimmingCharacters(in: .whitespaces)}
//                let _ = print(team_details)
                teamView(theTeam: singer_lst,correctName: all_team)
                    .tabItem {
                        Image(systemName: "guitars.fill")
                        Text("Artist/Team")
                    }
                let v_id = event_details["venue_id"]! as! String
                let venuesInfo = handleVenues(id:v_id)
                VenuesView(info: venuesInfo, title: event_details["event"]! as! String,name: event_details["venue_name"]! as! String)
                    .tabItem {
                        Image(systemName: "location.fill")
                        Text("Venue")
                    }
            }
        }
    }
}


struct eventsView: View{
    var event_details:[String:Any]
    
    var body: some View{
        
        VStack{
            VStack(alignment: .leading){
                ZStack{
                    HStack{
                        Spacer()
                        if let event = event_details["event"]! as? String {
                            Text(event).font(.system(size: 25, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.bottom)
                                .textCase(.none)
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    }
                    
                }
                
                
                HStack{
                    
                    VStack(alignment: .leading){
                        Text("Date").font(.system(size: 20, weight: .bold))
                        if let date = event_details["localDate"]! as? String {
                            Text(date).font(.system(size: 15, weight: .bold))
                                .foregroundColor(.gray)
                                .textCase(.none)
                                
                        }
                    
                    }
                    Spacer()
                    
                    VStack(alignment: .trailing){
                        Text("Artist|Team").font(.system(size: 20, weight: .bold))
                        if let content = event_details["content"]! as? String {
                            Text(content).font(.system(size: 15, weight: .bold))
                                .foregroundColor(.gray)
                                .textCase(.none)
                                .frame(width: 150)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                
                        }
                    }
                    
                    
                    
                }
                
                
                HStack{
                    VStack(alignment: .leading){
                        Text("Venue").font(.system(size: 20, weight: .bold))
                        if let v_name = event_details["venue_name"]! as? String {
                            Text(v_name).font(.system(size: 15, weight: .bold))
                                .foregroundColor(.gray)
                                .textCase(.none)
                                
                            
                        }
                    }
                    Spacer()
                    
                    VStack(alignment: .trailing){
                        Text("Genre").font(.system(size: 20, weight: .bold))
                        if let genre = event_details["genre"]! as? String {
                            Text(genre).font(.system(size: 15, weight: .bold))
                                .foregroundColor(.gray)
                                .textCase(.none)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 150)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                    
                }
                
                HStack{
                    VStack(alignment: .leading){
                        Text("Price Range").font(.system(size: 20, weight: .bold))
                        if let price = event_details["price"] as? String {
                            Text(price).font(.system(size: 15, weight: .bold))
                                .foregroundColor(.gray)
//                                .textCase(.none)
                            
                        }
                        
                    }
                    Spacer()
                    
                    VStack(alignment: .trailing){
                        Text("Ticket Status").font(.system(size: 20, weight: .bold))
                        let status_t = event_details["event_status"]! as! String
                        if (status_t == "offsale"){
                            Section{
                                Rectangle()
                                    .foregroundColor(.red)
                                    .frame(width: 100, height: 30)
                                    .cornerRadius(10)
                                    .overlay(Text("Off Sale").foregroundColor(.white))
                            }
                        }else if(status_t == "on sale"){
                            Section{
                                Rectangle()
                                    .foregroundColor(.green)
                                    .frame(width: 100, height: 30)
                                    .cornerRadius(10)
                                    .overlay(Text("On Sale").foregroundColor(.white))
                            }
                        }else{
                            Section{
                                Rectangle()
                                    .foregroundColor(.yellow)
                                    .frame(width: 120, height: 30)
                                    .cornerRadius(10)
                                    .overlay(Text("Reschedule").foregroundColor(.white))
                            }
                        }
                    }
                    
                }
                Spacer()
                HStack{
                        Spacer()
                    Section{
                        Button(action: {
                            
                            print("click")
                            
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
                    }.padding(.bottom)
                        Spacer()
                    
                }
                Spacer()
                
                let map = event_details["map_url"]! as! String
                if (map==""){
                    let _ = print("empty")
                }else{
                    let _ = print("map")
                    let _ = print(map)
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            Section{
                                AsyncImage(url: URL(string: map)){ phase in
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
                            }.padding(.vertical).frame(width: 300, height: 200)
                            Spacer()
                        }
                        Spacer()
                        
                    }
                    Spacer()
                    let buy_ticket = event_details["url"]! as! String
                    let twitter = event_details["twitter"]! as! String
                    let facebook = event_details["facebook"]! as! String
                    HStack{
                        Spacer()
                        Text("Buy Ticket At: ")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .textCase(.none)
                        Link("TicketMaster", destination: URL(string: buy_ticket)!)
                            .foregroundColor(Color.blue)
                        Spacer()
                    }.padding(.top)
                    Spacer()
                        
                    
                    VStack{
                        HStack{
                            Spacer()
                            Text("Share on: ")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                                .textCase(.none)
                            Link(destination: URL(string:facebook)!) {
                                Image("f_logo_RGB-Blue_144")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                            }
                            Link(destination: URL(string:twitter)!) {
                                Image("Twitter social icons - circle - blue")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                }
                
            }
            
        }
    }
}
struct TableView : View{
    var details:[[String:Any]]
    var theTeam : [[[String:Any]]]
    
    var body: some View{
        if(details.count>0){
            let _ = print(theTeam)
            List(details.indices, id:\.self){
                index in
                NavigationLink(destination: detailView(event_details: details[index], loading: true, singer_lst:find_singer2(resultData: details[index]["content"]! as! String))){
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

                
            }.navigationTitle("Event Search")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
                
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
        }.padding(.trailing, 20)
        .navigationTitle("Event Search")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
}




struct FavouriteView: View {
    
    var body: some View {
        VStack {
            Text("This is the second view")
        }.navigationTitle("Favourite list")
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
//        let baseUrl = "http://12e11.us-west-2.elasticbeanstalk.com"
        let baseUrl = "http://localhost:8080"
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
                let baseUrl = "http://localhost:8080/\(replacedString)"
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
        let baseUrl = "http://localhost:8080/artist/\(noSpace)"
        
        
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
    
    

struct teamView: View {
    var theTeam: [[[String:Any]]]
    var correctName: [String]
    
    
    var body: some View {
        VStack(spacing: 10){
            if isNothing{
                Text("Nothings")
            }else{
                
                ScrollView{
                    ForEach(0..<theTeam.count, id:\.self){ outerIndex in
                        
                        ForEach(0..<theTeam[outerIndex].count, id:\.self){ insideIndex in
                            let part = theTeam[outerIndex][insideIndex]
                            let nameSearch = part["name"]! as! String
                            
                            if (correctName.contains(nameSearch)){
                                
                                Section{
                                    VStack{
                                        Spacer()
                                        HStack{
                                            Spacer()
                                            VStack{
                                                let pict = part["images"]! as! String
                                                Section{
                                                    AsyncImage(url: URL(string: pict)){ phase in
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
                                                }.frame(width: 100, height: 100)
                                                    .cornerRadius(10)
                                            }
                                            Spacer()
                                            HStack{
                                                let followers = part["followers"]! as! String
                                                VStack{
                                                    Text(nameSearch).font(.system(size: 18, weight: .bold))
                                                        .foregroundColor(.white)
                                                        .textCase(.none)
                                                    HStack{
                                                        Text(followers+" " ).font(.system(size: 15, weight: .bold))
                                                            .foregroundColor(.white)
                                                            .textCase(.none)
                                                        Text("Followers").font(.system(size: 12, weight: .bold))
                                                            .foregroundColor(.white)
                                                            .textCase(.none)
                                                    }
                                                    HStack{
                                                        SpotifyView(link: part["spotify_link"]! as! String)
                                                    }
                                                    
                                                }
                                                Spacer()
                                                VStack{
                                                    Spacer()
                                                    Text("Popularity").font(.system(size: 20, weight: .bold))
                                                        .foregroundColor(.white)
                                                        .textCase(.none)
                                                    let p = part["popularity"]! as! Int
                                                    
                                                    Popularity(popul: p)
                                                }
                                                
                                            }
                                            Spacer()
                                        }
                                        Spacer()
                                        let alu = getAlu(id: part["id"]! as! String)
                                        AlumnView(pic_lst: alu)
                                        Spacer()
                                        
                                        
                                    }
                                }.frame(width:350,height: 250)
                                    .background(Color(red: 61/255, green: 61/255, blue: 61/255))
                                    .cornerRadius(10)
                            }
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    private var isNothing: Bool{
        for outerArray in theTeam {
            for item in outerArray {
                let nameSearch = item["name"]! as! String
                    if correctName.contains(nameSearch) {
                            return false
                    }
                }
        }
        return true
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

func getAlu(id:String)->[String]{
    let baseUrl = "http://localhost:8080/albums/\(id)"
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



func handleVenues(id:String)->[String:Any]{
    var baseURL = URL(string:"http://localhost:8080/venues/\(id)")!
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

struct VenuesView:View{
    var info : [String:Any]
    var title : String
    var name : String
    var body: some View{
        VStack{
            HStack{
                Spacer()
                
                    Text(title).font(.system(size: 25, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.bottom)
                        .textCase(.none)
                        .multilineTextAlignment(.center)
                
                Spacer()
            }
            Spacer(minLength: 15)
            
            
            VenueN(name: name)
            VenueAddress(address: "123")
            VenuePhone(phone: info["phone"]! as! String)
            VenueOpenHour(openhour: info["open_hour"]! as! String)
            VenueGeneralRule(generalRule: info["generalRule"]! as! String)
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
                                .frame(width: 130, height: 30)
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
