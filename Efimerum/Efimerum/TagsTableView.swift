//
//  TagsTableView.swift
//  Efimerum
//
//  Created by Michel Barbou Salvador on 05/03/2017.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit

class TagsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var model :[String]
    var searchView :UIView
    
    
    init(model: [String], on view: UIView) {
        
        self.model = model
        self.searchView = view
  
        
        super.init(frame: CGRect.zero, style: .plain)
        
        let nib = UINib(nibName: "TagsCell", bundle: nil)
        self.register(nib, forCellReuseIdentifier: "TagsCell")
        
        self.backgroundColor = .clear
        self.separatorStyle = .none
        
        self.rowHeight = 50.0
        
        self.delegate = self
        self.dataSource = self
                
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagsCell") as! TagsCell
        
        cell.tagNameLabel.text = model[indexPath.row]
        
        return cell
    }
    

}
