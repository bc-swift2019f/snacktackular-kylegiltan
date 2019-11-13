//
//  RenameTableViewController.swift
//  Snacktacular
//
//  Created by Kyle Gil Tan on 11/9/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import UIKit

class ReviewTableViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var reviewTitle: UITextField!
    @IBOutlet weak var reviewView: UITextView!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var buttonsBackgroundView: UIView!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet var starButtonConnection: [UIButton]!
    
    var spot: Spot!
    var review: Review!
    
    var rating = 0 {
        didSet{
            for starButton in starButtonConnection{
                let image = UIImage(named: (starButton.tag < rating ? "star-filled" : "star-empty"))
                starButton.setImage(image, for: .normal)
                print("new raint \(rating)")
            }
            review.rating = rating
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //hide keyboard if we tap outside field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        guard let spot = spot else{
            print("error no valid spot in ReviewDetailViewControlled")
            return
        }
        nameLabel.text = spot.name
        addressLabel.text = spot.address
        if review == nil{
            review = Review()
        }
        
    }
    
    
    func leaveViewController(){
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }



    @IBAction func starButtonPressed(_ sender: UIButton) {
        rating = sender.tag + 1 // add once since 0 indexed
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        review.title = reviewTitle.text!
        review.text = reviewView.text!
        
        review.saveData(spot: spot) {(success) in
            if success{
                self.leaveViewController()
            }
            else{
                print ("Error cou;dn't leave this view controller bc data wasn't saved")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func reviewTitleChanged(_ sender: Any) {
    }
    
    @IBAction func returnTitleDonePressed(_ sender: UITextField) {
    }
    
    

}
