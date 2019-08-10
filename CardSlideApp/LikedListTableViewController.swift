//
//  LikedListTableViewController.swift
//  CardSlideApp
//
//  Created by VERTEX20 on 2019/08/10.
//  Copyright © 2019 VERTEX20. All rights reserved.
//

import UIKit

class LikedListTableViewController: UITableViewController {

    // いいねをした人の名前の配列。viewControllerから情報を受け取る
    var likedName: [String] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // MARK: - Table view data source

    
    // セクション数はなくていい。セルの数と中身は必ず入れる
    // いいねされたユーザーの要素数。セルの数を返すメソッド
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return likedName.count
    }

    // セルの中身
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // いいねされた人の名前を表示
        cell.textLabel?.text = likedName[indexPath.row]
        
        return cell
        
    }
    


}

