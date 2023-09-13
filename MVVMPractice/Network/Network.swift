//
//  Network.swift
//  MVVMPractice
//
//  Created by 홍서린 on 2023/09/12.
//

import Foundation
import RxSwift
import RxAlamofire

//(1) 네트워크를 생성할 때 지정했던 T타입(=디코더블한 movie, tv list)
class Network <T:Decodable> {
    
    private let endpoint: String
    //데이터 패칭하는 과정에서 사용할 global Queue
    private let queue: ConcurrentDispatchQueueScheduler
    
    //endpoint는 공통적으로 계속 쓰기때문에 Init할 때 받아오도록 함.이게 아니라 그냥 주소 고정값으로 넣어도 됨.
    init(_ endpoint: String){
        self.endpoint = endpoint
        //백그라운드 큐 생성
        self.queue = ConcurrentDispatchQueueScheduler(qos: .background)
    }
    //해당 큐 안에서 패칭 작업이 이루어지도록 함 , 주소에서 계속 바뀌는 부분 ex /movie/popular와 같은 걸 path로 받아옴
    func getItemList(path: String) -> Observable<T> {
        let fullPath = "\(endpoint)\(path)?api_key=\(APIKEY)&language=ko"
        
        //(3)해당 디코딩된 값들을 옵저버블한 형태로 리턴하면 제너릭한 네트워크 설정 완료.
        return RxAlamofire.data(.get, fullPath)
        //observe아래에 진행되는 작업들이 해당 큐(백그라운드 큐)를 사용하여 진행됨
            .observe(on: queue)
        //데이터를 요청하고 받아오는 과정들이 콘솔에 찍히게 됨.
            .debug()
        //받아온 데이터를 가지고 디코딩.
        //(2) list들이 디코더블한 상태기 때문에 디코딩가능->해당 데이터를 해당 타입으로 변환가능.
            .map{data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
}
