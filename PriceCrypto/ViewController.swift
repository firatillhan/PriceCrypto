//
//  ViewController.swift
//  PriceCrypto
//
//  Created by Fırat İlhan on 8.11.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var dcLabel: UILabel!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        crypto()
        tarih()
  
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(refreshing))
       
        
        
    }
    
    
    func tarih() {
        
        let tarihFormat = DateFormatter()
        tarihFormat.dateStyle = .none
        tarihFormat.timeStyle = .medium
       
        let formatTarih = tarihFormat.string(from: Date())
        dcLabel.text = "\(formatTarih)"
    }
    
    
    @objc func refreshing() {
        crypto()
        tarih()
       
        
    }
    
    func crypto() {
        let url = URL(string: "https://blockchain.info/ticker")
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                let alert = UIAlertController(title: "ERROR", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert,animated: true, completion: nil)
            } else {
                if data != nil {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        DispatchQueue.main.async {
                       
                            if let rates = jsonResponse["USD"] as? [String : Any] {
                                 if let usd = rates["last"] as? Double {
                                     self.usdLabel.text = "\(usd) $"
                                 }
                             }
                          
                            
                            
                        }
                    } catch {
                        print("error")
                    }
                }
            }
        }
        task.resume()
    }
    
    
    

}

