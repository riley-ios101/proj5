//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let currPost = posts[indexPath.row]
        
        if let photo = currPost.photos?.first {
            
            let url = photo.originalSize.url
              
              // Load the photo in the image view via Nuke library...
            Nuke.loadImage(with: url, into: cell.postImageView)

        } else {
            cell.postImageView.backgroundColor = .lightGray
        }
        
        cell.postSummary.text = currPost.summary
        
        
        return cell
        
        
        
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    private var posts : [Post] = []
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Refresh Control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        tableView.dataSource = self
        
        fetchPosts()
        
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Call your data loading method or any action you want to perform when refreshing

        // After fetching new data or performing desired action, end refreshing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tableView.reloadData() // Reload your table data
            self.refreshControl.endRefreshing() // End refreshing
        }
    }

    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/dogposts/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }
            

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in

                    let posts = blog.response.posts

                    print("✅ We got \(posts.count) posts!")
                    for post in posts {
                        print("🍏 Summary: \(post.summary)")
                    }
                    
                    self?.posts = posts
                    self?.tableView.reloadData()
                }
                
                

            } catch {
//                print("❌ Error decoding JSON: \(error.localizedDescription)")
                print("❌ Error decoding JSON: \(error)")
            }
        }
        session.resume()
    }
}
