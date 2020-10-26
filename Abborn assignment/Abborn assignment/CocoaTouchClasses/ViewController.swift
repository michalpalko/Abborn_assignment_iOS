//
//  ViewController.swift
//  Abborn assignment
//
//  Created by Michal  on 24/10/2020.
//

import UIKit
import RealmSwift

let reusableIdentifierCell = "cell"

class ViewController: UIViewController {
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private var slovakResults : Results<Slovensko>!
    private var czechResults : Results<Cesko>!
    
    private var realm = try! Realm()
    private var slovakSections = [MonthSectionSlovak]()
    private var czechSections = [MonthSectionCzech]()
    private var currentDate : Date!
    private var currentDateComponents : DateComponents!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: reusableIdentifierCell)
        
        currentDate = Date()
        currentDateComponents = decomposeDate(date: currentDate)
        
        loadData()
        setSections()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        scrollTableToPosition(for: currentDate)
    }
//MARK: - UI PRE-SET
//  Loading data from database
    private func loadData() {
        slovakResults = realm.objects(Slovensko.self)
        czechResults = realm.objects(Cesko.self)
    }
    
    private func setSections(){
        //Creating Month Sections for Slovak table
        let slovakGroups = Dictionary(grouping: self.slovakResults) { (slovakResult) -> Date in
            return firstDayOfMonth(date: parseDate(str: "\(slovakResult.date!)\(currentDateComponents.year!)"))
        }
        self.slovakSections = slovakGroups.map(MonthSectionSlovak.init(month:headlinesForSlovak:)).sorted()
        
        //Creating Month Sections for Czech table
        let czechGroups = Dictionary(grouping: self.czechResults) { (czechResult) -> Date in
            return firstDayOfMonth(date: parseDate(str: "\(czechResult.date!)\(currentDateComponents.year!)"))
        }
        self.czechSections = czechGroups.map(MonthSectionCzech.init(month:headlinesForCzech:)).sorted()
    }

//MARK: - DATE FUNCTIONS
    private func decomposeDate(date : Date) -> DateComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        return components
    }
    
    private func parseDate(str: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.M.yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        return dateFormatter.date(from: str)!
    }
    
    private func firstDayOfMonth(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }

//MARK: - TABLEVIEW UPDATING
    private func reloadTable(){
        searchbar.endEditing(true)
        setSections()
        tableView.reloadData()
        scrollTableToPosition(for: currentDate)
    }
    
    private func scrollTableToPosition(for currentDate:Date){
        tableView.scrollToRow(at:IndexPath(row: currentDateComponents.day!-1, section: currentDateComponents.month!-1), at:.top ,animated: true)
    }

//MARK: - IB ACTIONS
    @IBAction func switchCountry(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            reloadTable()
            print("Selected country is Slovakia.")
        case 1:
            reloadTable()
            print("Selected country is Czech.")
        default:
            reloadTable()
            print("Selected country is Slovakia.")
        }
    }
}

//MARK: - TABLEVIEW DATASOURCE EXTENSION
extension ViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentedControl.selectedSegmentIndex ==  0 {
            return self.slovakSections.count
        }
        else {
            return self.czechSections.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segmentedControl.selectedSegmentIndex == 0 {
            let section = self.slovakSections[section]
            let date = section.month
            let dateFormatter =  DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: date)
        }
        else {
            let section = self.czechSections[section]
            let date = section.month
            let dateFormatter =  DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .red
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            let section = self.slovakSections[section]
            return section.headlinesForSlovak.count
        }
        else {
            let section = self.czechSections[section]
            return section.headlinesForCzech.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if indexPath.row.isMultiple(of: 2){
            cell.backgroundColor = .white
            
            cell.dateLabel?.backgroundColor = .blue
            cell.nameLabel?.backgroundColor = .blue
            cell.anyAttributeLabel?.backgroundColor = .blue
            
            cell.dateLabel?.textColor = .white
            cell.nameLabel?.textColor = .white
            cell.anyAttributeLabel?.textColor = .white
        }
        else {
            cell.backgroundColor = .none
            
            cell.dateLabel?.backgroundColor = .white
            cell.nameLabel?.backgroundColor = .white
            cell.anyAttributeLabel?.backgroundColor = .white
            
            cell.dateLabel?.textColor = .black
            cell.nameLabel?.textColor = .black
            cell.anyAttributeLabel?.textColor = .black
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let section = self.slovakSections[indexPath.section]
            let headline = section.headlinesForSlovak[indexPath.row]
            cell.dateLabel?.text = headline.date
            cell.nameLabel?.text = headline.name
            cell.anyAttributeLabel?.text = headline.anyAttribute
        }
        else {
            let section = self.czechSections[indexPath.section]
            let headline = section.headlinesForCzech[indexPath.row]
            cell.dateLabel?.text = headline.date
            cell.nameLabel?.text = headline.name ?? ""
            cell.anyAttributeLabel?.text = headline.anyAttribute ?? ""
        }
        return cell
    }
}

//MARK: - TABLEVIEW DELEGATE EXTENSION
extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
//MARK: - SEARCHBAR DELEGATE EXTENSION
extension ViewController : UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchbar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        loadData()
        setSections()
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        
        if searchText.count == 0 {
            loadData()
            setSections()
            
            DispatchQueue.main.async {
                self.tableView.resignFirstResponder()
                self.tableView.reloadData()
            }
        }else {
            if segmentedControl.selectedSegmentIndex == 0 {
                slovakResults = realm.objects(Slovensko.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
            }else {
                czechResults = realm.objects(Cesko.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
            }
            setSections()
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        if segmentedControl.selectedSegmentIndex == 0 {
            slovakResults = slovakResults?.filter(predicate).sorted(byKeyPath: "name", ascending: true)
            setSections()
            
        }else {
            czechResults = czechResults.filter(predicate).sorted(byKeyPath: "name", ascending: true)
            setSections()
        }
        
        self.tableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
}

