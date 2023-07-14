//
//  AllAdsView.swift
//  SwiftUIDemo
//
//  Created by mac on 13/07/2023.
//

import SwiftUI
import GoogleMobileAds

struct AllAdsView: View {
    @StateObject private var nativeViewModel = NativeAdViewModel()
    @StateObject private var nativeViewModelSmall = NativeAdViewModelSmall()
    let interstitial = InterstitialAd()
    
    //MARK: Rewarded Ad Swift Var's
    
    @State  var coins: Int = 0
    var rewardAd: RewardedAd
           
       init(){
           self.rewardAd = RewardedAd()
       }
    
    var body: some View {
        VStack{
            Text("Welcome to Ads World!")
            Text("Reward Amount is \(coins)")
            
            BannerView()
            
            BannerVC()
                .frame(width: UIScreen.main.bounds.width, height: 60)
            if nativeViewModel.nativeAd != nil{
                NativeAdView(nativeViewModel: nativeViewModel)
                    .frame(height: 170)
            }
            if nativeViewModelSmall.nativeAd != nil{
                NativeAdViewSmall(nativeViewModelSmall: nativeViewModelSmall)
                    .frame(height: 90)
            }
            Button {
                interstitial.adsLoad()
            } label: {
                Text("Load Interstitial")
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()
            Button {
                interstitial.adsShow()
            } label: {
                Text("Show Interstitial")
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            HStack{
                Button {
                    rewardAd.load()
                } label: {
                    Text("Load Rewarded")
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()
                Button {
                    self.rewardAd.showAd(rewardFunction: {
                                  // TODO: give the user a reward for watching
                        coins += 1
                                })
                } label: {
                    Text("Show Rewarded")
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .foregroundColor(.black)
        .onAppear {
          refreshAd()
        }
    }
    private func refreshAd() {
      nativeViewModel.refreshAd()
        nativeViewModelSmall.refreshAd()
    }
}

struct AllAdsView_Previews: PreviewProvider {
    static var previews: some View {
        AllAdsView()
    }
}

