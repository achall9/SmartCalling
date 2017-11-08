//
//  AddressBookManager.swift
//  SmartCalling
//
//  Created by Jonathan Ellis on 08/06/2016.
//  Copyright © 2016 SmartCalling. All rights reserved.
//

import UIKit
import AddressBook

@available(iOS, deprecated: 9.0)
class AddressBookManager {
    
    let SMARTCALLING_ID = "SmartCalling Profile"
    
    static let sharedInstance = AddressBookManager()
    
    var addressBook: ABAddressBook!
    
    var groupName: String!
    
    // var error: Unmanaged<CFError>? = nil
    
    fileprivate init() {
        // TODO: Pass in as parameter
        self.groupName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
    }
    
    func checkAuthorizationStatus(_ completion: @escaping (Bool) -> Void) {
        let status = ABAddressBookGetAuthorizationStatus()
        
        if status == .notDetermined {
            let addressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
            ABAddressBookRequestAccessWithCompletion(addressBook, { (granted, error) in
                if granted {
                    self.addressBook = addressBook
                }
                completion(granted)
            })
        } else if status == .authorized {
            addressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func addProfile(_ profile: Profile) {
        let contact = createContact(profile)
        saveContact(contact) // TODO: Confirm success before adding to group
        saveContactToGroup(contact, createGroup(groupName))
    }
    
    private func createContact(_ profile: Profile) -> ABRecord {
        let contact = ABPersonCreate().takeRetainedValue()
        
        // Set description and note
        ABRecordSetValue(contact, kABPersonLastNameProperty, profile.getString(Profile.KEY_CALL_DESCRIPTION) as CFTypeRef!, nil)
        ABRecordSetValue(contact, kABPersonNoteProperty, SMARTCALLING_ID as CFTypeRef!, nil)
        
        // Set phone number
        let phoneMultiValue = ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
        ABMultiValueAddValueAndLabel(phoneMultiValue, profile.phoneNumbers![0] as CFTypeRef!, kABPersonPhoneMainLabel, nil)
        ABRecordSetValue(contact, kABPersonPhoneProperty, phoneMultiValue, nil)
        
        // Set image
        if profile.image != nil {
            let imageData = UIImagePNGRepresentation(profile.image!)!
            ABPersonSetImageData(contact, imageData as CFData, nil)
        }
        
        return contact
    }
    
    private func createGroup(_ groupName: String) -> ABRecord {
        let groupRecord: ABRecord = ABGroupCreate().takeRetainedValue()
        
        if ABAddressBookCopyArrayOfAllGroups(addressBook) != nil {
            let allGroups = ABAddressBookCopyArrayOfAllGroups(addressBook).takeRetainedValue() as Array
            
            // Check if group exists - return
            for group in allGroups {
                let currentGroup: ABRecord = group
                let currentGroupName = ABRecordCopyValue(currentGroup, kABGroupNameProperty).takeRetainedValue() as! String
                if (currentGroupName == groupName) {
                    debugPrint("Group already exists!")
                    return currentGroup
                }
            }
        }
        
        // Set group name
        ABRecordSetValue(groupRecord, kABGroupNameProperty, groupName as CFString, nil)
        ABAddressBookAddRecord(addressBook, groupRecord, nil)
        debugPrint("Success: Added group " + groupName)
        
        saveAddressBookChanges()
        return groupRecord
    }

    private func saveContact(_ contact: ABRecord) {
        let added = ABAddressBookAddRecord(addressBook, contact, nil)
        if !added {
            debugPrint("Error: Could not add contact!")
            return
        }
        
        debugPrint("Success: Profile saved!")
        saveAddressBookChanges()
    }
    
    private func saveContactToGroup(_ contact: ABRecord, _ group: ABRecord) {
        
        if let groupMembersArray = ABGroupCopyArrayOfAllMembers(group) {
            let groupMembers = groupMembersArray.takeRetainedValue() as Array
            for member in groupMembers {
                let currentMember: ABRecord = member
                if currentMember === contact {
                    debugPrint("Contact already exists in group!")
                    return
                }
            }
        }
        
        let addedToGroup = ABGroupAddMember(group, contact, nil)
        if !addedToGroup {
            debugPrint("Error: Could not add to group!")
            return
        }
        
        debugPrint("Success: Contact added to group!")
        saveAddressBookChanges()
    }
    
    public func deleteAllProfiles() {
        deleteProfiles()
        deleteGroup()
    }
    
    private func deleteProfiles() {
        
        let contacts = ABAddressBookCopyArrayOfAllPeople(addressBook!).takeRetainedValue() as NSArray
        for contact in contacts {
            guard let note = ABRecordCopyValue(contact as ABRecord!, kABPersonNoteProperty)?.takeRetainedValue() as? String else { continue }
            if note == SMARTCALLING_ID { // TODO: This could be done by group name?
                debugPrint("Deleting SmartCalling profiles...")
                ABAddressBookRemoveRecord(addressBook, contact as ABRecord!, nil)
            }
        }
        saveAddressBookChanges()
    }
    
    private func deleteGroup() {
        
        if ABAddressBookCopyArrayOfAllGroups(addressBook!) != nil {
            
            let allGroups = ABAddressBookCopyArrayOfAllGroups(addressBook!).takeRetainedValue() as Array
            for group in allGroups {
                let currentGroup: ABRecord = group
                let currentGroupName = ABRecordCopyValue(currentGroup, kABGroupNameProperty).takeRetainedValue() as! String
                if (currentGroupName == groupName) {
                    ABAddressBookRemoveRecord(addressBook, currentGroup, nil);
                    saveAddressBookChanges()
                    debugPrint("Group deleted!")
                }
            }
            
        }
    
    }
 
    private func saveAddressBookChanges() {
        if ABAddressBookHasUnsavedChanges(addressBook) {
            var error: Unmanaged<CFError>? = nil
            let savedToAddressBook = ABAddressBookSave(addressBook, &error)
            if savedToAddressBook {
                debugPrint("Success: Changes saved!")
            } else {
                debugPrint("Error: Couldn't save changes!")
            }
        } else {
            debugPrint("No changes occurred!")
        }
    }
    
}
