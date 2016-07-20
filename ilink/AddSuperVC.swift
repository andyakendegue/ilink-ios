//
//  AddSuperVC.swift
//  ilink
//
//  Created by Capp Andy MIGOUMBI AKENDEGUE on 28/06/2016.
//  Copyright © 2016 Capp Andy MIGOUMBI AKENDEGUE. All rights reserved.
//

import UIKit

class AddSuperVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var codePays: UIPickerView!
    
    @IBOutlet weak var codeReseau: UIPickerView!
    
    
    var paysData: [String] = [String]()
    var reseauData: [String] = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // Connect data:
        self.codePays.delegate = self
        self.codePays.dataSource = self
        self.codeReseau.delegate = self
        self.codeReseau.dataSource = self
        
        // Input data into the Array:
        paysData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
        reseauData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /** Les pays 
     **
     **/
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return paysData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return paysData[row]
    }
    
    /** Les pays
     **
     **/
    
    // The number of columns of data
    func numberOfComponentsInPickerReseauView(pickerPaysView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerPaysView(pickerPaysView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reseauData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerPaysView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reseauData[row]
    }
    

    @IBAction func exit(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
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
