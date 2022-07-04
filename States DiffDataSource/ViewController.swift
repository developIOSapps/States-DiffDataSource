//
//  ViewController.swift
//  States DiffDataSource
//
//  Created by Steven Hertz on 6/29/22.
//

import UIKit

struct UniqueState : Hashable {
    let uuid: UUID
    let name: String
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: UITableViewDiffableDataSource<String,UniqueState>? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let url = Bundle.main.url(forResource: "states", withExtension: "txt"),
              let s = try? String(contentsOf: url)
        else {return}
        let states = s.components(separatedBy: "\n")

        let stateDictionary = Dictionary(grouping: states) { state in
            String(state.prefix(1))
        }

        let sections = Array(stateDictionary).sorted {$0.key < $1.key}
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:  indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = itemIdentifier.name
            cell.contentConfiguration = config
            
            return cell
        }
        
        var snap = NSDiffableDataSourceSnapshot<String,UniqueState>()
        for section in sections {
            snap.appendSections([section.0])
            snap.appendItems(section.1.map {UniqueState(uuid:UUID(), name:$0)})
        }
        self.dataSource?.apply(snap, animatingDifferences: false)
    }
}

