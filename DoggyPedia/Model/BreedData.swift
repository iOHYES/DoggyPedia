//
//  BreedData.swift
//  DoggyPedia
//
//  Created by X on 17/01/2021.
//

import Foundation

struct Dog : Codable
{
    let name : String
    let reference_image_id : String?
    let temperament : String?
    let breed_group : String?
    let life_span : String?
}

struct Breeds : Codable {
    let url : String
    let breeds : [Dog]
}
