//
//  PJHomeViewController.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/12.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

class PJHomeViewController: UIViewController, PJHomeBottomViewDelegate {

    var mapView: PJHomeMapView?
    var bottomView: PJHomeBottomView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if bottomView?.stackView?.alpha == 0 {
            UIView.animate(withDuration: 0.25) {
                self.bottomView?.stackView?.alpha = 1
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initView() {
        mapView = PJHomeMapView.init(frame: CGRect(x: 0, y: 0, width: PJSCREEN_WIDTH, height: PJSCREEN_HEIGHT))
        view.addSubview(mapView!)
        
        bottomView = PJHomeBottomView.init(frame: CGRect(x: -PJSCREEN_WIDTH * 0.1, y: PJSCREEN_HEIGHT - 120, width: PJSCREEN_WIDTH * 1.2, height: 160))
        bottomView?.viewDelegate = self
        view.addSubview(bottomView!)
    }
    
    func homeBottomViewPlacesBtnClick(view: PJHomeBottomView) {
        UIView.animate(withDuration: 0.25, animations: {
            self.bottomView?.stackView?.alpha = 0
        }) { (finished) in
            if finished {
                self.present(PJPlacesViewController(), animated: true, completion: nil)
            }
        }
    }
    
    
    func homeBottomViewTapBtnClick(view: PJHomeBottomView, tapBtn: UIButton) {
        PJTapic.tap()
        UIView.animate(withDuration: 0.15, animations: {
            tapBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 0.15, animations: {
                    tapBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
                }) {(finished) in
                    if finished {
                        let point = self.mapView?.mapView.convert((self.mapView?.mapView.userLocation.location.coordinate)!, toPointTo: self.mapView)
                        print(point as Any)
                        let tempTapImageView = UIImageView(image: UIImage(named: "home_tap"))
                        tempTapImageView.frame.size = CGSize(width: 50, height: 50)
                        tempTapImageView.centerX = view.centerX
                        tempTapImageView.bottom = (self.bottomView?.bottom)!
                        self.view.addSubview(tempTapImageView)
                        UIView.animate(withDuration: 0.25, animations: {
                            tempTapImageView.center = point!
                        }) {(finished) in
                            if finished {
                                UIView.animate(withDuration: 0.5, animations: {
                                    tempTapImageView.alpha = 0
                                }, completion: { (finished) in
                                    if finished {
                                        tempTapImageView.removeFromSuperview()
                                        
                                        
                                        // TODE: 这有问题，加的大头针样式不对
                                        let pointAnnotation = MAPointAnnotation()
                                        pointAnnotation.coordinate = (self.mapView?.mapView.userLocation.location.coordinate)!
                                        
                                        self.mapView?.mapView.addAnnotation(pointAnnotation)
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
