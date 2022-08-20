//
//  FoodViewModel.swift
//  FoodiPedia
//
//  Created by Zubair Ahmad on 21/08/2022.
//

import Foundation
import Combine

final class FoodViewModel: ObservableObject {
    
    @Published var hasError = false
    @Published var error: FoodError?
    
    @Published var foodAPIResponse: FoodAPIModel = .init(response: .init(title: "", pcstext: "", calories: 0.0, carbs: 0.0, fat: 0.0, saturatedfat: 0.0, unsaturatedfat: 0.0, fiber: 0.0, cholesterol: 0.0, sugar: 0.0, sodium: 0.0, potassium: 0.0, gramsperserving: 0.0))
    
    @Published private(set) var isRefreshing = false
    
    private var bag = Set<AnyCancellable>()
    
    func getRandomFoodID () -> Int {
        return Int.random(in: 1...200)
    }
    
    func fetchFoodItemData() async {
        
        let urlString = "https://api.lifesum.com/v2/foodipedia/codetest?foodid=" + "\(getRandomFoodID())"
        if let url = URL(string: urlString) {
            
            isRefreshing = true
            hasError = false
            
            URLSession.shared.dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap({ res in
                    
                    guard let response = res.response as? HTTPURLResponse,
                          response.statusCode >= 200 && response.statusCode <= 299 else {
                        throw FoodError.invalidStatusCode
                    }
                    
                    let decoder = JSONDecoder()
                    guard let foodAPIResponse = try? decoder.decode(FoodAPIModel.self, from: res.data) else {
                        throw FoodError.failedToDecode
                    }
                    
                    return foodAPIResponse
                })
                .sink { [weak self] res in
                    
                    defer { self?.isRefreshing = false }
                    
                    switch res {
                    case .failure(let error):
                        self?.hasError = true
                        self?.error = FoodError.custom(error: error)
                    default: break
                    }
                } receiveValue: { [weak self] foodAPIResponse in
                    self?.foodAPIResponse = foodAPIResponse
                }
                .store(in: &bag)
        }
    }
}


extension FoodViewModel {
    enum FoodError: LocalizedError {
        case custom(error: Error)
        case failedToDecode
        case invalidStatusCode
        
        var errorDescription: String? {
            switch self {
            case .failedToDecode:
                return "Failed to decode response"
            case .custom(let error):
                return error.localizedDescription
            case .invalidStatusCode:
                return "Request doesn't fall in the valid status code"
            }
        }
    }
}
