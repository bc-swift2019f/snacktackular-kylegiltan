//
//  Spots.swift
//  Snacktacular
//
//  Created by Kyle Gil Tan on 11/1/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Spots{
    var spotsArray = [Spot]()
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()){
        db.collection("spots").addSnapshotListener{ (querySnapshot, error) in
            guard error == nil else{
                print("error adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.spotsArray = []
            //there are querySnapshot!.documents.count documents in the spots snapshot
            for document in querySnapshot!.documents{
                let spot = Spot(dictionary: document.data())
                spot.documentID = document.documentID
                self.spotsArray.append(spot)
            }
            completed()
        }
    }
}


