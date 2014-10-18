//
//  ViewController.swift
//  Today
//
//  Created by Lide Oregui on 18/10/14.
//  Copyright (c) 2014 Lide. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var currentDay = 0
    var currentMonth = 0
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateFactLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        activityIndicator.hidden = true
        
        self.currentMonth = getMont()
        self.currentDay = getDay()
        
        initDate()
        
        getRandomFact()
    }
    
    func initDate() {
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        let dateString = dateFormatter.stringFromDate(date)
        
        self.dateLabel.text = "Today is \(dateString)"
        
    }
    
    func getMont() -> Int {
        
        let flags: NSCalendarUnit = .MonthCalendarUnit
        let date = NSDate()
        let components = NSCalendar.currentCalendar().components(flags, fromDate: date)
        
        let month = components.month
        
        return month
    }
    
    func getDay() -> Int {
        
        let flags: NSCalendarUnit = .DayCalendarUnit
        let date = NSDate()
        let components = NSCalendar.currentCalendar().components(flags, fromDate: date)
        
        let day = components.day
        
        return day
    }
    
    
    func getRandomFact() -> Void {
        
        let numbersURL = NSURL(string: "http://numbersapi.com/\(self.currentMonth)/\(self.currentDay)/date?json")
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(numbersURL, completionHandler: { (location:NSURL!, response:NSURLResponse!, error:NSError!) -> Void in
            
            
            if (error == nil) {
                
                let dataObject = NSData(contentsOfURL: location)
                let resultDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject, options: nil, error: nil) as NSDictionary
                
                let factText = resultDictionary["text"] as String
                

                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.dateFactLabel.text = factText
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    self.refreshButton.hidden = false
                });
                
            } else {
                
                let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data. Connectivity error!", preferredStyle: .Alert)
                
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                networkIssueController.addAction(okButton)
                
                let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                networkIssueController.addAction(cancelButton)
                
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    self.refreshButton.hidden = false
                });
                
            }
            
            
        });
        downloadTask.resume()
    }
    
    @IBAction func refresh() {
        
        getRandomFact()
        
        refreshButton.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

