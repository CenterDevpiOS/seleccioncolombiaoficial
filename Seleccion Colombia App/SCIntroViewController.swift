//
//  SCIntroViewController.swift
//  Seleccion Colombia App
//
//  Created by orlando arzola on 6/11/17.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SCIntroViewController: AVPlayerViewController, CAAnimationDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
        self.showsPlaybackControls = false

        var introName : String
        
        if AppUtility.isBSC(){
            introName = "IntroBSC"
        }else{
            introName = "IntroColombia"
        }

        guard let path = Bundle.main.path(forResource: introName, ofType:"mp4") else {
            debugPrint("Intro not found")
            return
        }
        //let url = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url: url)
        self.player = player
        self.player?.play()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }

    
    func playerDidFinishPlaying(note: NSNotification) {
        print("Video Finished")
        enterApp()
    }
    
    func enterApp() -> Void {
        
        let animation = CATransition()
        animation.delegate = self
        animation.type = kCATransitionFade
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window?.layer.add(animation, forKey: "transitionViewAnimation")
        
        appDelegate.window?.rootViewController = homeVC
        
        appDelegate.window?.makeKeyAndVisible()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SCIntroViewController: AVPlayerViewControllerDelegate {
    
    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        print("stopped");
    }
    
}
