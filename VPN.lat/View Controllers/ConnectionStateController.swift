//
//  MainViewController.swift
//  VPN.lat
//
//  Created by user173177 on 5/30/20.
//  Copyright © 2020 user173177. All rights reserved.
//

import UIKit
import NetworkExtension
import  GoogleMobileAds

struct ServerDetails{
    var Hostname:String!

    var Country:String!
    var CShort:String!
    
}

class ConnectionStateController: UIViewController , URLSessionDelegate, URLSessionDataDelegate{

    var providerManager: NETunnelProviderManager!
    var subServer: String!
    var IP:String!
    var Configdata:String!

    
    @IBOutlet weak var SubServerName: UILabel!
    @IBOutlet weak var Status: UILabel!
    
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var DownloadSpeed: UILabel!
    @IBOutlet weak var UploadSpeed: UILabel!
    @IBOutlet weak var AdMobView: BannerView!
    
    @IBAction func VPNConnect(_ sender: UIButton) {
        if btnConnect.titleLabel?.text == "Connect" {
            sender.setTitle("Connecting.. ", for: .normal)
            self.loadProviderManager {
                       self.configureVPN(serverAddress: self.IP )
                   }
        }
        if btnConnect.titleLabel?.text == "Turn Off" {
            sender.setTitle("Connect ", for: .normal)
            self.providerManager.connection.stopVPNTunnel()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "VPN.Lat"
        SubServerName.text = subServer
        // Do any additional setup after loading the view.
    

        //self.Status.text = "Connected"
        var bannerView: GADBannerView!
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

        addBannerViewToView(bannerView)


        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
       // bannerView.delegate = self
    }
    
    func loadProviderManager(completion:@escaping () -> Void) {
       NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
           if error == nil {
               self.providerManager = managers?.first ?? NETunnelProviderManager()
               completion()
           }
       }
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
    
    func configureVPN(serverAddress: String) {
      guard let configData = self.readFile(path: "test.ovpn") else { return }
      self.providerManager?.loadFromPreferences { error in
         if error == nil {
            let tunnelProtocol = NETunnelProviderProtocol()
            //tunnelProtocol.username = username
            tunnelProtocol.serverAddress = serverAddress
            tunnelProtocol.providerBundleIdentifier = "com.VPNlat.VPN-lat"
            // bundle id of the network extension target
            //tunnelProtocol.providerConfiguration = ["ovpn": configData, "username": username, "password": password]
            tunnelProtocol.providerConfiguration = ["ovpn": configData]
            tunnelProtocol.disconnectOnSleep = false
            
            self.providerManager.protocolConfiguration = tunnelProtocol
            
            self.providerManager.localizedDescription = "Test-OpenVPN" // the title of the VPN profile which will appear on Settings
            self.providerManager.isEnabled = true
            self.providerManager.saveToPreferences(completionHandler: { (error) in
                  if error == nil  {
                     self.providerManager.loadFromPreferences(completionHandler: { (error) in
                         do {
                           try self.providerManager.connection.startVPNTunnel() // starts the VPN tunnel.
                            self.Status.text = "Connected"
                            self.btnConnect.setTitle("Turn Off", for: .normal)
                           Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                            // Do what you need to do repeatedly
                                self.checkForSpeedTest()
                            }
                         } catch let error {
                             print(error.localizedDescription)
                            self.Status.text = "NA"
                            self.btnConnect.setTitle("Connect", for: .normal)
                         }
                     })
                  }
            })
          }
       }
    }
 
    
    func readFile(path: String) -> String? {
        return Configdata
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
     func checkForSpeedTest() {

        testDownloadSpeedWithTimout(timeout: 5.0) { (speed, error) in
            print("Download Speed:", speed ?? "NA")
            DispatchQueue.main.async {
                self.DownloadSpeed.text = String(format:"%.3f",speed!) + "/Mbps"
                self.UploadSpeed.text = String(format:"%.3f",speed! / 10) + "/Mbps"
            }
           
            print("Speed Test Error:", error ?? "NA")
        }
    }
    
    typealias speedTestCompletionHandler = (_ megabytesPerSecond: Double? , _ error: Error?) -> Void

    var speedTestCompletionBlock : speedTestCompletionHandler?

    var startTime: CFAbsoluteTime!
    var stopTime: CFAbsoluteTime!
    var bytesReceived: Int!

    func testDownloadSpeedWithTimout(timeout: TimeInterval, withCompletionBlock: @escaping speedTestCompletionHandler) {

        guard let url = URL(string: "https://titankustoms.com") else { return }

        startTime = CFAbsoluteTimeGetCurrent()
        stopTime = startTime
        bytesReceived = 0

        speedTestCompletionBlock = withCompletionBlock

        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForResource = timeout
        let session = URLSession.init(configuration: configuration, delegate: self, delegateQueue: nil)
        session.dataTask(with: url).resume()

    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        bytesReceived! += data.count
        stopTime = CFAbsoluteTimeGetCurrent()
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

        let elapsed = stopTime - startTime

        if let aTempError = error as NSError?, aTempError.domain != NSURLErrorDomain && aTempError.code != NSURLErrorTimedOut && elapsed == 0  {
            speedTestCompletionBlock?(nil, error)
            return
        }

        let speed = elapsed != 0 ? Double(bytesReceived) / elapsed / 1024.0 / 1024.0 : -1
        speedTestCompletionBlock?(speed, nil)

    }
}
