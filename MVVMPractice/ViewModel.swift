//
//  ViewModel.swift
//  MVVMPractice
//
//  Created by 홍서린 on 2023/09/18.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    let disposeBag = DisposeBag()

    //viewcontroller에서 발생하는 이벤트들. 버튼 클릭 이벤트들
    struct Input{
        let tvTrigger : Observable<Void>
        let movieTrigger : Observable<Void>
    }
    //네트워크를 통해 얻어지는 데이터 형태들
    struct Output {
        let tvList: Observable<[TV]>
      //  let movieList: Observable<MovieResult>
    }
    //무비트리거에 대한 일련의 구독과정을 구현& 결과값에 대한 observable에 대한 아웃풋을 생성해서 return
    //⭐️3⭐️해당 트리거를 보고있다가 trigger 를 print.
    func transform(input: Input) -> Output {
        input.tvTrigger.bind {
            print("Trigger")
        }.disposed(by: disposeBag)
        
        input.movieTrigger.bind{
            print("MOVIE Trigger")
        }disposed(by: disposeBag)
        
        //transform 을 위해서는 네트워킹 구현 완료가 선행돼야해서 일단 빈 아웃풋 리턴
        return Output(tvList: Observable<[TV]>.just([]))
        
    }
}
