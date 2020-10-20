//
//  operationQViewController.swift
//  ForOQs
//
//  Created by Zhaoyang Li on 6/24/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

import UIKit

class OperationQViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
//            tableView.isEditing = false
        }
    }
    @IBOutlet weak var loaderActivityIndicator: UIActivityIndicatorView!
    
    var dataSourceContainer = ForWorkersViewModel.shared.dataSourceContainer
    var oprationCustomControl = OperationQCustomControl()
    var currentIndexPath = IndexPath(row: 0, section: 0)
    
    //MARK: - settings area
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVControl()
    }
    
    func tableVControl() {
        ForWorkersViewModel.shared.fetchGeneralData { (transferredData) in
            self.dataSourceContainer = transferredData
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    func showOriginImage(index: IndexPath, workingOnCustom: WorkerCustom) {
        for item in ForWorkersViewModel.shared.dataSourceContainer {
            ForWorkersViewModel.shared.startDownloadImageOperation(workerCustom: item){ returnedIndex in
                OperationQueue.main.addOperation {
                    self.tableView.reloadRows(at: [index], with: .automatic)
                }
            }
        }
    }
    
    func showFilteredImage(index: IndexPath, workingOnCustom: WorkerCustom) {
        ForWorkersViewModel.shared.startFilteringOperation(workerCustom: workingOnCustom) { returnedIndex in
            OperationQueue.main.addOperation {
                self.tableView.reloadRows(at: [index], with: .automatic)
            }
        }
    }
}

//MARK: - tableView Stuff
extension OperationQViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workCustom = dataSourceContainer[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstant.workerCellID, for: indexPath) as? HeadShotTableViewCell else {return UITableViewCell()}
        print("cell at ", indexPath)

        let cellImage = workCustom.headShot != nil ? UIImage(data: workCustom.headShot ?? Data()) : UIImage(systemName: "person")
        
        cell.configureCell(image: cellImage, name: workCustom.firstName)
        
        if workCustom.state == .prepared {
            showOriginImage(index: indexPath, workingOnCustom: workCustom)
        } else if workCustom.state == .finished {
            showFilteredImage(index: indexPath, workingOnCustom: workCustom)
        }

//        cell.topAnchor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceContainer.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    } 
}

//MARK: - stop stuff
extension OperationQViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        ForWorkersViewModel.shared.oprationCustomControl.operationQ.isSuspended = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        ForWorkersViewModel.shared.oprationCustomControl.operationQ.isSuspended = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            ForWorkersViewModel.shared.oprationCustomControl.operationQ.isSuspended = false
        }
    }
}
