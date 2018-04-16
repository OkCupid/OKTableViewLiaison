//
//  Post.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 3/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

struct Post {
    let user: String
    let userAvatar: UIImage
    let content: UIImage
    let numberOfLikes: Int
    let caption: String
    let numberOfComments: Int
    let timePosted: Int
    
    static func randomPosts() -> [Post] {
         let post1 = Post(user: "dylan",
                          userAvatar: UIImage(named: "dylan")!,
                          content: UIImage(named: "red-panda")!,
                          numberOfLikes: 64,
                          caption: "The red panda (Ailurus fulgens), also called the lesser panda, the red bear-cat, and the red cat-bear, is a mammal native to the eastern Himalayas and southwestern China.",
                          numberOfComments: 25,
                          timePosted: 1644)
        
        let post2 = Post(user: "jordan",
                         userAvatar: UIImage(named: "jordan")!,
                         content: UIImage(named: "otter")!,
                         numberOfLikes: 223,
                         caption: "The sea otter (Enhydra lutris) is a marine mammal native to the coasts of the northern and eastern North Pacific Ocean.",
                         numberOfComments: 112,
                         timePosted: 23995)
        
        let post3 = Post(user: "julian",
                         userAvatar: UIImage(named: "julian")!,
                         content: UIImage(named: "bear")!,
                         numberOfLikes: 824,
                         caption: "The grizzly bear (Ursus arctos ssp.) is a large subspecies of brown bear inhabiting North America. Scientists generally do not use the name grizzly bear but call it the North American brown bear.",
                         numberOfComments: 438,
                         timePosted: 141355)
        
        return [post1, post2, post3]
    }
    
    static func paginatedPosts() -> [Post] {
        
        let post1 = Post(user: "dylan",
                         userAvatar: UIImage(named: "dylan")!,
                         content: UIImage(named: "fox")!,
                         numberOfLikes: 1024,
                         caption: "The red fox (Vulpes vulpes) is the largest of the true foxes and one of the most widely distributed members of the order Carnivora, being present across the entire Northern Hemisphere from the Arctic Circle to North Africa, North America and Eurasia.",
                         numberOfComments: 622,
                         timePosted: 441355)
        
        let post2 = Post(user: "dylan",
                         userAvatar: UIImage(named: "dylan")!,
                         content: UIImage(named: "seal")!,
                         numberOfLikes: 2121,
                         caption: "The harp seal or saddleback seal (Pagophilus groenlandicus) is a species of earless seal native to the northernmost Atlantic Ocean and parts of the Arctic Ocean.",
                         numberOfComments: 888,
                         timePosted: 641355)
        
        let post3 = Post(user: "dylan",
                         userAvatar: UIImage(named: "dylan")!,
                         content: UIImage(named: "giraffe")!,
                         numberOfLikes: 5002,
                         caption: "The giraffe (Giraffa) is a genus of African even-toed ungulate mammals, the tallest living terrestrial animals and the largest ruminants.",
                         numberOfComments: 1048,
                         timePosted: 1241355)

        return [post1, post2, post3]
    }
    
}
