//
//  TV.swift
//  MVVMPractice
//
//  Created by 홍서린 on 2023/09/12.
//

import Foundation

//상위 모델링
struct TVListModel: Decodable {
    let page: Int
    let results: [TV]
}

struct TV: Decodable, Hashable{
    let name: String
    let overview: String
    let posterURL: String
    let vote: String
    let firstAirDate: String
    
    //api에서 명시된 이름과 다르면 자동으로 인코딩 되지 않기때문에 아래와 같이 명시를 해줘야함. ""안에 있는 게 api에서 명시한 이름
    private enum CodingKeys: String, CodingKey{
        case name
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
    }
    
    //해당 codingkey를 통해 받아온 데이터를 꺼내서 다시 init.
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)//서버로부터 받아온 데이터를 컨테이너에 담아서 꺼내씀.
        name = try container.decode(String.self, forKey: .name) //서버에서 name을 string형태로 받아옴->name변수에 담아서 init
        overview = try container.decode(String.self, forKey: .overview)
        let path = try container.decode(String.self, forKey: .posterPath)
        posterURL = "https://image.tmdb.org/t/p/w500\(path)"
        let voteAverage = try container.decode(Float.self, forKey: .voteAverage)
        let voteCount = try container.decode(Int.self, forKey: .voteCount)
        vote = "\(voteAverage) (\(voteCount))" //ex) 화면에 4.5 (170) 형태로 표시됨
        firstAirDate = try container.decode(String.self, forKey: .firstAirDate)
    }
}
