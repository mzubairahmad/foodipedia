//
//  ContentView.swift
//  FoodiPedia
//
//  Created by Zubair Ahmad on 21/08/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var showDetailView = false
    @StateObject var vm = FoodViewModel()
    
    var light: UInt32 = 0xE7A260
    var dark: UInt32 = 0xDC6463
    
    var body: some View {
        NavigationView {
            VStack {
                if vm.isRefreshing {
                    ProgressView()
                } else {
                    Button(action: {
                        Task {
                            await getFoodItemData()
                        }
                    }, label: {
                        
                        Text(vm.foodAPIResponse.response.title)
                            .underline()
                            .font(.system(size: 20))
                            .padding(.all)
                            .accentColor(.white)
                            .frame(width: 200, height: 200, alignment: .center)
                            .background(LinearGradient(gradient: Gradient(colors: [.init(light), .init(dark)]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(100)
                    })
                    Spacer()
                        .frame(height: 30)
                    if vm.foodAPIResponse.response.title.count > 0 {
                        VStack {
                            Text("\(String(format: "%.0f", vm.foodAPIResponse.response.calories))")
                                .font(.system(size: 40))
                            Text("Calories per serving")
                                .font(.system(size: 20))
                        }
                        Spacer()
                            .frame(height: 30)
                        HStack{
                            Text("Carbs\n \(String(format: "%.2f", vm.foodAPIResponse.response.carbs))")
                            Spacer()
                            .frame(width: 50, height: 10, alignment: .center)
                            Text("Fiber\n \(String(format: "%.2f", vm.foodAPIResponse.response.fiber))")
                            Spacer()
                                .frame(width: 50, height: 10, alignment: .center)
                            Text("Fat\n \(String(format: "%.2f", vm.foodAPIResponse.response.fat))")
                        }
                        Spacer()
                            .frame(height: 50)
                        
                        Button("") {
                            showDetailView.toggle()
                        }
                        NavigationLink(isActive: $showDetailView) {
                            FoodDetailView(foodModel: vm.foodAPIResponse.response)
                        } label: {
                            Text("MORE INFO")
                                .font(.system(size: 17))
                                .padding(.all)
                                .accentColor(.white)
                                .frame(width: 250, height: 70, alignment: .center)
                                .background(.black)
                                .cornerRadius(125)
                        }
                    }
                }
            }
        }
        .navigationTitle("FoodiPedia")
    }
    
    func getFoodItemData () async {
        await vm.fetchFoodItemData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
