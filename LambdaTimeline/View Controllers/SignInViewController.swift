//
//  SignInViewController.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    let postController = PostController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        segueIfUsernameExists()
    }
    
    @IBAction func getStarted(_ sender: Any) {
        UserDefaults.standard.set(nameTextField.text, forKey: "username")
        segueIfUsernameExists()
    }
    
    func segueIfUsernameExists() {
        if UserDefaults.standard.string(forKey: "username") != nil {
            performSegue(withIdentifier: "ModalPostsVC", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalPostsVC" {
            guard let postsVC = (segue.destination as? UINavigationController)?.topViewController as? PostsCollectionViewController else { return }
            
            postsVC.postController = postController
        }
    }
}
