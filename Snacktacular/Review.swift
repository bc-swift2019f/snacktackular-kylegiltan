//
//  Review.swift
//  Snacktacular
//
//  Created by Kyle Gil Tan on 11/9/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Review{
    var title: String
    var text: String
    var rating: Int
    var reviewerUserID: String
    var date: Date
    var documentID: String
    
// my old code
    var dictionary: [String: Any]{
        return ["title": title, "text": text, "rating": rating, "reviewerUserID": reviewerUserID, "date": date, "documentID": documentID]
    }
    
//new code
//    var dictionary: [String: Any] {
//        let timeIntervalDate = date.timeIntervalSince1970
//        return ["title": title, "text": text, "rating": rating, "reviewerUserID": reviewerUserID, "date": timeIntervalDate] //do u need document id
//    }
    
    init(title: String, text: String, rating: Int, reviewerUserID: String, date: Date, documentID: String){
        self.title = title
        self.text = text
        self.rating = rating
        self.reviewerUserID = reviewerUserID
        self.date = date
        self.documentID = documentID
    }
    convenience init(dictionary: [String: Any]){
        let title = dictionary["title"] as! String? ?? ""
        let text = dictionary["text"] as! String? ?? ""
        let rating = dictionary["rating"] as! Int? ?? 0
        let reviewerUserID = dictionary["reviewerUserID"] as! String
        let time = dictionary["date"] as! Timestamp?
        let date = time?.dateValue() ?? Date()
        self.init(title: title, text: text, rating: rating, reviewerUserID: reviewerUserID, date: date, documentID: "")
    }
   
    
//new code
//    convenience init(dictionary: [String: Any]) {
//        let title = dictionary["title"] as! String? ?? ""
//        let text = dictionary["text"] as! String? ?? ""
//        let rating = dictionary["rating"] as! Int? ?? 0
//        let reviewerUserID = dictionary["reviewerUserID"] as! String
//        // let date = dictionary["date"] as! Date? ?? Date()
//        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
//        let date = Date(timeIntervalSince1970: timeIntervalDate)
//        self.init(title: title, text: text, rating: rating, reviewerUserID: reviewerUserID, date: date, documentID: "")
//    }
    
    convenience init(){
        let currentUserID = Auth.auth().currentUser?.email ?? "Unknown User"
        self.init(title: "", text: "", rating: 0, reviewerUserID: currentUserID, date: Date(), documentID: "")
    }
    
    func saveData(spot: Spot, completed: @escaping (Bool) -> ()){
        let db = Firestore.firestore()
        //create dictionary representing the data we want to save
        let dataToSave = self.dictionary
        //if we have saved a rec, we'll have a docID
        if self.documentID != ""{
            let ref = db.collection("spots").document(spot.documentID).collection("reviews").document(self.documentID)
            ref.setData(dataToSave){(error) in
                if let error = error{
                    print("error updateding doc \(self.documentID) in spot \(spot.documentID) \(error.localizedDescription)")
                    completed(false)
                }
                else{
                    print("document updated with ref DI \(ref.documentID)")
                    completed(true)
                }
            }
        }
        else{
            var ref: DocumentReference? = nil
            ref = db.collection("spots").document(spot.documentID).collection("reviews").addDocument(data: dataToSave){error in
                if let error = error{
                    print("error creating doc \(self.documentID) in spot \(spot.documentID) \(error.localizedDescription)")
                    completed(false)
                }
                else{
                    print("document created with ref DI \(ref?.documentID ?? "unknown")")
                    completed(true)
                }
            }
        }
    }
    
    func deleteDate(spot: Spot, completed: @escaping (Bool) -> ()){
        let db = Firestore.firestore()
        db.collection("spots").document(spot.documentID).collection("reviews").document(documentID).delete(){ error in
            if let error = error{
                print("ERROR DELETING REVIEW DOCUMENTID \(self.documentID) \(error.localizedDescription)")
                completed(false)
            }
            else{
                completed(true)
            }
            
        }
    }
    
}
