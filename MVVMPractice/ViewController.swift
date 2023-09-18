//
//  ViewController.swift
//  MVVMPractice
//
//  Created by 홍서린 on 2023/09/12.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let buttonView = ButtonView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        self.view.addSubview(buttonView)
        self.view.addSubview(collectionView)
        
        collectionView.backgroundColor = .blue
        
        buttonView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(buttonView.snp.bottom)
        }

    }

}

/*
 Kingfisher(이미지 쉽게 다루기/ downloading & caching images)
 SnapKit (제약조건 설정 시 코드 줄이기)
 Rxswift (버튼 클릭 등의 이벤트 처리)
 RxAlamofire
 */
