//
//  ContentView.swift
//  FoodiPedia
//
//  Created by Zubair Ahmad on 21/08/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm = FoodViewModel()

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
                                      Circle()
                                          .frame(width: 200, height: 200)
                                          .foregroundColor(.gray)
                                  })
                    if vm.foodAPIResponse.response.title.count > 0 {
                        Text("\(vm.foodAPIResponse.response.title)")
                        Text("Carbs \(vm.foodAPIResponse.response.carbs)")
                        Text("Fiber \(vm.foodAPIResponse.response.fiber)")
                        Text("Fat \(vm.foodAPIResponse.response.fat)")
                    }
                }
            }
            .navigationTitle("FoodiPedia")
        }
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
