//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by  Alex Sumak on 1/31/17.
//  Copyright © 2017  Alex Sumak. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var endpoint:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
        let refreshControl = UIRefreshControl()
      
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        
        tableView.insertSubview(refreshControl, at: 0)
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")! 
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                }
            }
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        task.resume()
    }
    
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        
        // ... Create the URLRequest `myRequest` ...
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        // Configure session so that completion handler is executed on main UI thread
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                }
            }
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()

        }

        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies = movies{
            return movies.count
        }else{
            return 0
        }
        
    }
    
    
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String{
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        cell.posterView.setImageWith(imageUrl as! URL)
        
        print("row \(indexPath.row)")
        }
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies?[(indexPath?.row)!]
        
        //add red color when click
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.red
        cell.selectedBackgroundView = backgroundView
        
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie!
        
       
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
