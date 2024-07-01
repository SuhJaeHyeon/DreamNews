//
//  PurchaseView.swift
//  DreamMegazin
//
//  Created by martin on 6/21/24.
//

import SwiftUI
import StoreKit

struct PurchaseView: View {
    @Binding var isPresented: Bool
    @State var image: UIImage?
    @ObservedObject var inAppPurchaseManager = InAppPurchaseManager.shared
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                Text("소설 구매")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                ForEach(inAppPurchaseManager.products, id: \.productIdentifier) { product in
                    PurchaseCardView(product: product)
                }
                
                NavigationLink(destination: SettingDreamView(isPresented: $isPresented)) {
                    Text("16 Story")
                }
                .padding()
                
                Button(action: {
                    Task {
                        let result = await StoryManager.shared.generateImage(prompt: "해가 그러져있는 이미지를 보여줘")
                        self.image = result
                    }
                }) {
                    Text("make Image")
                }
                .padding()
                
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                }
                Spacer()
            }
            .padding()
            .onAppear {
                inAppPurchaseManager.fetchProducts()
            }
        }
        .navigationBarHidden(true)
    }
}

struct PurchaseCardView: View {
    var product: SKProduct
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(product.localizedTitle)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
            
            Text("\(product.priceLocale.currencySymbol ?? "")\(product.price)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.bottom, 5)
            
            Text(product.localizedDescription)
                .font(.body)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
            
            Button(action: {
                InAppPurchaseManager.shared.purchaseProduct(product)
            }) {
                Text("구매하기")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 10)
        .padding(.horizontal)
    }
}
