//
//  launchViewController.swift
//  Metronome
//
//  Created by Tatevik Ketikyan on 04.10.21.
//

import UIKit

class launchViewController: UIViewController {

    @IBAction func launchButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToNext", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
