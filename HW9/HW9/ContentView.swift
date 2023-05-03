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
//    @State var getteam = "Big Bang"
    
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
            
            
        }.background(.white)
    }
    
    
    
}

//func formView(kw:Binding<String>,distance:Binding<Int>,chooseOption:Binding<String>,position:Binding<String>,autoValue:Binding<Bool>,isSubmit:Binding<Bool>,isClean:Binding<Bool>)->some View{




