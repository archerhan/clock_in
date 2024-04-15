import 'dart:async';

import 'package:clock_in/utils/logger_util.dart';
import 'package:clock_in/utils/toast_util.dart';
import 'package:in_app_purchase/in_app_purchase.dart';


class StoreManager {
  StoreManager._privateConstructor();
  static final StoreManager instance = StoreManager._privateConstructor();
  final List<String> _kProductIds = ["clock_in_premium"];
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  List<ProductDetails> _products = <ProductDetails>[];
  List<ProductDetails> get products => _products;
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;
  bool _purchasePending = false;
  bool get purchasePending => _purchasePending;
  bool _loading = true;
  bool get loading => _loading;

  // 监听购买更新(需要尽早调用此方法进行监听)
  void listenPurchaseUpdates() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      logger.e("listenPurchaseUpdates error: $error");
    });
    _inAppPurchase.restorePurchases();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            unawaited(_deliverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void _showPendingUI() {
    logger.d("showPendingUI");
  }

  Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
    //! IMPORTANT!! Always verify purchase details before delivering the product.
    logger.d("验证成功, 下发商品");
    // if (purchaseDetails.productID == _kConsumableId) {
    //   await ConsumableStore.save(purchaseDetails.purchaseID!);
    //   final List<String> consumables = await ConsumableStore.load();
    //   setState(() {
    //     _purchasePending = false;
    //     _consumables = consumables;
    //   });
    // } else {
    //   setState(() {
    //     _purchases.add(purchaseDetails);
    //     _purchasePending = false;
    //   });
    // }
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
    logger.e("handleInvalidPurchase: ${purchaseDetails.purchaseID}");
  }

  void _handleError(IAPError error) {
    logger.e("handleError: ${error.message}");
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    //! IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  Future<void> initStoreInfo() async {
    final isAvailable = await _inAppPurchase.isAvailable();
    _isAvailable = isAvailable;
    if (!_isAvailable) {
      showToast("内购不可用~");
      _products = [];
      _purchases = [];
      _purchasePending = false;
      _loading = false;
      return;
    }
    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      showToast("获取产品失败~");
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _purchasePending = false;
      _loading = false;
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      showToast("没有找到产品~");
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _purchasePending = false;
      _loading = false;
      return;
    }

    _products = productDetailResponse.productDetails;
    _loading = false;
    _purchasePending = false;
  }

  // 购买商品
  Future<void> purchaseProduct(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }
}
