//
//  ProductDetailsViewController.swift
//  Test
//
//  Created by Pranaya on 11/12/24.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    var skuno:Int64 = 0
    
    @IBOutlet weak var productDetailLabel: UILabel!
    
    @IBOutlet weak var skuLabel: UILabel!
    
    @IBOutlet weak var regularPriceLabel: UILabel!
    
    @IBOutlet weak var salePriceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var productImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemDetails(completionHandler: { x in
            print("Image url: \(x.products[0].image)")
            DispatchQueue.main.async {
                self.skuLabel.text = "Sku:" + String(x.products[0].sku)
                self.productDetailLabel.text =  String(x.products[0].name)
                self.descriptionLabel.text = "Details:" + String(x.products[0].longDescription)
                self.regularPriceLabel.text = "RegularPrice:" + String(x.products[0].regularPrice)
                self.salePriceLabel.text = "SalePrice:" + String(x.products[0].salePrice)
            }
            getData(from: x.products[0].image) { x in
                DispatchQueue.main.async {
                    self.productImage.image = UIImage(data: x)
                }
            }
        }, sku: skuno)
        
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
    func itemDetails(completionHandler:@escaping (ProductDetail) -> Void, sku: Int64){
        let url = URL(string: "https://api.bestbuy.com/v1/products(sku=\(sku))?apiKey=aeZRFBMmqfd2alMpLFpEZdNU&format=json")!
        print("itemDetails url: \(url)")
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data,response,error) in
            if let error = error{
                print("error in fetching details: \(error)")
                return
            }
            guard let httpresponse = response as? HTTPURLResponse,(200...299).contains(httpresponse.statusCode)else{
                print("error in response:\(String(describing: response))")
                return
            }
            if let data = data{
                print(data)
                let details = try? JSONDecoder().decode(ProductDetail.self, from: data)
                    completionHandler(details!)
            }
        })
        task.resume()
    }
    
    

}
func getData(from url: String, completion: @escaping (Data) -> Void) {
    let urllink = URL(string: url)
    let task = URLSession.shared.dataTask(with: urllink!, completionHandler: {
        (data,response,error) in
        if let error = error{
            print("error fetching image:\(error)")
            return
        }
        guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode)else{
            print("error in image response:\(response)")
            return
        }
        if let data = data{
            completion(data)
            
        }
    })
    task.resume()
}
