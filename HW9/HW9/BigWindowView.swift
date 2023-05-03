//
//  BigWindowView.swift
//  HW9
//
//  Created by ？？？ on 4/30/23.
//

import Foundation
import SwiftUI
import Combine

//reference https://stackoverflow.com/questions/56550135/swiftui-global-overlay-that-can-be-triggered-from-any-view
struct Toast<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    let presenting:()->Presenting
    let text: Text

    var body: some View {

        GeometryReader { geometry in

            ZStack(alignment: .bottom) {

                self.presenting()
                    .blur(radius: self.isShowing ? 1 : 0)

                VStack {
                    self.text
                }
                .frame(width: geometry.size.width/2,
                       height: geometry.size.height/5)
                .transition(.slide)
//                .onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                      withAnimation {
//                        self.isShowing = false
//                      }
//                    }
//                }
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)

            }

        }

    }

}

extension View {

    func toast(isShowing: Binding<Bool>, text: Text) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self },
              text: text)
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
            let address = info["street"]! as! String
            if (address.isEmpty == false){
                VenueAddress(address: address)
            }
            let phone = info["phone"]! as! String
            if (phone.isEmpty == false){
                VenuePhone(phone: phone)
            }
            let open_hour = info["open_hour"]! as! String
            if (open_hour.isEmpty == false){
                VenueOpenHour(openhour: open_hour)
            }
            let generalRule = info["generalRule"]! as! String
            if (generalRule.isEmpty == false){
                VenueGeneralRule(generalRule: generalRule)
            }
            let child_rule = info["childRule"]! as! String
            if(child_rule.isEmpty==false){
                VenueChildRule(childRule: child_rule)
            }
            Spacer()
            
            
//            let testG = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque consequat tincidunt metus, sed finibus lacus commodo vel. Curabitur eu mauris nec nisl scelerisque interdum. Suspendisse vel nibh non dui gravida commodo. Sed malesuada orci mi, id tincidunt odio fermentum id. Fusce viverra sem eget purus fringilla, ac fringilla lectus mattis. Sed consectetur bibendum mi, in commodo ligula consequat sit amet. Phasellus auctor, mauris ut vestibulum ullamcorper, lacus eros gravida dolor, sit amet tempor magna lorem non mi. Nulla facilisi."
            

            
//            let children = "General Rule: All participants must abide by the guidelines and regulations set forth by the organizing committee. Any violation of the rules may result in disqualification or other penalties. Participants are expected to show respect and sportsmanship towards fellow competitors, officials, and spectators. Use of offensive language, inappropriate behavior, or any form of cheating is strictly prohibited. All decisions made by the referees and organizers are final. Participants are responsible for their own safety and well-being during the event. Failure to comply with the rules may lead to immediate expulsion from the competition. Play fair, compete with integrity, and enjoy the event!"
            VenueMap(themap: info["loc"]! as! [String])
        }
    }
}



struct teamView: View {
    var theTeam: [[[String:Any]]]
    var correctName: [String]
    
    
    var body: some View {
        VStack(spacing: 10){
            if isNothing{
                VStack{
                    Spacer()
                    Text("No music related artist details to show").font(.system(size: 30, weight: .bold)).foregroundColor(.black)
                        .padding(.bottom)
                        .textCase(.none)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
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



struct FavouriteView: View {
    
    @State private var userDefaultsData: [String: [String: Any]] = getAllUserDefaults()
    func deleteFav(at offsets: IndexSet) {
        for index in offsets {
            var userDefaultsData2: [String: [String: Any]] = getAllUserDefaults()
            let key = Array(userDefaultsData2.keys)[index]
            userDefaultsData.removeValue(forKey: key)
            UserDefaults.standard.removeObject(forKey: "favourite list")
            UserDefaults.standard.set(userDefaultsData,forKey:"favourite list")
            userDefaultsData = getAllUserDefaults()
//            emptySet = (getAllUserDefaults().count == 0)
        }
    }
    
    var body: some View {
        NavigationView{
//                    HStack{
//                        Text("Favourites")
//                            .font(.system(size: 40, weight: .bold))
//                            .foregroundColor(.black)
//                            .padding(.leading)
//                            .textCase(.none)
//
//
//                    }
//            var userDefaultsData: [String: [String: Any]] = getAllUserDefaults()
            
            if(!userDefaultsData.isEmpty){
                Form{
                    
                    List {
                        
                        ForEach(Array(userDefaultsData), id: \.key) { key, value in
                            HStack{
                                Section{
                                    if let date = value["localDate"]! as? String {
                                        Text("\(date)").lineLimit(1).font(Font.system(size: 10))
                                    }
                                }
                                Section{
                                    if let event = value["event"]! as? String {
                                        Text(event).frame(width: 60)
                                            .font(Font.system(size: 10))
                                            .lineLimit(2)
                                            .truncationMode(.tail)
                                    }
                                }
                                Section{
                                    if let genre = value["genre"]! as? String {
                                        Text(genre).font(Font.system(size: 10))
                                    }
                                }
                                Section{
                                    if let venues = value["venue_name"]! as? String {
                                        Text(venues).font(Font.system(size: 10))
                                    }
                                }
                            }
                        }.onDelete(perform: deleteFav)
                    }.onAppear{
                        userDefaultsData = getAllUserDefaults()
                    }
                }.navigationBarTitle( Text("Favourite").font(.system(size: 40, weight: .bold))
                    .foregroundColor(.black))
            }else{
                
                    VStack{
                        HStack{
                            Text("Favourite").font(.system(size: 40, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                        }.padding(.leading)
                        Spacer()
                        Text("No favourite found").foregroundColor(.red)
                        Spacer()
                    }
                
            }
                }.onAppear{
                    userDefaultsData = getAllUserDefaults()
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

struct eventsView: View{
    var event_details: [String: Any]
         
    @State private var buttonS: Bool
    @State private var updateView: Bool = false
    @State private var toastMessage:String = "Added to Favourite"
    @State private var showToast:Bool = false
    func checkButtonState() -> Bool {
        var event = event_details["event"]! as! String
        return check_inFav(name: event)
    }
        
    func check_inFav(name:String)->Bool{
        if UserDefaults.standard.object(forKey: name) as? [String: Any] != nil {
                return true
        } else {
                return false
        }
    }
    
    func toggleButtonState() {
            buttonS.toggle()
            updateView.toggle()
    }

    
    init(event_details: [String: Any]) {
        _buttonS = State(initialValue: false)
        self.event_details = event_details
        _buttonS = State(initialValue: checkButtonState())
    }
    
    var body: some View{
       
        ScrollView{
            
            VStack{
                VStack(alignment: .leading){
                    let event = event_details["event"]! as! String
                    
                    ZStack{
                        
                        HStack{
                            Spacer()
                            
                            Text(event).font(.system(size: 25, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.bottom)
                                    .textCase(.none)
                                    .multilineTextAlignment(.center)
                            
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
                                if(buttonS){
                                    let userDefaults = UserDefaults.standard
                                    let dictionary = userDefaults.dictionaryRepresentation()
                                    var all_data = dictionary["favourite list"]! as! [String:[String:Any]]
                                    
                                    
                                    var name = event_details["event"]! as! String
                                    all_data.removeValue(forKey: name)
                                    UserDefaults.standard.removeObject(forKey: "favourite list")
                                    UserDefaults.standard.set(all_data,forKey:"favourite list")
                                    toggleButtonState()
                                    toastMessage = "Remove Favourite"
                                    showToast.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                      withAnimation {
                                          showToast.toggle()
                                      }
                                    }
                                }else{
                                    
                                    let userDefaults = UserDefaults.standard
                                    let dictionary = userDefaults.dictionaryRepresentation()
                                    var all_data = dictionary["favourite list"]! as! [String:[String:Any]]
                                    
                                    
                                    var name = event_details["event"]! as! String
                                    all_data[name] = event_details
                                    UserDefaults.standard.removeObject(forKey: "favourite list")
                                    UserDefaults.standard.set(all_data,forKey:"favourite list")
                                    toggleButtonState()
                                    toastMessage = "Added to Favourite"
                                    showToast.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                      withAnimation {
                                          showToast.toggle()
                                      }
                                    }
                                }
                            }){
                                if(buttonS){
                                    Rectangle()
                                        .foregroundColor(.red)
                                        .frame(width: 100, height: 50)
                                        .cornerRadius(10)
                                        .overlay(Text("Remove Favourite").foregroundColor(.white))
                                    
                                }else{
                                    Rectangle()
                                        .foregroundColor(.blue)
                                        .frame(width: 100, height: 50)
                                        .cornerRadius(10)
                                        .overlay(Text("save event").foregroundColor(.white))
                                }
                                
                            }.buttonStyle(BorderedButtonStyle())
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
                                }.padding(.vertical).frame(width: 200, height: 200)
                                Spacer()
                            }
                            Spacer()
                            
                        }
                        Spacer()
                        
                        
                    }
                   
                    
                    
                    
                    VStack{
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
                        }.padding(.vertical)
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
        }.toast(isShowing: $showToast, text: Text(toastMessage))
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
                let name = event_details["event"]! as! String
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

struct formView : View{
    
    @State private var loadingS = true
    @State private var theS:[String] = []
    @State private var choose = ""
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
    @State private var isSheetPresented = false
    @State private var previousKW = ""
    @State private var progressing = true
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
                                .disableAutocorrection(true)
                                .keyboardType(.default).onChange(of: kw, perform: { text in
                                    if !text.isEmpty{
                                        theS = autoGet(kw: text)
                                        isSheetPresented = !theS.isEmpty
                                        progressing = true
                                    }
                                })
                            
                        }.popover(isPresented: $isSheetPresented){
                            if(progressing){
                                VStack{
                                    ProgressView()
                                    
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                progressing = false
                                            }
                                        }
                                    Text("Please Wait")
                                }
                            }else{
                                Text("Suggestions")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.black)
                                    .textCase(.none)
                                Section{
                                    VStack{
                                        Spacer()
                                        Form{
                                            ForEach(0..<theS.count, id: \.self) { index in
                                                Text(theS[index]).onTapGesture{
                                                    kw = theS[index]
                                                    theS = []
                                                    isSheetPresented = false
                                                    progressing = true
                                                }}
                                            
                                        }
                                        Spacer()
                                    }
                                }
                                
                            }
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
                                        previousKW = ""
                                        isSheetPresented = false
                                        choose = ""
                                        loadingS = true
                                        theS = []
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



