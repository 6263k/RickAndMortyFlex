//
//  DiffDataSource+.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 10.04.2021.
//

import RxSwift

//extension Reactive where Base: CharacterFeedViewController.DataSource {
//	var snapshot: Binder<CharacterFeedViewController.Snapshot> {
//		return Binder(self.base) { (dataSource, snapshot) in
//			dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
//		}
//	}
//	
//}

extension Reactive where Base: UICollectionViewDiffableDataSource<BaseViewController<BaseViewModel>.Section, BaseCellModel> {
	var snapshot: Binder<NSDiffableDataSourceSnapshot<BaseViewController<BaseViewModel>.Section, BaseCellModel>> {
		return Binder(self.base) { dataSource, snapshot in
			dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
		}
	}
}


