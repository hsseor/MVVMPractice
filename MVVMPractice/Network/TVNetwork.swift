//
//  TVNetwork.swift
//  MVVMPractice
//
//  Created by 홍서린 on 2023/09/13.
//

import Foundation
import RxSwift

//더 이상 상속받을 필요 없음  -> final class
final class TVNetwork {
    //tvlistmodel을 generic타입으로 갖고있는 네트워크
    private let network: Network<TVListModel>
    
    //위의 네트워크를 init함수를 통해 주입
    init(network: Network<TVListModel>){
        self.network = network
    }

    func getTopRatedList() -> Observable<TVListModel> {
        return network.getItemList(path: "/tv/top_rated")
    }
}

//endpoint = "https://api.themoviedb.org/3\(path)" cf. path =/tv/top_rated
