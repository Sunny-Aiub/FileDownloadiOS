//
//  SingleFileDownloadViewController.swift
//  FileDownloadiOS
//
//  Created by Sunny Chowdhury on 8/6/19.
//  Copyright © 2019 Sunny Chowdhury. All rights reserved.
//

import UIKit

class SingleFileDownloadViewController: UIViewController, UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imageUrl : String = "https://d1lwfjp709sq0o.cloudfront.net/media/catalog/product/cache/1/thumbnail/300x300/9df78eab33525d08d6e5fb8d27136e95/h/e/helio-s60-1.jpg"
    
    
    /// Creating UIDocumentInteractionController instance.
    let documentInteractionController = UIDocumentInteractionController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// Setting UIDocumentInteractionController delegate.
        documentInteractionController.delegate = self
    }

    @IBAction func btnDocDownloadClicked(_ sender: Any) {
        
        print("btnDocDownloadClicked")
    }
    
    @IBAction func btnPdfDownloadClicked(_ sender: Any) {
        print("btnPdfDownloadClicked")

    }
    
    @IBAction func btnImageDownloadClicked(_ sender: Any) {
        
        print("btnImageDownloadClicked")
        storeAndShare(withURLString: imageUrl)

    }
    
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
    
    /// This function will set all the required properties, and then provide a preview for the document
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
        
        let alert = UIAlertController(title: "Image Downloaded", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)

    }
    
    
    /// This function will store your document to some temporary URL and then provide sharing, copying, printing, saving options to the user
    func storeAndShare(withURLString: String) {
        guard let url = URL(string: withURLString) else { return }
        /// START YOUR ACTIVITY INDICATOR HERE
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "fileName.png")
            do {
                try data.write(to: tmpURL)
            } catch {
                
                self.activityIndicator.stopAnimating()
                print(error)
                
            }
            DispatchQueue.main.async {
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.activityIndicator.stopAnimating()
                self.share(url: tmpURL)
            }
            }.resume()
    }
    
}

extension UIViewController{
    
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
