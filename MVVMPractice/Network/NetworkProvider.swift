//
//  NetworkProvider.swift
//  MVVMPractice
//
//  Created by 홍서린 on 2023/09/13.
//

import Foundation

//어떤 네트워크든지 생성할 수 있는 class. 세분화한 네트워크를 생성(TVNetwork,MovieNetwork)
//viewModel에서 해당 networkprovider를 가지고 해당 네트워크를 생성 후에 사용할 것임.
final class NetworkProvider{
    private let endpoint: String
    init() {
        self.endpoint = "https://api.themoviedb.org/3"
    }
    
    //아까 만들었던 TVNetwork 인스턴스 생성
    func makeTVNetwork() ->  TVNetwork{
        //Network에서 init함수를 타게 됨. Network에서 내부 파라미터 endpoint를 받아올때 이게 쓰임.
        //제너릭한 T타입은 TVListModel 이라고 지정.tvlist를 fetch할 수 있는 네트워크가 됨.
        let network = Network<TVListModel>(endpoint)
        return TVNetwork(network: network)
    }
    func makeMovieNetwork() ->  MovieNetwork{
        let network = Network<MovieListModel>(endpoint)
        return MovieNetwork(network: network)
    }
    
}
