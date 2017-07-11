//
//  LoginViewController.swift
//  KickStarterRxSwift
//
//  Created by Imac on 7/11/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

  let viewModel = LoginViewModel()
  let disposeBag = DisposeBag()
  
  @IBOutlet weak var usernameTextfield: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      rxBinding()
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

  func rxBinding() {
    usernameTextfield.rx.text.bind(to: viewModel.inputs.username).addDisposableTo(disposeBag)
    passwordTextfield.rx.text.bind(to: viewModel.inputs.password).addDisposableTo(disposeBag)
    //viewModel.inputs.isValid.bind(to: <#T##(Observable<Bool>) -> R#>)
  }
}
