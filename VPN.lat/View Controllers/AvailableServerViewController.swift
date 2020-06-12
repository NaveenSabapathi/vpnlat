//
//  SecondViewController.swift
//  VPN.lat
//
//  Created by user173177 on 5/30/20.
//  Copyright © 2020 user173177. All rights reserved.
//

import UIKit
import  GoogleMobileAds

class AvailableServerViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    
    var selectedMainServer: String = ""

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subServerDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubServerCell", for: indexPath) as! SubServerTableViewCell
        cell.SubServerName?.text = subServerDetails[indexPath.row].Hostname
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ConnectionScene") as!
        ConnectionStateController
        newViewController.subServer = subServerDetails[indexPath.row].Hostname
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
}
    
    var subServerDetails = [CountryList]()
    
    @IBOutlet weak var AdMobView: BannerView!
    @IBOutlet weak var CountryCircularImage: UIImageView!
    
    @IBOutlet weak var txtCountryName: UILabel!
    
    @IBOutlet weak var SubServerTableView: UITableView!
    override func viewDidLoad() {
        MakeImageRounded()
        SubServerTableView?.delegate = self
        SubServerTableView?.dataSource = self
        //ConnectionScene
        getCountryList()
        
               var bannerView: GADBannerView!
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)


        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        //bannerView.delegate = self
        
        txtCountryName.text = selectedMainServer
        
    }
    
    func MakeImageRounded(){
        CountryCircularImage?.layer.cornerRadius = CountryCircularImage.frame.size.width/2
        CountryCircularImage?.clipsToBounds = true
        CountryCircularImage?.layer.borderColor = UIColor.white.cgColor
        CountryCircularImage?.layer.borderWidth = 3.0
    }
    
    func getCountryList() {
        self.CountryCircularImage.image = UIImage(named:self.subServerDetails[0].CShort.lowercased())
        self.SubServerTableView.reloadData()
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
    bannerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bannerView)
    view.addConstraints(
      [NSLayoutConstraint(item: bannerView,
                          attribute: .bottom,
                          relatedBy: .equal,
                          toItem: bottomLayoutGuide,
                          attribute: .top,
                          multiplier: 1,
                          constant: 0),
       NSLayoutConstraint(item: bannerView,
                          attribute: .centerX,
                          relatedBy: .equal,
                          toItem: view,
                          attribute: .centerX,
                          multiplier: 1,
                          constant: 0)
      ])
//    func purchase(purchase: RegisteredPurchase){
//    NetworkActivityIndicatorManager.NetworkOperationStarted()
//    SwiftyStoreKit.purchaseProduct(bundleID + "." + purchase.rawValue, completion:{
//        result in
//        NetworkActivityIndicatorManager.networkOperationFinished()
//        if case .success(let product) = result {
//            if product.needsFinishTransaction{
//                SwiftyStoreKit.finishTransaction(product.transaction)
//                RemoveAdsViewController.adRemovalPurchased = true
//                print("Turning Banner off")
//            }
//            self.showAlert(alert: self.alertForPurchaseResult(result: result))
//        }
    }
}
