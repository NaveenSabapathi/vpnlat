//
//  SubServers.swift
//  VPN.lat
//
//  Created by user173177 on 5/31/20.
//  Copyright © 2020 user173177. All rights reserved.
//

import Foundation

class SubServerDetails{
var subservername : String
       var IP:String!
       var Country:String!
       var CShort:String!
       var Configdata:String!
    init(name:String,IP:String,country:String,cshort:String,config:String    ) {
        self.subservername = name
        self.IP = IP
        self.Country = country
        self.Configdata = config
        self.CShort = cshort
    }
}
