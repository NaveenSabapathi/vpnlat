//
//  VPNListViewController.swift
//  VPN.lat
//
//  Created by user173177 on 5/30/20.
//  Copyright © 2020 user173177. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMobileAds

struct CountryList{
    var Hostname:String!
    var IP:String!
    var Country:String!
    var CShort:String!
    var Configdata:String!
}

class VPNListViewController: UITableViewController, GADBannerViewDelegate {

    
    var countryList = [CountryList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bannerView: GADBannerView!
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)


        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self

        
        title = "VPN.Lat"
        
         let Url = String(format: "https://www.mercadologos.mx/ios/postman/getdata.php")
                guard let serviceUrl = URL(string: Url) else { return }
                var request = URLRequest(url: serviceUrl)
                request.httpMethod = "GET"
                request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    if let response = response {
                        print("dddd",response)
                    }
                    if let data = data {
                        do {
                                       //converting resonse to NSDictionary
                                    if let dataJSON =  try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary{
                                       
                                       //getting the JSON array data from the response
                                    if let data = dataJSON["datas"] as? [NSDictionary]{
                                       
                                       //looping through all the json objects in the array data
                                       for i in 0 ..< data.count{
                                           
                                           //getting the data at each index
                                        if let Hostname:String = data[i]["Hostname"] as? String,
                                           let IP:String = data[i]["IP"] as? String,
                                           let Country:String = data[i]["Country"] as? String,
                                           let Cshort:String = data[i]["Cshort"] as? String,
                                            let Configdata:String = data[i]["Configdata"] as? String{
                                            
                                            self.countryList.append(CountryList(Hostname: Hostname, IP: IP, Country: Country, CShort: Cshort, Configdata: Configdata))
                                            
                                            DispatchQueue.main.async {
                                                self.tableView.reloadData()
                                            }}}}}}catch{
                                    print("catch error")
                        }
                    }
                    }.resume()

    }
    
        override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! VPNCountryTableViewCell

        let row = countryList[indexPath.row]
        
        cell.countryName?.text = row.Country
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.CircularImageView.image = GetCountryImage(name:row.CShort)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "availableServer") as! AvailableServerViewController

        newViewController.selectedMainServer = countryList[indexPath.row].Country
        
        newViewController.subServerDetails = countryList.filter { $0.Country == countryList[indexPath.row].Country }
        
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    
    func GetCountryImage(name :String) ->  UIImage!{
     //UIImage(named: "singapore")
        do {
            return UIImage(named: name.lowercased())
        }
        }
    
   override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
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
   }
        
    }
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



