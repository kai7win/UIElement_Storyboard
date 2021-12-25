//
//  ViewController.swift
//  UIElement_Storyboard
//
//  Created by Kai Chi Tsao on 2021/12/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var sliderView: UISlider!
    @IBOutlet weak var switchView: UISwitch!
    
    @IBOutlet weak var dogeImg: UIImageView!
    
    @IBOutlet weak var progressText: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var dateText: UILabel!
    
    
    let imgArray = ["img1","img2","img3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.layer.opacity = 0
        sliderView.layer.opacity = 0
        activityIndicator.hidesWhenStopped = true
        if dogeImg.image == nil {
            switchView.isEnabled = false
        }
        
        pageControl.numberOfPages = imgArray.count
        self.scrollView.delegate = self
        
        for i in 0..<imgArray.count {
            let imgView = UIImageView()
            imgView.contentMode = .scaleToFill
            imgView.image = UIImage(named:imgArray[i])
            
            let xPos = CGFloat(i)*self.view.bounds.size.width
            imgView.frame = CGRect(x:xPos,y:0,width: view.frame.width,height: 180 )
            scrollView.contentSize.width = view.frame.size.width*CGFloat(i+1)
            scrollView.addSubview(imgView)
        }
        
        
        
    }
    
    @IBAction func changeBgSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            view.backgroundColor = .white
        case 1:
            view.backgroundColor = .green
        case 2:
            view.backgroundColor = .yellow
        default:
            view.backgroundColor = .white
        }
    }
    
    @IBAction func blurSwitch(_ sender: UISwitch) {
        
      
        
        if sender.isOn {
            blurView.layer.opacity = 1
            sliderView.layer.opacity = 1
            sliderView.value = 1
            
        }else{
            blurView.layer.opacity = 0
            sliderView.layer.opacity = 0
        }
        
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        blurView.layer.opacity = sender.value
        if sender.value == 0{
            switchView.isOn = false
        }
    }
    
    @IBAction func downloadImg(_ sender: UIButton) {
        
        self.progressText.isHidden = false
        
        activityIndicator.startAnimating()
        
        dogeImg.image = nil
        
        let urlString = "https://images.pexels.com/photos/8152012/pexels-photo-8152012.jpeg"
        
        guard let url = URL(string: urlString)else{
            print("invalid URL")
            return
        }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        session.downloadTask(with: url).resume()
        
    }
    
    
    @IBAction func selectedDate(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        dateText.text = "選擇時間：\(formatter.string(from: datePicker.date))"
    }
    
    
}

extension ViewController:URLSessionDownloadDelegate{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location) else {
            print("The data can't load")
            return
        }
        
        let img = UIImage(data: data)
        self.dogeImg.image = img
        self.progressText.isHidden = true
        activityIndicator.stopAnimating()
        switchView.isEnabled = true
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        self.progressBar.progress = progress
        self.progressText.text = "\(progress * 100)%"
        
        
    }
    
}

extension ViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.frame.width
        pageControl.currentPage = Int(page)
    }
}
