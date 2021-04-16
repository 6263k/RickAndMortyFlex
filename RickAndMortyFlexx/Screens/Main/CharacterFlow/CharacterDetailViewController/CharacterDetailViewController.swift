//
//  CharacterDetailViewController.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 08.04.2021.
//

import RxSwift
import RxCocoa
import RxDataSources

final class CharacterDetailViewController: BaseViewController<CharacterDetailViewModel> {
	
	typealias DataSource =  UICollectionViewDiffableDataSource<Section, BaseCellModel>
	typealias Snapshot = NSDiffableDataSourceSnapshot<Section, BaseCellModel>
	enum Section: Int {
		case characterDetail
		case episodes
		
		var sectionName: String {
			switch self {
				case .episodes: return "Episodes"
				case .characterDetail: return "Character detail"
			}
		}
	}
	
	@IBOutlet private weak var collectionView: UICollectionView!
	
	private var dataSource: DataSource!
	private let disposeBag = DisposeBag()
	
	
	override func viewDidLoad() {
		createDataSource()
		self.navigationItem.setCustomTitle(text: "Character details")
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


extension CharacterDetailViewController {
	private func setupCompositionalLayout() -> UICollectionViewCompositionalLayout {
		let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			
			guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
			switch sectionKind {
				case .characterDetail:
					return self?.characterDetailLayout()
				case .episodes:
					return self?.episodeLayout()
			}
		}
		return layout
	}
	
	private func characterDetailLayout() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																				heightDimension: .fractionalHeight(1.0))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					 heightDimension: .fractionalHeight(1.0))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
		
		return NSCollectionLayoutSection(group: group)
	}
	
	private func episodeLayout() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					heightDimension: .fractionalHeight(1.0))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
																					 heightDimension: .fractionalHeight(1/5))
		
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

