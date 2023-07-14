//
//  NativeSmall .swift
//  SwiftUIDemo
//
//  Created by mac on 14/07/2023.
//

import SwiftUI
import GoogleMobileAds

class NativeAdViewModelSmall: NSObject, ObservableObject, GADNativeAdLoaderDelegate {
  @Published var nativeAd: GADNativeAd?
   var adLoader: GADAdLoader!

  func refreshAd() {
    adLoader = GADAdLoader(
      adUnitID: Constants.nativeID,
      rootViewController: nil,
      adTypes: [.native], options: nil)
    adLoader.delegate = self
    adLoader.load(GADRequest())
  }

  func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
    self.nativeAd = nativeAd
    nativeAd.delegate = self
  }

  func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
    print("\(adLoader) failed with error: \(error.localizedDescription)")
  }
}

// MARK: - GADNativeAdDelegate implementation
extension NativeAdViewModelSmall: GADNativeAdDelegate {
  func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }
}

struct NativeAdViewSmall: UIViewRepresentable {
  typealias UIViewType = GADNativeAdView

  @ObservedObject var nativeViewModelSmall: NativeAdViewModelSmall

  func makeUIView(context: Context) -> GADNativeAdView {
    let nativeAd = Bundle.main.loadNibNamed(
        "NativeAdViewSmall",
        owner: nil,
        options: nil)?.first as! GADNativeAdView
      return nativeAd
  }
    func updateUIView(_ nativeAdView: GADNativeAdView, context: Context) {
        guard let nativeAd = nativeViewModelSmall.nativeAd else { return }

        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline

        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

        let bodyLabel = (nativeAdView.bodyView as? UILabel)
        bodyLabel?.text = nativeAd.body

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image

        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)

        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store

        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price

        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser

        if let callToActionButton = nativeAdView.callToActionView as? UIButton {
            callToActionButton.setTitle(nativeAd.callToAction, for: .normal)

            // Set background color
            callToActionButton.backgroundColor = UIColor.blue

            // Set horizontal padding
            callToActionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 8) // Adjust the values as needed

            // Set round corner
            callToActionButton.layer.cornerRadius = 8
            callToActionButton.clipsToBounds = true
        }

        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false

        // Associate the native ad view with the native ad object. This is required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = nativeAd
    }

 func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
    guard let rating = starRating?.doubleValue else {
      return nil
    }
    if rating >= 5 {
      return UIImage(named: "stars_5")
    } else if rating >= 4.5 {
      return UIImage(named: "stars_4_5")
    } else if rating >= 4 {
      return UIImage(named: "stars_4")
    } else if rating >= 3.5 {
      return UIImage(named: "stars_3_5")
    } else {
      return nil
    }
  }
}
