//
//  SignupViewController.swift
//  KickStarterRxSwift
//
//  Created by Imac on 7/3/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

import UIKit
import RxSwift

class SignupViewController: UIViewController {

  let disposeBag = DisposeBag()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      let param = SearchParam()
      
      SearchRequest(param)
        .toObservable()
        .subscribe(onNext: { results in
          print(results)
        }).addDisposableTo(disposeBag)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
