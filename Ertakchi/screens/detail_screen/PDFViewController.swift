//
//  PDFViewController.swift
//  Ertakchi
//
//  Created by Mekhriddin Jumaev on 24/01/24.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    let pdfView = PDFView()
    
    var pdfURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let backButton = CustomBarButtonView(image: UIImage(systemName: "arrow.backward")!)
        backButton.buttonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.showLoadingView()

        DispatchQueue.global(qos: .background).async { [weak self] in
            
            guard let pdfURLString = self?.pdfURL, let self = self ,
                  let url = URL(string: pdfURLString) else {
                // Handle invalid URL or weak self being nil
                return
            }

            let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)

            // Check if the file already exists
            if FileManager.default.fileExists(atPath: destinationURL.path),
               let document = PDFDocument(url: destinationURL) {
                // File already exists, load it directly
                DispatchQueue.main.async {
                    self.pdfView.document = document
                    self.dissmissLoadingView()
                }
                return
            }

            // File doesn't exist, initiate download
            let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            let downloadTask = urlSession.downloadTask(with: url)
            downloadTask.resume()

            // Clean up the URLSession and delegate after the download is complete
            defer {
                urlSession.finishTasksAndInvalidate()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.isTranslucent = true
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.isTranslucent = true
//    }
}

extension PDFViewController:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                if let document = PDFDocument(url: url) {
                    self.pdfView.document = document
                    self.dissmissLoadingView()
                }
            }
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
