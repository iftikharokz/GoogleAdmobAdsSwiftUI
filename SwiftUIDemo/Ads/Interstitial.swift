//
//  Adds.swift
//  ColorsName
//
//  Created by Theappmedia on 2/18/22.
//

import GoogleMobileAds
import SwiftUI

class InterstitialAd: UIViewController,GADFullScreenContentDelegate,ObservableObject{
    @Published var adIsVisible = false
     var interstitial: GADInterstitialAd?
     var isLoading: Bool = false
     var isLoaded: Bool = false
    
func adsLoad(){
    if isLoaded || isLoading {
        return
    }
    isLoading = true
    let request = GADRequest()
    GADInterstitialAd.load(withAdUnitID:Constants.interstitialAdID,request: request,
        completionHandler: { [self] ad, error in
        isLoading = false
            if error != nil {
             return
             }
             isLoaded = true
             interstitial = ad
             interstitial?.fullScreenContentDelegate = self
             print("ad loaded successfully")
            }
        )
}

 func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
   print("Ad did fail to present full screen content.",error)
     adIsVisible = false
 }

    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
   print("Ad did present full screen content.")
 }

 func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
   print("Ad did dismiss full screen content.")
     isLoaded = false
     adIsVisible = false
 }
 func adsShow() {
    if interstitial != nil {
        DispatchQueue.main.async {
            self.adIsVisible = true
            self.interstitial?.present(fromRootViewController: UIApplication.shared.windows.first?.rootViewController ?? self)
        }
      } else {
          adIsVisible = false
        print("Ad wasn't ready")
      }
   }
}
