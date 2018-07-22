//
//  ViewController.swift
//  MyMap
//
//  Created by ymgn on 2018/07/22.
//  Copyright © 2018年 ymgn. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // TextFieldのDelegate通知先を設定
        inputText.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var inputText: UITextField!
    
    @IBOutlet weak var dispMap: MKMapView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる(1)
        textField.resignFirstResponder()
        
        // 入力された文字を取り出す(2)
        if let searchKey = textField.text {
            
            // 入力された文字をデバッグエリアに表示(3)
            print(searchKey)
            
            // CLGeocoderインスタンスを取得(5)
            let geocoder = CLGeocoder()
            
            // 入力された文字から位置情報を取得(6)
            geocoder.geocodeAddressString(searchKey, completionHandler: { (placemarks, error) in
                
                // 位置情報が存在する場合はunwrapPlacemarksに取り出す(7)
                if let unwrapPlacemarks = placemarks {
                    
                    // 1件目の情報を取り出す(8)
                    if let firstPlacemark = unwrapPlacemarks.first {
                        
                        // 位置情報を取り出す(9)
                        if let location = firstPlacemark.location {
                            
                            // 位置情報から緯度経度をtergetCoordinateに取り出す(10)
                            let tergetCoordinate = location.coordinate
                            
                            // 緯度経度をデバックエリアに表示(11)
                            print(tergetCoordinate)
                            
                            // MKPointAnnotationインスタンスを取得し、ピンを生成(12)
                            let pin = MKPointAnnotation()
                            
                            // ピンの置く場所に緯度経度を設定(13)
                            pin.coordinate = tergetCoordinate
                            
                            // ピンのタイトルを設定(14)
                            pin.title = searchKey
                            
                            // ピンを地図に置く(15)
                            self.dispMap.addAnnotation(pin)
                            
                            // 緯度経度を中心にして半径500mの範囲を表示(16)
                            self.dispMap.region = MKCoordinateRegionMakeWithDistance(tergetCoordinate, 500.0, 500.0)
                        }
                    }
                }
            })
        }
        
        // デフォルト動作を行うのでtrueを返す(4)
        return true
    }
    @IBAction func changeMapButtonAction(_ sender: Any) {
        // mapTypeプロパティ値をトグル
        // 標準(.standard) → 航空写真(.satellite) → 航空写真+標準(.hybrid)
        // → 3D Flyover(.satelliteFlyover) → 3D Flyover+標準(.hybridFlyover)
        if dispMap.mapType == .standard {
            dispMap.mapType = .satellite
        } else if dispMap.mapType == .satellite {
            dispMap.mapType = .hybrid
        } else if dispMap.mapType == .hybrid {
            dispMap.mapType = .satelliteFlyover
        } else if dispMap.mapType == .satelliteFlyover {
            dispMap.mapType = .hybridFlyover
        } else {
            dispMap.mapType = .standard
        }
    }
    
}

