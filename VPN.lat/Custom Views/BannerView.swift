//
//  BannerView.swift
//  VPN.lat
//
//  Created by user173177 on 6/8/20.
//  Copyright © 2020 user173177. All rights reserved.
//

import Foundation
import  GoogleMobileAds

class  BannerView : GADBannerView, GADBannerViewDelegate {
    override func awakeFromNib() {
       
        var bannerView: GADBannerView!
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        //addBannerViewToView(bannerView)

        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
}
