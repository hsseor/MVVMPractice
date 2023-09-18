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
    private let tvNetwork: TVNetwork
    private let movieNetwork: MovieNetwork
    
    init() {
        let provider = NetworkProvider()
        tvNetwork = provider.makeTVNetwork()
        movieNetwork = provider.makeMovieNetwork()
    }

    //viewcontroller에서 발생하는 이벤트들. 버튼 클릭 이벤트들
    struct Input{
        let tvTrigger : Observable<Void>
        let movieTrigger : Observable<Void>
    }
    //네트워크를 통해 얻어지는 데이터 형태들
    struct Output {
        let tvList: Observable<[TV]>
        let movieResult: Observable<MovieResult>
    }
    //무비트리거에 대한 일련의 구독과정을 구현& 결과값에 대한 observable에 대한 아웃풋을 생성해서 return
    //⭐️3⭐️해당 트리거를 보고있다가 trigger 를 print.
    func transform(input: Input) -> Output {
        
        //trigger 발동-> 네트워킹 시도 -> 네트워크가 리턴하는 Observable<T> 타입 리턴(ex. MovieListModel,TVListModel) -> 해당 타입을 뷰컨에 전달 -> 뷰컨에서 구독
    
//        input.tvTrigger.bind {
//            print("Trigger")
//        }.disposed(by: disposeBag)
        
        //tvTrigger는 현재 Observable<Void>. 다른 observable로 전환-> observable<[TV]>. 이것이 우리가 필요한 것.
        //=>flatMapLatest 사용. tvlist를 담은 Observable retype 하기
        let tvList = input.tvTrigger.flatMapLatest { [unowned self] _ -> Observable<[TV]> in
            //TVListModel에서 page는 필요x. observable<[TVListModel]> -> observable<[TV]> 로 전환을 위해 map 사용
            self.tvNetwork.getTopRatedList().map{ $0.results }
        }
        //weak -> self 가 optional.(? 필요) / unowned -> self 가 optional X
        
        //movieResult를 observable에 담아서 return
        let movieResult = input.movieTrigger.flatMapLatest { [unowned self] _ -> Observable<MovieResult> in
            //combineLatest -> 합친 것들 중, 하나의 특정한 observable return 가능
            //Observable 1,2,3 을 합쳐서 하나의 Observable로 바꾸고 싶을때 combineLatest 사용
            //모든 Observable에서 return이 발생해야 해당 클로져가 발동.
           return Observable.combineLatest(self.movieNetwork.getUpcomingList(), self.movieNetwork.getPopularList(), self.movieNetwork.getNowPlayingList()){upcoming, popular,nowPlaying -> MovieResult in
                return MovieResult(upcoming: upcoming, popular: popular, nowPlaying: nowPlaying)
            }
        }
    
        //retype한 tvlist를 담아서 return
        return Output(tvList: tvList, movieResult: movieResult)
        
    }
}
