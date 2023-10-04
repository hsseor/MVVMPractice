//
//  ViewController.swift
//  MVVMPractice
//
//  Created by 홍서린 on 2023/09/12.
//

import UIKit
import SnapKit
import RxSwift

//section은 하나의 레이아웃을 구현할 때를 기준으로 나눈다.
enum Section: Hashable {
    //(TV)하나의 행에 두 개의 셀이 들어가기 때문에 double로 명명.
    case double
}

//Item은 Cell을 기준으로 나눈다. 해당 레이아웃에 어떤 Item을 쓸 지(이 item을 쓸 거다 = 이 Cell을 쓸 거다)
enum Item : Hashable{
    case normal(TV)
}

//ViewController는 Buttonview에서 일어나는 이벤트를 구독하면서도 전달해야함
class ViewController: UIViewController {
    //해당 뷰컨이 메모리에서 해제가 될 때 구독도 해제
    let disposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<Section,Item>?
    let buttonView = ButtonView()
    
    //NormalCollectionViewCell을 등록
    //lazy로 정의해야 안에 self 사용 가능
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.register(NormalCollectionViewCell.self, forCellWithReuseIdentifier: NormalCollectionViewCell.id)
        return collectionView
    }()

    let viewModel = ViewModel()
    //Subject - 이벤트를 발생시키면서 observable형태도 되는 거. 이걸통해(1)
    let tvTrigger = PublishSubject<Void>()
    let movieTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDataSource()
        bindViewModel()
        bindView()
        tvTrigger.onNext(()) //아무것도 누르지 않아도 tv 데이터가 화면에 뜸
        
        //ex. (3)onNext를 통해서 이벤트 전달가능,구독
        //tvTrigger.onNext(Void())
        
    }
    
    private func setUI() {
        self.view.addSubview(buttonView)
        self.view.addSubview(collectionView)

        buttonView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(buttonView.snp.bottom)
        }

    }
    
    private func bindViewModel(){
        //(2)tvTrigger를 asObservable로 전달가능
        let input = ViewModel.Input(tvTrigger: tvTrigger.asObservable(), movieTrigger: movieTrigger.asObservable())
        
        //여기서 받아야할 타입은 observable.이 안에서 observable을 전이하면 버튼에서도 발생하는 이벤트를 구독해서 보내줄 수 없어서. subject사용
        //⭐️2⭐️발생했을 때 이걸 보고 있던 viewModel이 viewModel에서 보낸 output 을 받아서 print
        let output = viewModel.transform(input: input)
        
        output.tvList.bind { tvList in
            print("TV List \(tvList)")
            var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
            let items = tvList.map { Item.normal($0)}
            let section = Section.double
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
            self.dataSource?.apply(snapshot)
        }.disposed(by: disposeBag)
        
        output.movieResult.bind { MovieResult in
            print("Movie List \(MovieResult)")
        }.disposed(by: disposeBag)
        
    }
    
    //tv버튼을 눌렀을 때 tvtrigger가 이벤트를 발생시키도록 함⭐️1⭐️
    private func bindView() {
        //bind는 escaping 클로저 이기 때문에 weak self & self 참조
        buttonView.tvButton.rx.tap.bind { [weak self] in
            self?.tvTrigger.onNext(Void())
        }.disposed(by: disposeBag)
        
        buttonView.movieButton.rx.tap.bind { [weak self] in
            self?.movieTrigger.onNext(Void())
        }.disposed(by: disposeBag)
    }

    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        //section간의 마진 설정
        config.interSectionSpacing = 14
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            return self?.createDoubleSection()
        }, configuration: config)
    }
    private func createDoubleSection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 8, trailing: 4)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, IndexPath, item in
            switch item {
            case .normal(let tvData):
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCollectionViewCell.id, for: IndexPath) as? NormalCollectionViewCell
                cell?.configure(title: tvData.name, review: tvData.vote, desc: tvData.overview, imageURL: tvData.posterURL)
                return cell
                
            }
        })
    }
}

/*
 Kingfisher(이미지 쉽게 다루기/ downloading & caching images)
 SnapKit (제약조건 설정 시 코드 줄이기)
 Rxswift (버튼 클릭 등의 이벤트 처리)
 RxAlamofire
 */
