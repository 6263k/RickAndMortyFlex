//
//  EpisodeDetailViewController.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 18.04.2021.
//

import RxSwift
import RxCocoa

final class EpisodeDetailViewController: BaseViewController<EpisodeDetailViewModel> {
	
	typealias DataSource =  UICollectionViewDiffableDataSource<Section, BaseCellModel>
	typealias Snapshot = NSDiffableDataSourceSnapshot<Section, BaseCellModel>
	enum Section: Int {
		case episodeHeader
		case charactersInEpisode
		
		var sectionName: String {
			switch self {
				case .episodeHeader: return "Episode"
				case .charactersInEpisode: return "Characters"
			}
		}
	}
	
	@IBOutlet private weak var collectionView: UICollectionView!
	
	private var dataSource: DataSource!
	private let disposeBag = DisposeBag()
	
	
	override func viewDidLoad() {
		createDataSource()
		self.navigationItem.setCustomTitle(text: "Episode details")
		super.viewDidLoad()
	}
	
	
	private func createDataSource() {
		dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, cellModel) -> UICollectionViewCell? in
			
			let nib = UINib(nibName: cellModel.cellIdentifier, bundle: Bundle.main)
			collectionView.register(nib, forCellWithReuseIdentifier: cellModel.cellIdentifier)
			
			
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellModel.cellIdentifier, for: indexPath) as? BaseCollectionViewCell else { fatalError() }
			
			cell.configure(with: cellModel)
			return cell
		})
		dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
			
			let nib = UINib(nibName: EpisodeReusableHeader.reuseIdentifier, bundle: .main)
			collectionView.register(nib, forSupplementaryViewOfKind: EpisodeReusableHeader.kind, withReuseIdentifier: EpisodeReusableHeader.reuseIdentifier)
			
			guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EpisodeReusableHeader.reuseIdentifier, for: indexPath) as? EpisodeReusableHeader else { fatalError() }
			
			headerView.configure(with: Section(rawValue: indexPath.section)?.sectionName ?? "")
			return headerView
		}
	}
	
	
	override func setupStyle() {
		collectionView.backgroundColor = .rmCyan
		collectionView.collectionViewLayout = setupCompositionalLayout()
	}
	
	override func setupRx() {
		viewModel.snapshot
			.subscribe(onNext: { [weak self] in
				self?.dataSource.apply($0, animatingDifferences: false, completion: nil)
			})
			.disposed(by: disposeBag)
	}
}


extension EpisodeDetailViewController {
	private func setupCompositionalLayout() -> UICollectionViewCompositionalLayout {
		let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			
			guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
			switch sectionKind {
				case .episodeHeader:
					return self?.locationInfoLayout()
				case .charactersInEpisode:
					return self?.charactersInLocationLayout()
			}
		}
		return layout
	}
	
	private func locationInfoLayout() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					heightDimension: .fractionalHeight(1.0))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					 heightDimension: .fractionalHeight(1/3))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
		group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
		return NSCollectionLayoutSection(group: group)
	}
	
	private func charactersInLocationLayout() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					heightDimension: .fractionalHeight(1.0))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					 heightDimension: .fractionalHeight(1/4))
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
		
		let headerView = NSCollectionLayoutBoundarySupplementaryItem(
			layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																				 heightDimension: .estimated(88)),
			elementKind: EpisodeReusableHeader.kind,
			alignment: .top )
		
		let section = NSCollectionLayoutSection(group: group)
		section.boundarySupplementaryItems = [headerView]
		return section
	}
	
}

