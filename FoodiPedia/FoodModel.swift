//
//  FoodModel.swift
//  FoodiPedia
//
//  Created by Zubair Ahmad on 21/08/2022.
//

import Foundation

struct FoodModel: Codable {
    let title : String
    let pcstext: String
    let calories: Float
    let carbs: Float
    let fat: Float
    let saturatedfat: Float
    let unsaturatedfat: Float
    let fiber: Float
    let cholesterol: Float
    let sugar: Float
    let sodium: Float
    let potassium: Float
    let gramsperserving: Float
}

struct FoodAPIModel : Codable {
    let response : FoodModel
}
