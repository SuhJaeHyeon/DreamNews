import Foundation
import StoreKit

class InAppPurchaseManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = InAppPurchaseManager()
    
    @Published var products: [SKProduct] = []
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func fetchProducts() {
        let productIDs = Set(["com.example.8novels", "com.example.16novels", "com.example.32novels"])
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
    }
    
    func purchaseProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // 구매 완료
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                // 구매 실패
                if let error = transaction.error as NSError?, error.code != SKError.paymentCancelled.rawValue {
                    print("Transaction Error: \(error.localizedDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                // 복원
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}
