//
//  firstView.swift
//  InSight
//
//
//

import UIKit

class firstView: UIViewController {

    
    @IBOutlet weak var gbImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Enabling user interaction
        gbImageView.isUserInteractionEnabled = true
        
        //Enabling it to recognize tap gestures
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
    
    }
    
     @objc func imageViewTapped() {
        
        //let nextViewController = NextViewController()
        //navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func didTap(){
        
        let vc = storyboard?.instantiateViewController(identifier: "secondVC") as! secondView
        present(vc, animated: true)
    }

}

