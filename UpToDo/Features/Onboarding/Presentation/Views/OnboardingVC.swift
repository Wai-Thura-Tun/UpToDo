//
//  OnboardingVC.swift
//  UpToDo
//
//  Created by Wai Thura Tun on 5/12/2568 BE.
//

import UIKit

class OnboardingVC: UIViewController, Storyboarded {

    @IBOutlet weak var cvOnboarding: UICollectionView!
    @IBOutlet weak var pgcOnboarding: UIPageControl!
    @IBOutlet weak var viewBtnBack: UIView!
    @IBOutlet weak var viewBtnNext: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    weak var coordinator: AppCoordinator?
    
    private var vm: OnboardingVM!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Onboarding>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(self.vm != nil, "VM must be configure before viewDidLoad")
        
        setupViews()
        setupDataSource()
        createLayout()
        setupBindings()
        self.vm.getData()
    }

    private func setupViews() {
        self.cvOnboarding.delegate = self
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "SKIP",
            style: .plain,
            target: self,
            action: #selector(onTapSkip)
        )
        
        pgcOnboarding.pageIndicatorTintColor = .systemGray2
        pgcOnboarding.currentPageIndicatorTintColor = .label
        
        let edgeInsets: NSDirectionalEdgeInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        btnNext.backgroundColor = .primary
        btnNext.tintColor = .white
        btnNext.configuration?.contentInsets = edgeInsets
        btnNext.titleLabel?.font = .popR16
        btnBack.titleLabel?.font = .popR16
        btnBack.tintColor = .systemGray
        btnBack.isEnabled = false
    }
    
    private func setupBindings() {
        self.btnBack.addTarget(self, action: #selector(onTapBack), for: .touchUpInside)
        self.btnNext.addTarget(self, action: #selector(onTapNext), for: .touchUpInside)
    }
    
    func configure(with vm: OnboardingVM) {
        self.vm = vm
        self.vm.delegate = self
    }
    
    private func setupDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Int, Onboarding>(collectionView: cvOnboarding) { collectionView, indexPath, onboarding in
            let cell: OnboardingCell = self.cvOnboarding.dequeueCell(indexPath: indexPath)
            cell.data = onboarding
            return cell
        }
        
        self.cvOnboarding.registerCell(OnboardingCell.self)
    }
    
    private func createLayout() {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) in
            let currentPage: Int = Int(offset.x / (self?.cvOnboarding.frame.width ?? 1))
            self?.pgcOnboarding.currentPage = currentPage
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        self.cvOnboarding.collectionViewLayout = layout
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Onboarding>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.vm.data, toSection: 0)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func onTapSkip() {
        
    }
    
    @objc private func onTapNext() {
        let max: Int = self.vm.data.count - 1
        let current: Int = self.pgcOnboarding.currentPage
        if current < max {
            
        }
    }
    
    @objc private func onTapBack() {
        
    }
}

extension OnboardingVC: OnboardingViewDelegate {
    func readyToUpdateSnapshot() {
        self.updateSnapshot()
    }
}

extension OnboardingVC: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("did scroll")
    }
}
