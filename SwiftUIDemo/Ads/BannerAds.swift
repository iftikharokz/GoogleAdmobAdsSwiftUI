//
//  BannerAds.swift
//  ColorsName
//
//  Created by Theappmedia on 2/18/22.
//

import SwiftUI
import GoogleMobileAds
import UIKit


struct BannerVC: UIViewControllerRepresentable  {
    func makeUIViewController(context: Context) -> UIViewController {
        let adSize = GADAdSizeFromCGSize(CGSize(width: UIScreen.main.bounds.width, height: 50))
        

        let view = GADBannerView(adSize: adSize)

        let viewController = UIViewController()
        view.adUnitID = Constants.bannerAdID
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: adSize.size)
        view.load(GADRequest())
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}


struct AdView : UIViewRepresentable{
    @Binding var AdLoaded : Bool
    func makeCoordinator() -> Coordinator{
        Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<AdView>) -> GADBannerView{
        let request = GADRequest()
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let adSize = GADAdSizeFromCGSize(CGSize(width: UIScreen.main.bounds.width, height: 50))
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        banner.adUnitID = Constants.bannerAdID
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(request)
        banner.delegate = context.coordinator
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: UIViewRepresentableContext<AdView>){}

    class Coordinator: NSObject, GADBannerViewDelegate{
        var parent: AdView

        init(_ parent: AdView)
        {
            self.parent = parent
        }
         
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            parent.AdLoaded = true
            
            print("Ad View Did Receive Ad For ID: ",parent.$AdLoaded)
        }
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            parent.AdLoaded = false
            print("Ad View Failed To Receive Ad For ID:",error)
        }
    }
}
