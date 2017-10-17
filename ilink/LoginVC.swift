//
//  LoginVC.swift
//  ilink
//
//  Created by Capp Andy MIGOUMBI AKENDEGUE on 24/05/2016.
//  Copyright © 2016 Capp Andy MIGOUMBI AKENDEGUE. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinTapped(_ sender: UIButton) {
        let username:NSString = txtUsername.text!
        let password:NSString = txtPassword.text!
        let tag:NSString = "login_ios"
        
        if ( username.isEqual(to: "") || password.isEqual(to: "") ) {
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButton(withTitle: "OK")
            alertView.show()
        } else {
            
            do {
                let post:NSString = "phone=\(username)&password=\(password)&tag=\(tag)"
                
                NSLog("PostData: %@",post);
                
                let url:URL = URL(string:"https://ilink-app.com/app/index.php")!
                
                let postData:Data = post.data(using: String.Encoding.ascii.rawValue)!
                
                let postLength:NSString = String( postData.count )
                
                let request:NSMutableURLRequest = NSMutableURLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = postData
                request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                
                var reponseError: NSError?
                var response: URLResponse?
                
                var urlData: Data?
                do {
                    urlData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:&response)
                } catch let error as NSError {
                    reponseError = error
                    urlData = nil
                }
                
                if ( urlData != nil ) {
                    let res = response as! HTTPURLResponse!;
                    
                    NSLog("Response code: %ld", res?.statusCode);
                    
                    if (res?.statusCode >= 200 && res?.statusCode < 300)
                    {
                        let responseData:NSString  = NSString(data:urlData!, encoding:String.Encoding.utf8.rawValue)!
                        
                        NSLog("Response ==> %@", responseData);
                        
                        //var error: NSError?
                        
                        let jsonData:NSDictionary = try JSONSerialization.jsonObject(with: urlData!, options:JSONSerialization.ReadingOptions.mutableContainers ) as! NSDictionary
                        
                        
                        let success:NSInteger = jsonData.value(forKey: "success") as! NSInteger
                        
                        //[jsonData[@"success"] integerValue];
                        
                        NSLog("Success: %ld", success);
                        
                        if(success == 1)
                        {
                            NSLog("Login SUCCESS");
                            
                            let prefs:UserDefaults = UserDefaults.standard()
                            prefs.set(username, forKey: "USERNAME")
                            prefs.set(1, forKey: "ISLOGGEDIN")
                            prefs.synchronize()
                            
                            //self.dismissViewControllerAnimated(true, completion: nil)
                            self.performSegue(withIdentifier: "goto_simple_user_map", sender: self)
                        } else {
                            var error_msg:NSString
                            
                            if jsonData["error_message"] as? NSString != nil {
                                error_msg = jsonData["error_message"] as! NSString
                            } else {
                                error_msg = "Unknown Error"
                            }
                            let alertView:UIAlertView = UIAlertView()
                            alertView.title = "Sign in Failed!"
                            alertView.message = error_msg as String
                            alertView.delegate = self
                            alertView.addButton(withTitle: "OK")
                            alertView.show()
                            
                        }
                        
                    } else {
                        let alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = "Connection Failed"
                        alertView.delegate = self
                        alertView.addButton(withTitle: "OK")
                        alertView.show()
                    }
                } else {
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failure"
                    if let error = reponseError {
                        alertView.message = (error.localizedDescription)
                    }
                    alertView.delegate = self
                    alertView.addButton(withTitle: "OK")
                    alertView.show()
                }
            } catch {
                let alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Server Error"
                alertView.delegate = self
                alertView.addButton(withTitle: "OK")
                alertView.show()
            }
        }
    }
  

    @IBAction func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
