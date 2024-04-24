// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:clock_in/constants/app_strings.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:clock_in/utils/sp_util.dart';
import 'package:clock_in/utils/toast_util.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class StoreManager {
  StoreManager._privateConstructor() {
    initInfo();
  }
  static final StoreManager instance = StoreManager._privateConstructor();
  final List<String> _kProductIds = [AppStrings.productKey];
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  List<ProductDetails> _products = <ProductDetails>[];
  List<ProductDetails> get products => _products;

  // 是否已购买
  bool _hasPurchased = false;
  bool get hasPurchased => _hasPurchased;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;
  bool _purchasePending = false;
  bool get purchasePending => _purchasePending;
  bool _loading = true;
  bool get loading => _loading;

  void initInfo() async {
    _hasPurchased = await SPUtil.getBool(AppStrings.hasPurchasedKey);
  }

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
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    if (purchaseDetailsList.isEmpty) {
      showToast("没有购买记录");
      dismissLoading();
      return;
    }
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      logger.d("购买状态: ${purchaseDetails.status}");
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showLoading();
      } else {
        dismissLoading();
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = _verifyPurchase(purchaseDetails);
          if (valid) {
            _deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  bool _verifyPurchase(PurchaseDetails purchaseDetails) {
    return purchaseDetails.productID == AppStrings.productKey;
  }

  void _deliverProduct(PurchaseDetails purchaseDetails) {
    if (_hasPurchased == false) {
      showToast("会员资格已生效");
    }
    logger.d("验证成功, 下发商品");
    _hasPurchased = true;
    SPUtil.save(AppStrings.hasPurchasedKey, true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    showToast("购买验证失败");
    logger.e("handleInvalidPurchase: ${purchaseDetails.purchaseID}");
  }

  void _handleError(IAPError error) {
    showToast("购买中发生错误:${error.message}");
    logger.e("handleError: ${error.message}");
  }

  Future<void> initStoreInfo() async {
    final isAvailable = await _inAppPurchase.isAvailable();
    _isAvailable = isAvailable;
    if (!_isAvailable) {
      showToast("内购不可用");
      _products = [];
      _purchasePending = false;
      _loading = false;
      return;
    }
    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      showToast("获取产品失败");
      _products = productDetailResponse.productDetails;
      _purchasePending = false;
      _loading = false;
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      showToast("没有找到产品");
      _products = productDetailResponse.productDetails;
      _purchasePending = false;
      _loading = false;
      return;
    }
    logger.d(
        "获取到产品: ${productDetailResponse.productDetails.map((e) => e.title).toList()}");
    _products = productDetailResponse.productDetails;
    _loading = false;
    _purchasePending = false;
  }

  // 购买商品
  Future<void> purchaseProduct(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  // 恢复购买
  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }
}
