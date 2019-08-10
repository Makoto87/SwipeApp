//
//  ViewController.swift
//  CardSlideApp
//
//  Created by VERTEX20 on 2019/08/10.
//  Copyright © 2019 VERTEX20. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // ベースviewと 真ん中にあるImage
    @IBOutlet weak var baseCard: UIView!
    
    @IBOutlet weak var likeImage: UIImageView!
    
    
    // ユーザーカード。下から載せる
    // 画像、名前等のデータは、ストーリーボード上のイメージやタイトルをいじる
    // 同じ階層にもう一つview(ベースカード用)を置く。person5と同じ制約にして、
    @IBOutlet weak var person1: UIView!
    @IBOutlet weak var person2: UIView!
    @IBOutlet weak var person3: UIView!
    @IBOutlet weak var person4: UIView!
    @IBOutlet weak var person5: UIView!
    
    
    // ベースカードの座標。中心CGPointは型は座標で必ず数字はあるから!を使う。
    // ここの(0,0)の座標はiPhone画面の左上
    var centerOfCard: CGPoint!
    
    // ユーザーカードの配列
    var personList: [UIView] = []
    
    // カードの数を数える変数
    var selectedCardCount: Int = 0
    
    // ユーザーの名前の配列
    let nameList: [String] = ["津田梅子","ジョージワシントン","ガリレオガリレイ","板垣退助","ジョン万次郎"]
    
    // いいねをされた人の名前の配列
    var likedName: [String] = []
    
    // viewが表示される直前に呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        // super.~ は親クラス(ここではUIViewController)のメソッドを使うことができる
        super.viewWillAppear(animated)
        // カードのカウントをもとに戻す
        selectedCardCount = 0
        // いいねの数をリセット
        likedName = []
    }
    
    
    // viewのレイアウト処理が完了したときに呼ばれる
    override func viewDidLayoutSubviews() {
        // ベースカードの中心を代入
        centerOfCard = baseCard.center
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // personListにperson1から5を追加
        personList.append(person1)
        personList.append(person2)
        personList.append(person3)
        personList.append(person4)
        personList.append(person5)
    }
    
    
    // 離れたあとに行われる処理
    override func viewDidDisappear(_ animated: Bool) {
        // 飛んでいったviewを元の位置に戻すメソッド
        resetPersonList()
    }
    
    // overrideはUIViewController内に用意されているものを使う
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // identifier が ToLikedList だったら if が行われる
        if segue.identifier == "ToLikedList" {
            // LikedListTableViewControllerに情報が行く
            let vc = segue.destination as! LikedListTableViewController
            // 配列liledName の情報が遷移先の lekedName に移る
            vc.likedName = likedName
        }
    }
    
    // ベースカードの距離と角度をもとに戻すメソッド
    func resetCard() {
        baseCard.center = centerOfCard
        baseCard.transform = .identity
    }
    
    // 結果後、カードをもとに戻す関数
    func resetPersonList() {
        // 5人の飛んで行ったビューを元の位置に戻す
        for person in personList {
            // 元に戻す処理。中心に戻す
            person.center = self.centerOfCard
            person.transform = .identity
        }
    }

    
    // スワイプのツールをつなげる
    // typeはAnyではない
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        // ベースカード。スワイプで動くviewを定数化
        // senderの中にbaseCardが入っている。(pan gestureにbasecardが紐付いているから)
        // sender.viewはsenderの中のviewのこと
        let card = sender.view!
        
        // 大本のviewからどれくらい動いたかわかる距離
        // translationは動いた距離がわかる関数
        // in: viewのviewは一番大きいview
        let point = sender.translation(in: view)
        
        // センターの座標に動いたぶんの座標を足している
        card.center = CGPoint(x: card.center.x + point.x, y: card.center.y + point.y)
        
        // 選ばれたカードの中心の座標に動いたぶんの座標を足している
        // 上と同じ動きをさせている
        personList[selectedCardCount].center = CGPoint(x: card.center.x + point.x, y:card.center.y + point.y)
        
        // 中心からどれくらい離れたかの距離
        // このviewは一番の大本のview
        let xfromCenter = card.center.x - view.center.x
        
        // ベースカードに角度をつける処理
        // CGAffineTransform <- 回転用の関数。rotationAngle <- 引数。view.frame.width <- 端から端までの幅、2で割ることで中心から端までの距離を表す。
        // 0.785 <- 右端に行ったときに45度になるようにかける
        card.transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        
        // ユーザーカードに角度をつける
        personList[selectedCardCount].transform = CGAffineTransform(rotationAngle: xfromCenter / (view.frame.width / 2) * -0.785)
        
        // likeImage(中心に出てくる画像)の表示
        if xfromCenter > 0 {
            // goodボタンの表示。= の右側をimageLiteralにすることで画像にできる
            likeImage.image = #imageLiteral(resourceName: "いいね")
            // Bool型。trueでは非表示。
            likeImage.isHidden = false
            
        } else if xfromCenter < 0 {
            // badボタンの表示
            likeImage.image = #imageLiteral(resourceName: "よくないね")
            likeImage.isHidden = false
            
        }
        
        // 指を離したときに行う処理
        // stateは状態を表す。state.endedは離したときのこと
        if sender.state == UIGestureRecognizer.State.ended {
            
            // 左に大きくスワイプしたときの処理
            // 座標が50より小さい時
            if card.center.x < 50 {
                
                UIView.animate(withDuration: 0.5, animations: {
                // X座標を左に500とばす(-500) = 大きく飛ばす
                self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x - 500, y :self.personList[self.selectedCardCount].center.y)
                
                // ベースカードの距離と角度を戻すメソッド。ユーザーカードだけ飛ばす
                self.resetCard()

                    
                })
                
                // 画像を非表示にする
                likeImage.isHidden = true
                // 次のカードへ行く処理
                selectedCardCount += 1
                // カードの数が用意された人より多くなったときに遷移する
                if selectedCardCount >= personList.count {
                    performSegue(withIdentifier: "ToLikedList", sender: self)
                }
                
            // 右に大きくスワイプしたときの処理
            // viewの端の座標から50引いた座標より大きいとき
            } else if card.center.x > self.view.frame.width - 50 {
                
                UIView.animate(withDuration: 0.5, animations: {
                // X座標を右に500とばす(+500)
                self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x + 500, y :self.personList[self.selectedCardCount].center.y)
                
                self.resetCard()

                    
                })
                
                likeImage.isHidden = true
                // いいねした人の名前を配列に追加。カウントする前に入れなければ次の人の名前が入る
                likedName.append(nameList[selectedCardCount])
                selectedCardCount += 1
                
                if selectedCardCount >= personList.count {
                    performSegue(withIdentifier: "ToLikedList", sender: self)
                }
                
            } else {
            
            
            
            // クロージャによるアニメーションの追加
            // 数字で戻ってくるまでの秒数を表す
            // animationsの中で動きを示す。戻す処理
                UIView.animate(withDuration: 0.5, animations: {
                // 中で自身のプロパティを指すときはselfを使う
                    
                    // ベースカードをもとに戻すメソッド
                    self.resetCard()
                    // ユーザーカードを元の位置に戻す
                    self.personList[self.selectedCardCount].center = self.centerOfCard
                    
                    // ユーザーカードの角度を戻す
                    self.personList[self.selectedCardCount].transform = .identity

                    self.likeImage.isHidden = true
                    
                })
                
            }
        }
        
        
        
        
    }
    
    // badボタン
    @IBAction func dislikedButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            // X座標を左に500とばす(-500) = 大きく飛ばす
            self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x - 500, y :self.personList[self.selectedCardCount].center.y)
            
            // ベースカードの距離と角度を戻すメソッド。ユーザーカードだけ飛ばす
            self.resetCard()
            
            
        })
        
        // 次のカードへ行く処理
        selectedCardCount += 1
        // カードの数が用意された人より多くなったときに遷移する
        if selectedCardCount >= personList.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
        return
    }
    
    // いいねボタン
    @IBAction func likedButtonTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, animations: {
            // X座標を右に500とばす(+500)
            self.personList[self.selectedCardCount].center = CGPoint(x: self.personList[self.selectedCardCount].center.x + 500, y :self.personList[self.selectedCardCount].center.y)
            
            self.resetCard()
            
            
        })
        
        // いいねした人の名前を配列に追加。カウントする前に入れなければ次の人の名前が入る
        likedName.append(nameList[selectedCardCount])
        selectedCardCount += 1
        
        
        if selectedCardCount >= personList.count {
            performSegue(withIdentifier: "ToLikedList", sender: self)
        }
        return
    }
    
    
    
    

}

