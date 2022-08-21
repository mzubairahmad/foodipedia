//
//  FoodDetailView.swift
//  FoodiPedia
//
//  Created by Zubair Ahmad on 21/08/2022.
//

import SwiftUI

struct FoodDetailView: View {
    
    let foodModel : FoodModel?
    
    var body: some View {
        ZStack {
            Text(foodModel?.title ?? "")
                .font(.system(size: 24))
            // all other info can be show here as per design or requirement
        }
        Spacer()
    }
}
