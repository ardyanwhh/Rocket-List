//
//  DetailViewController.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 15/02/23.
//

import UIKit
import Combine
import SnapKit

class DetailViewController: UIViewController {
    
    private let viewModel = DetailViewModel()
    private var cancellableBag = Set<AnyCancellable>()
    
    private let backgroundIV = UIImageView()
    private let backButton = BackButton()
    private let navbarTitleLabel = UILabel()
    private let contentIV = UIImageView()
    private let spinner = UIActivityIndicatorView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let separatorView = UIView()
    private let loadingView = LoadingView()
    private let timeoutView = DetailTimeoutView()
    
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: flowLayout
    )
    
    private lazy var navbarView: UIView = {
        let view = UIView()
        
        [backButton, navbarTitleLabel].forEach {
            view.addSubview($0)
        }
        
        backButton.setCallback {
            self.navigationController?.popViewController(animated: true)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.leading.equalTo(view).offset(Spaces.mediumLarge)
            make.size.equalTo(40)
        }
        
        navbarTitleLabel.alpha = 0
        navbarTitleLabel.font = Fonts.medium(size: FontSize.body)
        navbarTitleLabel.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        
        return view
    }()
    
    private lazy var contentIVView: UIView = {
        let view = UIView()
        
        [spinner, contentIV].forEach {
            view.addSubview($0)
        }
        
        spinner.color = .black.withAlphaComponent(0.5)
        spinner.startAnimating()
        spinner.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        
        contentIV.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.size.equalTo(80)
        }
        
        view.layer.cornerRadius = CornerSize.conate
        
        return view
    }()
    
    private lazy var pinchView: UIView = {
        let view = UIView()
        
        let pinch = UIView()
        
        view.addSubview(pinch)
        
        pinch.backgroundColor = .accent.withAlphaComponent(0.1)
        pinch.layer.cornerRadius = 4
        pinch.snp.makeConstraints { make in
            make.top.equalTo(view).offset(Spaces.conate)
            make.centerX.equalTo(view)
            make.width.equalTo(50)
            make.height.equalTo(8)
        }
        
        view.addGestureRecognizer(UIPanGestureRecognizer(
            target: self, action: #selector(onPan(_:))
        ))
        
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        [pinchView, collectionView].forEach {
            view.addSubview($0)
        }
        
        pinchView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.height.equalTo(WidgetSize.rectangleHeight)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(
            DetailCell.self,
            forCellWithReuseIdentifier: "\(DetailCell.self)"
        )
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(pinchView.snp_bottomMargin)
            make.leading.bottom.trailing.equalTo(view)
        }
        
        view.layer.cornerRadius = CornerSize.medium
        
        return view
    }()
    
    private var contentViewHeightAnchor: NSLayoutConstraint?
    
    init(id: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.id = id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        [
            backgroundIV, navbarView, contentIVView,
            titleLabel, subtitleLabel, contentView,
            separatorView, loadingView, timeoutView
        ].forEach {
            view.addSubview($0)
        }
        
        backgroundIV.image = .init(named: Assets.imgBackgroundDetail)
        backgroundIV.contentMode = .scaleAspectFill
        backgroundIV.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
        
        navbarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(64)
        }
        
        contentIVView.snp.makeConstraints { make in
            make.top.equalTo(navbarView.snp_bottomMargin)
                .offset(Spaces.medium)
            make.centerX.equalTo(view)
            make.size.equalTo(150)
        }
        
        titleLabel.font = Fonts.semiBold(size: FontSize.title)
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(Spaces.mediumLarge)
            make.top.equalTo(contentIVView.snp_bottomMargin)
                .offset(Spaces.largest)
        }
        
        subtitleLabel.font = Fonts.medium(size: FontSize.subheadline)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin)
                .offset(Spaces.small)
            make.horizontalEdges.equalTo(view).inset(Spaces.mediumLarge)
        }
        
        [navbarTitleLabel, titleLabel, subtitleLabel].forEach {
            $0.textColor = .white
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowRadius = 10
            $0.layer.shadowOpacity = 1
        }
        
        viewModel.defaultContentHeight = view.frame.height - (WidgetSize.topSafeArea ?? 0)
        - (WidgetSize.bottomSafeArea ?? 0) - 310
        viewModel.savedContentHeight = view.frame.height - (WidgetSize.topSafeArea ?? 0)
        - (WidgetSize.bottomSafeArea ?? 0) - 310
        viewModel.maxContentHeight = view.frame.height - (WidgetSize.topSafeArea ?? 0) - 64
        
        contentView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view)
        }
        
        contentViewHeightAnchor = contentView.heightAnchor.constraint(
            equalToConstant: viewModel.defaultContentHeight
        )
        
        contentViewHeightAnchor?.isActive = true
        
        [contentIVView, contentView].forEach {
            $0.backgroundColor = .white
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowRadius = 10
            $0.layer.shadowOpacity = 0.25
        }
        
        separatorView.backgroundColor = .black.withAlphaComponent(0.75)
        separatorView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
        
        loadingView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.size.equalTo(76)
        }
        
        timeoutView.alpha = 0
        timeoutView.setCallback {
            self.viewModel.dispose()
            self.viewModel.fetch()
        }
        
        timeoutView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.height.equalTo(76)
            make.width.equalTo(200)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.dispose()
        viewModel.fetch()
        
        viewModel.$status.sink { status in
            if status == .success {
                self.setViews()
            }
            
            UIView.animate(withDuration: 0.25) {
                self.loadingView.alpha = status == .loading ? 1 : 0
            }
            
            UIView.animate(withDuration: 0.25) {
                self.timeoutView.alpha = status == .timeout ? 1 : 0
            }
        }.store(in: &cancellableBag)
    }
    
    @objc private func onPan(_ gesture: UIPanGestureRecognizer) {
        let velocity = gesture.translation(in: pinchView).y
        let newHeight = viewModel.savedContentHeight - velocity
        let bottoming = velocity >= 0
        
        if gesture.state == .changed {
            view.endEditing(true)
            
            if newHeight < viewModel.maxContentHeight {
                contentViewHeightAnchor?.constant = newHeight
                contentView.layoutIfNeeded()
            }
            
            UIView.animate(withDuration: 0.25) {
                self.navbarTitleLabel.alpha = bottoming ? 0 : 1
                self.titleLabel.alpha = bottoming ? 1 : 0
                self.subtitleLabel.alpha = bottoming ? 1 : 0
            }
        } else if gesture.state == .ended {
            animatePanGesture(bottoming: bottoming)
        }
    }
    
    private func animatePanGesture(bottoming: Bool) {
        UIView.animate(
            withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn
        ) {
            if bottoming {
                self.contentViewHeightAnchor?.constant = self.viewModel.defaultContentHeight
                self.viewModel.savedContentHeight = self.viewModel.defaultContentHeight
            } else {
                self.contentViewHeightAnchor?.constant = self.viewModel.maxContentHeight
                self.viewModel.savedContentHeight = self.viewModel.maxContentHeight
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    private func setViews() {
        guard let data = viewModel.data else { return }
        
        UIView.animate(withDuration: 0.25) {
            self.separatorView.alpha = 0
        }
        
        navbarTitleLabel.text = data.name
        titleLabel.text = data.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = formatter.date(from: .init(data.date.dropLast(5)))!
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        
        subtitleLabel.text = formatter.string(from: date)
        
        contentIV.loadFromURL(data.links.image.small) {
            self.spinner.stopAnimating()
        }
        
        collectionView.reloadData()
    }
}

extension DetailViewController:
    UIGestureRecognizerDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.collectedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DetailCell.self)", for: indexPath) as! DetailCell
        cell.data = viewModel.collectedData[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Spaces.conate
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - Spaces.medium * 2
        let height = viewModel.collectedData[indexPath.item][1].height(
            withConstrainedWidth: width, font: Fonts.regular(size: FontSize.subheadline)
        )
        return .init(width: width, height: height + Spaces.conate + 21)
    }
}
