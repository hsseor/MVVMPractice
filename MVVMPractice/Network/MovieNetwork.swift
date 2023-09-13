//
//  MovieNetwork.swift
//  MVVMPractice
//
//  Created by 홍서린 on 2023/09/13.
//

import Foundation
import RxSwift

//더 이상 상속받을 필요 없음  -> final class
final class MovieNetwork {
    //tvlistmodel을 generic타입으로 갖고있는 네트워크
    private let network: Network<MovieListModel>
    
    //위의 네트워크를 init함수를 통해 주입
    init(network: Network<MovieListModel>){
        self.network = network
    }
    
    //tv에서는 toprate만 받아올거고 movie에서는 3개 받아올거여서 3개 다 받아와주기
    func getNowPlayingList() -> Observable<MovieListModel> {
        return network.getItemList(path: "/movie/now_playing")
    }
    func getPopularList() -> Observable<MovieListModel> {
        return network.getItemList(path: "/movie/popular")
    }
    func getUpcomingList() -> Observable<MovieListModel> {
        return network.getItemList(path: "/movie/upcoming")
    }
}

//endpoint = "https://api.themoviedb.org/3\(path)" cf. path =/movie/top_rated
