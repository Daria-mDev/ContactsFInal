//
//  TableViewController.swift
//  ContactsMultithreading
//
//  Created by user on 25.03.2021.
//

import UIKit
import ContactsUI

enum ContactAction {
    case addNewContact
    case editContactDetails
}

class TableViewController: UITableViewController {
    private var selectedIndexPath: IndexPath = []
    private var contactList: [Contact] = []
    private var tableSections = [String]()
    private var dictionaryContacts: [String: [Contact]] = [:]
    var concurrencyOption: ConcurrencyOption = ConcurrencyOption.operationQueue
    private let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    private var contactAction: ContactAction = ContactAction.editContactDetails
    private var avatarView: AvatarView = .customView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLoadindIndicator()
        
        let path: String = "https://gist.githubusercontent.com/artgoncharov/61c471db550238f469ad746a0c3102a7/raw/590dcd89a6aa10662c9667138c99e4b0a8f43c67/contacts_data2.json"
        
        let contactsRepo = GistConstactsRepository(path: path)
        if concurrencyOption == ConcurrencyOption.operationQueue {
            navigationItem.title = "Contact - Operation"
            fetchOperationQueue(contactsRepo: contactsRepo)
        }
        else if concurrencyOption == ConcurrencyOption.grandCentralDispatch {
            navigationItem.title = "Contact - GCD"
            fetchGCD(contactsRepo: contactsRepo)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        tableSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRowsInSection = dictionaryContacts[tableSections[section]]?.count  else {
            return 0
        }
        return numberOfRowsInSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let contact = dictionaryContacts[tableSections[indexPath.section]]?[indexPath.row]
        cell.textLabel?.text = (contact?.firstName ?? " ") + " " + (contact?.lastName ?? " ")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableSections[section]
    }
    func tableView(tableView: UITableView,
                   sectionForSectionIndexTitle title: String,
                   atIndex index: Int) -> Int{
        return index
    }
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]!{
        return tableSections
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        tableSections
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? CustomAvatarViewController else {return }
        let contact: Contact? = dictionaryContacts[tableSections[selectedIndexPath.section]]?[selectedIndexPath.row]
        var url: String = ""
        if let photoUrl = contact?.photoUrl {
            url = photoUrl
            avatarView = .imageView
        }
        else {
            avatarView = .customView
        }
        if let firstName = contact?.firstName, let lastName = contact?.lastName {
            viewController.setContactInfo(firstName: firstName, lastName: lastName, avatarView: avatarView, gifUrl: url)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactAction = ContactAction.editContactDetails
        guard let selectedContact = dictionaryContacts[tableSections[indexPath.section]]?[indexPath.row]
        else {
            return
        }
        showDetailsFor(contact: selectedContact, indexPath: indexPath)
    }
    
    private func addLoadindIndicator() {
        loadingIndicator.style = .large
        loadingIndicator.color = UIColor.systemGray
        loadingIndicator.hidesWhenStopped = true
        
        loadingIndicator.center.x = self.view.center.x
        loadingIndicator.center.y = self.view.center.y * 0.8
        
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        self.view.isUserInteractionEnabled = false
    }
    
    private func fetchOperationQueue(contactsRepo: ContactsRepository) {
        let operationQueue = OperationQueue()
        operationQueue.name = "Contacts Downloader Queue"
        operationQueue.maxConcurrentOperationCount = 1
        
        let downloaderOperation = ContactsDownloadOperation(contactsRepository: contactsRepo)
        downloaderOperation.completionBlock = {
            if downloaderOperation.isCancelled {
                return
            }
            self.contactList = downloaderOperation.contactList
            self.setTableViewData()
        }
        operationQueue.addOperation(downloaderOperation)
    }
    
    private func fetchGCD(contactsRepo: GistConstactsRepository) {
        let utilityQueue = DispatchQueue.global(qos: .utility)
        utilityQueue.async {
            self.loadContactsData(contactsRepo: contactsRepo)
        }
    }
    
    private func setTableViewData() {
        DispatchQueue.main.async {
            self.dictionaryContacts = Dictionary(grouping: self.contactList) {
                contact in  (contact.firstName.first?.uppercased() ?? " ")
            }
            for (key, _)  in self.dictionaryContacts {
                self.tableSections.append(key)
                self.dictionaryContacts[key]?.sort {
                    $0.firstName < $1.firstName
                }
            }
            self.tableSections.sort()
            self.tableView.reloadData()
            
            self.loadingIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    private func loadContactsData(contactsRepo: ContactsRepository) {
        do {
            self.contactList = try contactsRepo.getContacts()
        }
        catch {
            print(error)
        }
        self.setTableViewData()
    }
    
    private func getCallTime() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: today)
    }
    
    private func findBy(phone: String) {
        for (index, element) in RecentCallsList.recentCalls.enumerated() {
            if element.phone == phone {
                RecentCallsList.recentCalls[index].firstName = nil
            }
        }
    }
}


extension TableViewController: CNContactViewControllerDelegate {
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        guard let contact = contact else {
            return
        }
        switch contactAction {
        case .addNewContact:
            updateTableViewData(contact: contact)
        case .editContactDetails:
            deleteContact()
            updateTableViewData(contact: contact)
        }
        viewController.dismiss(animated: true, completion: nil)
    }
    private func updateTableViewData(contact: CNContact){
        var contactData = Contact(firstName: contact.givenName ,lastName: contact.familyName ,phone: contact.phoneNumbers.first?.value.stringValue ?? " " ,birthday: contact.birthday?.date, email: contact.emailAddresses.first?.value.description)
        if contactData.birthday != nil {
            contactData.identifier = contactData.hashValue
            
            let notificationService = ContactBirthdayNotification()
            notificationService.setBirthdayNotification(forContact: contactData)
        }
        if let key = contactData.firstName.first?.uppercased() {
            if dictionaryContacts.index(forKey: key) == nil {
                tableSections.append(key)
                tableSections.sort()
            }
            dictionaryContacts[key]?.append(contactData)
            dictionaryContacts[key]?.sort {
                $0.firstName < $1.firstName
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func addNewContact(_ sender: Any) {
        contactAction = ContactAction.addNewContact
        let contactViewController = CNContactViewController(forNewContact: nil)
        contactViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: contactViewController)
        navigationController.modalPresentationStyle = .formSheet
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func deleteContact() {
        let contact: Contact? = dictionaryContacts[tableSections[selectedIndexPath.section]]?[selectedIndexPath.row]
        findBy(phone: contact?.phone ?? " ")
        dictionaryContacts[tableSections[selectedIndexPath.section]]?.remove(at: selectedIndexPath.row)
        tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func showContactAvatar() {
        performSegue(withIdentifier: "avatarSegue", sender: self)
    }
    
    @objc private func makeCall() {
        let contact: Contact? = dictionaryContacts[tableSections[selectedIndexPath.section]]?[selectedIndexPath.row]
        if let firstName = contact?.firstName, let phone = contact?.phone {
            RecentCallsList.recentCalls.append(RecentCall(firstName: firstName, phone: phone, time: getCallTime()))
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showDetailsFor(contact selectedContact: Contact, indexPath: IndexPath){
        selectedIndexPath = indexPath
        let contact = CNMutableContact()
        contact.givenName = selectedContact.firstName
        contact.familyName = selectedContact.lastName
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: selectedContact.phone ))]
        contact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: NSString.init(string: selectedContact.email ?? " "))]
        if let birthday = selectedContact.birthday {
            contact.birthday = Calendar.current.dateComponents([.day, .month], from: birthday)
        }
        
        let contactViewController = CNContactViewController(for: contact)
        contactViewController.delegate = self
        
        contactViewController.navigationItem.leftItemsSupplementBackButton = true
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteContact))
        let callButton = UIBarButtonItem(image: UIImage(systemName: "phone.circle"), style: .plain, target: self, action: #selector(makeCall))
        
        let avatarButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.rectangle"), style: .plain, target: self, action: #selector(showContactAvatar))
        
        contactViewController.navigationItem.leftBarButtonItems = [deleteButton, callButton, avatarButton]
        self.navigationController?.pushViewController(contactViewController, animated: true)
    }
}
