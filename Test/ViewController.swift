//
//  ViewController.swift
//  Test
//
//  Created by Pranaya on 11/11/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var results = [Product]()
    var productDetail = [Detail]()
    var skuno: Int64 = 0
    
    @IBOutlet weak var productTextField: UITextField!
    

    @IBOutlet weak var productTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        
        fetchItems(completionHandler: { items in
            print(items.products.count)
            self.results = []
            if items.products.count == 0{
                print("No results found")
                
                self.results.append(Product(name: "No results found", salePrice: nil, sku: nil))
            }else{
                for i in 0...items.products.count-1{
                    print(items.products[i].name)
                    self.results.append(items.products[i])
                }
                
            }
            
            
            
            DispatchQueue.main.async {
                self.productTable.reloadData()
            }
            
            
            
        }, productName: productTextField.text!)
        
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = self.productTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        aCell.productLabel.text = self.results[indexPath.row].name
        if let price = self.results[indexPath.row].salePrice{
            aCell.priceLabel.text = String(price)
        }
        
        return aCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        skuno = results[indexPath.row].sku!
        performSegue(withIdentifier: "productDetails", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productDetails"{
            let destinationVc = segue.destination as! ProductDetailsViewController
            
            destinationVc.skuno = skuno
        }
    }
    
    
    func fetchItems(completionHandler:@escaping (Items) -> Void, productName: String){
        let url = URL(string: "https://api.bestbuy.com/v1/products(longDescription=\(productName)*)?show=sku,name,salePrice&pageSize=15&page=5&apiKey=aeZRFBMmqfd2alMpLFpEZdNU&format=json")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data,response,error) in
            if let error = error{
                print("error fetching items:\(error)")
                return
            }
            guard let httpresponse = response as? HTTPURLResponse,(200...299).contains(httpresponse.statusCode) else{
                print("error in response:\(String(describing: response))")
                return
            }
            if let data = data{
                let itemsArray = try? JSONDecoder().decode(Items.self, from: data)
                
                completionHandler(itemsArray!)
            }
            
        })
        
        task.resume()
    }
    
    
    
}

