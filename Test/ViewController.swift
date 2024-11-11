//
//  ViewController.swift
//  Test
//
//  Created by Pranaya on 11/11/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var product = [String]()
    var price = [Double]()
    @IBOutlet weak var productTextField: UITextField!
    

    @IBOutlet weak var productTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        fetchItems(completionHandler: { items in
            print(items.products.count)
            for i in 0...items.products.count-1{
                print(items.products[i].name)
                self.product.append(items.products[i].name)
                self.price.append(items.products[i].salePrice)
            }
            
            
            DispatchQueue.main.async {
                self.productTable.reloadData()
            }
            
            
            
        }, productName: productTextField.text!)
        
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = self.productTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        aCell.productLabel.text = self.product[indexPath.row]
        aCell.priceLabel.text = String(self.price[indexPath.row])
        return aCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "productDetails", sender: self)
        
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
