//
//  Information.swift
//  Project_001
//
//  Created by Yifeng Guo on 6/27/19.
//  Copyright © 2019 Yifeng Guo. All rights reserved.
//

import Foundation
import UIKit

class Information {
    var nameofChat:String = ""
    var idofChat: String = ""
    var isGroupChat : Bool = false
}
var information = Information()

class SearchResult {
    var nameofSearchResult: [String] = []
    var idofSearchResult: [String] = []
}
var searchResult = SearchResult()

class SearchInformation {
    var nameofChat:String = ""
    var idofChat: String = ""
}
var searchInformation = SearchInformation()

class FriendRequestInformation{
    var name: [String] = []
    var id: [String] = []
}
var friendRequestInformation = FriendRequestInformation()

class FriendSelectedInformation{
    var name: String = ""
    var id: String = ""
}
var friendSelectedInformation = FriendSelectedInformation()

var listOfFriendsWithoutGroup : [String] = []
var listOfIdWithoutGroup: [String] = []
var listOfFriends: [String] = []
var listOfId: [String] = []
var isGroupChat :[Bool] = []
var bufferChat = [String: [String]]()
var bufferGroupChat = [String: Int]()
let cacheItem = NSCache<NSString, UIImage>()
var cacheMessage = [String : [[String]]]()
var cacheBlog = [String : [String]]()
var cacheAudio = [String: URL]()
