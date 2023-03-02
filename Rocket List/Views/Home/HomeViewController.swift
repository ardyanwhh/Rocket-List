//
//  HomeViewController.swift
//  Rocket List
//
//  Created by Mada Bramantyo on 14/02/23.
//

import UIKit
import Combine
import SnapKit

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private var cancellableBag = Set<AnyCancellable>()
    
    private let backgroundIV = UIImageView()
    private let logoIV = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let searchTF = SearchTextField()
    private let refreshControl = UIRefreshControl()
    private let spinner = UIActivityIndicatorView()
    private let alertLabel = UILabel()
    
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: flowLayout
    )
    
    private var timer = Timer()
    
    private lazy var logoIVView: UIView = {
        let view = UIView()
        
        view.addSubview(logoIV)
        
        logoIV.image = .init(named: Assets.icLogo)
        logoIV.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.height.width.equalTo(36)
        }
        
        view.backgroundColor = .white
        view.layer.cornerRadius = CornerSize.small
        
        return view
    }()
    
    private lazy var navbarView: UIView = {
        let view = UIView()
        
        [logoIVView].forEach {
            view.addSubview($0)
        }
        
        logoIVView.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.leading.equalTo(view).offset(Spaces.mediumLarge)
            make.height.width.equalTo(WidgetSize.largeRectangleHeight)
        }
        
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
    
    private lazy var alertView: UIView = {
        let view = UIView()
        
        view.addSubview(alertLabel)
        
        alertLabel.textColor = .black
        alertLabel.font = Fonts.regular(size: FontSize.subheadline)
        alertLabel.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        
        [pinchView, searchTF, spinner, collectionView, alertView].forEach {
            view.addSubview($0)
        }
        
        pinchView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.height.equalTo(WidgetSize.rectangleHeight)
        }
        
        searchTF.delegate = self
        searchTF.snp.makeConstraints { make in
            make.top.equalTo(pinchView.snp_bottomMargin)
            make.horizontalEdges.equalTo(view).inset(Spaces.medium)
            make.height.equalTo(WidgetSize.rectangleHeight)
        }
        
        alertView.snp.makeConstraints { make in
            make.top.equalTo(searchTF.snp_bottomMargin).offset(Spaces.small)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(WidgetSize.rectangleHeight)
        }
        
        spinner.color = .black.withAlphaComponent(0.5)
        spinner.snp.makeConstraints { make in
            make.top.equalTo(searchTF.snp_bottomMargin).offset(Spaces.mediumLarge)
            make.centerX.equalTo(view)
        }
        
        refreshControl.transform = .init(scaleX: 0.75, y: 0.75)
        refreshControl.tintColor = .black.withAlphaComponent(0.5)
        refreshControl.addTarget(
            self, action: #selector(refresh(_:)), for: .valueChanged
        )
        
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refreshControl
        collectionView.register(
            HomeCell.self, forCellWithReuseIdentifier: "\(HomeCell.self)"
        )
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTF.snp_bottomMargin).offset(Spaces.conate)
            make.leading.bottom.trailing.equalTo(view)
        }
        
        view.backgroundColor = .white
        view.layer.cornerRadius = CornerSize.medium
        
        return view
    }()
    
    private var contentViewHeightAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        view.backgroundColor = .white
        
        [backgroundIV, navbarView, titleLabel, subtitleLabel, contentView].forEach {
            view.addSubview($0)
        }
        
        backgroundIV.image = .init(named: Assets.imgBackgroundUnv)
        backgroundIV.contentMode = .scaleAspectFill
        backgroundIV.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }
        
        navbarView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(76)
        }
        
        titleLabel.text = "Hello, Ardyan"
        titleLabel.font = Fonts.semiBold(size: FontSize.title)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navbarView.snp_bottomMargin)
                .offset(Spaces.large)
            make.leading.trailing.equalTo(view)
                .inset(Spaces.mediumLarge)
        }
        
        subtitleLabel.text = "See available rockets for you"
        subtitleLabel.font = Fonts.medium(size: FontSize.title3)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(Spaces.conate)
            make.leading.trailing.equalTo(view)
                .inset(Spaces.mediumLarge)
        }
        
        [titleLabel, subtitleLabel].forEach {
            $0.textColor = .white
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowRadius = 10
            $0.layer.shadowOpacity = 1
        }
        
        [logoIVView, contentView].forEach {
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowRadius = 10
            $0.layer.shadowOpacity = 0.25
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view)
        }
        
        viewModel.defaultContentHeight = (WidgetSize.bottomSafeArea ?? Spaces.conate) + 96
        viewModel.savedContentHeight = (WidgetSize.bottomSafeArea ?? Spaces.conate) + 96
        viewModel.maxContentHeight = view.frame.height - (WidgetSize.topSafeArea ?? 0) - 200
        
        contentViewHeightAnchor = contentView.heightAnchor.constraint(
            equalToConstant: viewModel.defaultContentHeight
        )
        
        contentViewHeightAnchor?.isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetch()
        
        viewModel.$status.sink {
            
            self.alertView.alpha = 0
            self.alertLabel.text?.removeAll()
            
            if $0 == .success {
                self.viewModel.paginate = false
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
                
                if self.viewModel.data.isEmpty {
                    self.alertView.alpha = 1
                    self.alertLabel.text = "No Result."
                }
            }
            
            if $0 == .loading {
                self.spinner.startAnimating()
            } else {
                self.spinner.stopAnimating()
            }
            
            if $0 == .timeout {
                self.alertView.alpha = 1
                self.alertLabel.text = "Timeout Connection."
                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
            }
        }.store(in: &cancellableBag)
    }
    
    @objc private func refresh(_ refresh: UIRefreshControl) {
        viewModel.dispose()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.fetch()
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let _ = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            animatePanGesture(bottoming: false)
        }
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
        
        UIView.animate(withDuration: 0.5) {
            self.collectionView.alpha = bottoming ? 0 : 1
            self.spinner.alpha = bottoming ? 0 : 1
        }
    }
    
    @objc private func performSearch() {
        viewModel.search = searchTF.text ?? ""
        viewModel.fetch()
    }
}

extension HomeViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UITextFieldDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(HomeCell.self)", for: indexPath) as! HomeCell
        guard !viewModel.data.isEmpty else { return cell }
        cell.data = viewModel.data[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width - Spaces.medium * 2, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: Spaces.small, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Spaces.small
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        show(DetailViewController(id: viewModel.data[indexPath.item].id), sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > collectionView.contentSize.height - 76 - scrollView.frame.size.height {
            guard !viewModel.paginate else { return }
            viewModel.paginate = true
            viewModel.page += 1
            viewModel.fetch()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        timer.invalidate()
        let currentText = textField.text ?? ""
        
        viewModel.dispose()
        viewModel.status = .loading
        collectionView.reloadData()
        
        if (currentText as NSString).replacingCharacters(in: range, with: string).count >= 0 {
            timer = Timer.scheduledTimer(
                timeInterval: 0.5, target: self, selector: #selector(performSearch),
                userInfo: nil, repeats: false
            )
        }
        
        return true
    }
}
