//
//  ViewController.swift
//  LocationFetch
//
//  Created by Swarajmeet Singh on 27/07/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var locationButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func accessLocationButtonTapped(_ button: UIButton) {
        button.isEnabled = false
        LocationFetcher.shared.fetchLocation { location in
            button.isEnabled = true
            if let location = location {
                let tit = "Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)"
                button.setTitle(tit, for: .normal)
                // Use the fetched location
                print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            } else {
                // Location access denied or unable to fetch location
                let tit = "Location access denied or unable to fetch location."
                button.setTitle(tit, for: .normal)
                print("Location access denied or unable to fetch location.")
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            button.isEnabled = true
        })
    }
    
}

