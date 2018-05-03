//
//  Post.swift
//  TableViewLiaison_Example
//
//  Created by Dylan Shine on 3/30/18.
//  Copyright © 2018 OkCupid. All rights reserved.
//

import UIKit

struct Post {
    let user: User
    let content: UIImage
    let numberOfLikes: Int
    let caption: String
    let numberOfComments: Int
    let timePosted: Int
    
    static func randomPosts() -> [Post] {
         let post1 = Post(user: .dylan,
                          content: #imageLiteral(resourceName: "bear"),
                          numberOfLikes: 64,
                          caption: "Bears are carnivoran mammals of the family Ursidae. They are classified as caniforms, or doglike carnivorans. Although only eight species of bears are extant, they are widespread, appearing in a wide variety of habitats throughout the Northern Hemisphere and partially in the Southern Hemisphere.",
                          numberOfComments: 25,
                          timePosted: 1644)
        
        let post2 = Post(user: .jordan,
                         content: #imageLiteral(resourceName: "tiger"),
                         numberOfLikes: 223,
                         caption: "The tiger (Panthera tigris) is the largest cat species, most recognizable for its pattern of dark vertical stripes on reddish-orange fur with a lighter underside. ",
                         numberOfComments: 112,
                         timePosted: 23995)
        
        let post3 = Post(user: .julian,
                         content: #imageLiteral(resourceName: "giraffe"),
                         numberOfLikes: 824,
                         caption: "The giraffe (Giraffa) is a genus of African even-toed ungulate mammals, the tallest living terrestrial animals and the largest ruminants.",
                         numberOfComments: 438,
                         timePosted: 141355)
        
        let post4 = Post(user: .dylan,
                         content: #imageLiteral(resourceName: "gorilla"),
                         numberOfLikes: 997,
                         caption: "Gorillas are ground-dwelling, predominantly herbivorous apes that inhabit the forests of central Sub-Saharan Africa.",
                         numberOfComments: 621,
                         timePosted: 211355)
        
        return [post1, post2, post3, post4]
    }
    
    static func paginatedPosts() -> [Post] {
        
        let post1 = Post(user: .dylan,
                         content: #imageLiteral(resourceName: "fox"),
                         numberOfLikes: 1024,
                         caption: "The red fox (Vulpes vulpes) is the largest of the true foxes and one of the most widely distributed members of the order Carnivora, being present across the entire Northern Hemisphere from the Arctic Circle to North Africa, North America and Eurasia.",
                         numberOfComments: 722,
                         timePosted: 441355)
        
        let post2 = Post(user: .jordan,
                         content: #imageLiteral(resourceName: "moose"),
                         numberOfLikes: 2121,
                         caption: "The moose (North America) or elk (Eurasia), Alces alces, is the largest extant species in the deer family.",
                         numberOfComments: 888,
                         timePosted: 641355)
        
        let post3 = Post(user: .julian,
                         content: #imageLiteral(resourceName: "elephant"),
                         numberOfLikes: 5002,
                         caption: "Elephants are large mammals of the family Elephantidae and the order Proboscidea.",
                         numberOfComments: 1048,
                         timePosted: 1241355)
        
        let post4 = Post(user: .dylan,
                         content: #imageLiteral(resourceName: "zebra"),
                         numberOfLikes: 8002,
                         caption: "Zebras are several species of African equids (horse family) united by their distinctive black and white striped coats.",
                         numberOfComments: 2257,
                         timePosted: 7241355)

        return [post1, post2, post3, post4]
    }
    
}
