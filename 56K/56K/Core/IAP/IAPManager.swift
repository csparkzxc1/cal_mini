import StoreKit
import Observation

@Observable
final class IAPManager {
    static let shared = IAPManager()

    private static let productID = "com.56k.calendar.premium"

    var isPurchased: Bool = false
    var product: Product?
    var purchaseError: String?
    var isLoading: Bool = false

    private var updateTask: Task<Void, Never>?

    private init() {
        updateTask = Task { [weak self] in
            guard let self else { return }
            await self.checkPurchased()
            await self.listenForTransactions()
        }
    }

    deinit {
        updateTask?.cancel()
    }

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.productID])
            product = products.first
        } catch {
            purchaseError = Copy.IAP.purchaseError
        }
    }

    func purchase() async {
        guard let product else { return }
        isLoading = true
        purchaseError = nil

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified = verification {
                    isPurchased = true
                    await verification.payloadValue.finish()
                }
            case .pending:
                break
            case .userCancelled:
                break
            @unknown default:
                break
            }
        } catch {
            purchaseError = Copy.IAP.purchaseError
        }

        isLoading = false
    }

    func restore() async {
        isLoading = true
        try? await AppStore.sync()
        await checkPurchased()
        isLoading = false
    }

    private func checkPurchased() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.productID {
                isPurchased = true
                return
            }
        }
    }

    private func listenForTransactions() async {
        for await result in Transaction.updates {
            if case .verified(let transaction) = result,
               transaction.productID == Self.productID {
                isPurchased = true
                await transaction.finish()
            }
        }
    }
}
