//
//  ViewController.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.03.2021.
//

import RxSwift
import RxCocoa



class LocationFeedViewController: BaseViewController<LocationFeedViewModel> {
	typealias DataSource =  UICollectionViewDiffableDataSource<Section, BaseCellModel>
	typealias Snapshot = NSDiffableDataSourceSnapshot<Section, BaseCellModel>
	
	enum Section: Int {
		case locationFeed
		case loadingCell
	}
	
	@IBOutlet private weak var collectionView: UICollectionView!
	private let searchController = UISearchController(searchResultsController: nil)
	private var dataSource: DataSource!
	private let disposeBag = DisposeBag()
	
	
	override func viewDidLoad() {
		createDataSource()
		super.viewDidLoad()
	}
	
	override func setupStyle() {
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search location by name"
		searchController.hidesNavigationBarDuringPresentation = true
		definesPresentationContext = true
		searchController.isActive = false
		
		self.navigationItem.searchController = searchController
		self.navigationItem.setCustomTitle(text: "Locations")
		collectionView.collectionViewLayout = generateCompositionalLayout()
		
	}
	
	private func createDataSource() {
		dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, cellModel) -> UICollectionViewCell? in
			
			let nib = UINib(nibName: cellModel.cellIdentifier, bundle: Bundle.main)
			collectionView.register(nib, forCellWithReuseIdentifier: cellModel.cellIdentifier)
			
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellModel.cellIdentifier, for: indexPath) as? BaseCollectionViewCell else {fatalError()}
			
			cell.configure(with: cellModel)
			return cell
		})
	}
	
	private func generateCompositionalLayout() -> UICollectionViewCompositionalLayout {
		
		let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			
			guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
			switch sectionKind {
				case .locationFeed:
					return self?.locationFeedLayout()
				case .loadingCell:
					return self?.loadingCellLayout()
			}
		}
		return layout
	}
	
	private func locationFeedLayout() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					heightDimension: .fractionalHeight(1.0))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					 heightDimension: .fractionalHeight(1/4))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
		
		return NSCollectionLayoutSection(group: group)
	}
	
	private func loadingCellLayout() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1.0),
																					heightDimension: .fractionalHeight(1.0))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
																					 heightDimension: .fractionalHeight(1/8))
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
		return NSCollectionLayoutSection(group: group)
	}
	
	override func setupRx() {
		
		viewModel.snapshot
			.asDriver()
			.drive(onNext: {[weak self] in
				self?.dataSource.apply($0, animatingDifferences: false, completion: nil)
			})
			.disposed(by: disposeBag)
		
		collectionView.rx.contentOffset
			.map { [weak self] offset -> Bool in
				self?.collectionView.isNearBottomEdge(edgeOffset: 20.0) ?? false
			}
			.filter { $0 }
			.subscribe(onNext: { [weak self] _ in
				self?.viewModel.loadMoreData()
			})
			.disposed(by: disposeBag)
		
		searchController.searchBar.rx.text
			.orEmpty
			.bind(to: viewModel.searchText)
			.disposed(by: disposeBag)
		
	}
}

