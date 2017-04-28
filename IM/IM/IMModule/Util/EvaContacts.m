//
//  CDContacts.m
//  EVA
//
//  Created by Apple on 15/2/10.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import "EvaContacts.h"
#import "EVAContact.h"
#import "AppDelegate.h"

static NSMutableArray *contacts;

@implementation EvaContacts

+ (void)initialize {
    [super initialize];
    
    contacts = [NSMutableArray array];
}

+ (void)loadAddressBookContacts {
    CFErrorRef error;
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        
        if (granted) {
            [self getContactsFromAddressBook];
        }else {
            [IMUtil runAfterSecs:0.5 block:^{
                //[SVProgressHUD dismiss];
                [[[UIAlertView alloc] initWithTitle:nil message:@"请在iPhone的“设置”中，允许本应用访问您的通讯录。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil] show];
            }];
        }
        
        if (addressBookRef) {
            CFRelease(addressBookRef);
        }
    });
}

//    获取手机通讯录联系人数据
+ (void)getContactsFromAddressBook {
    [self loadAddressBookContacts:nil];
}

+ (void)loadAddressBookContacts:(AVArrayResultBlock)block {
    __block NSMutableArray *finalContacts = [NSMutableArray array];
    
    if([[UIDevice currentDevice].systemVersion doubleValue] < 9.0){
        //9.0以下使用AddressBook.framework
        CFErrorRef error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        
        if (addressBook) {
            NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
            
            for (NSUInteger i = 0; i < [allContacts count]; i++) {
                EVAContact *contact = [[EVAContact alloc] init];
                ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
                
                // Get first and last names
                NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
                NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
                
                // Set Contact properties
                contact.firstName = firstName;
                contact.lastName = lastName;
                
                // Get mobile number
                ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
                for (int i = 0; i < ABMultiValueGetCount(phonesRef); i ++) {
                    CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
                    CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
                    
                    if(currentPhoneLabel) {
                        
                        NSString *originalPhoneNumber = nil;
                        
                        if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                            originalPhoneNumber = (__bridge NSString *)currentPhoneValue;
                        }
                        
                        if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                            originalPhoneNumber = (__bridge NSString *)currentPhoneValue;
                        }
                        
                        contact.phoneNumber = [self formatOriginalPhoneNumber:originalPhoneNumber];
                    }
                    
                    if(currentPhoneLabel) {
                        CFRelease(currentPhoneLabel);
                    }
                    if(currentPhoneValue) {
                        CFRelease(currentPhoneValue);
                    }
                }
                CFRelease(phonesRef);
                
                if (contact.phoneNumber == nil) {
                    contact.phoneNumber = @"";
                }
                
                [finalContacts addObject:contact];
            }
            
            CFRelease(addressBook);
        }
        
        if (contacts.count > 0) {
            [contacts removeAllObjects];
        }
        
        [contacts addObjectsFromArray:finalContacts];
        
        [[GDCacheService sharedInstance] cacheUserContactArrray:contacts];
        
        if (block) {
            block(contacts, (__bridge NSError *)(error));
        }
    } else {
        //9.0以上使用Contacts.framework
        CNContactStore * store = [[CNContactStore alloc] init];
        //请求获取权限
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(granted){
                CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactFamilyNameKey,CNContactGivenNameKey,CNContactPhoneNumbersKey]];
                [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                    
                    EVAContact *fetchContact = [[EVAContact alloc] init];
                    fetchContact.firstName = contact.familyName;
                    fetchContact.lastName = contact.givenName;
                    
                    // 2.获取联系人的电话号码
                    CNLabeledValue *labeledValue = [contact.phoneNumbers firstObject];
                    // 2.1.获取电话号码
                    CNPhoneNumber *phoneNumer = labeledValue.value;
                    NSString *phoneValue = phoneNumer.stringValue;
                
                    fetchContact.phoneNumber = phoneValue;
                    
                    if([phoneValue isNotEmpty] && ([fetchContact.firstName isNotEmpty] || [fetchContact.lastName isNotEmpty])){
                        [finalContacts addObject:fetchContact];
                    }
                }];
                
                [[GDCacheService sharedInstance] cacheUserContactArrray:finalContacts];
                
                [IMUtil runInMainQueue:^{
                    if (block) {
                        block(finalContacts, nil);
                    }
                }];
            }else{
                [IMUtil runInMainQueue:^{
                    if (block) {
                        block(finalContacts, error);
                    }
                }];
            }
        }];
    }
}

//    去掉通讯录里手机号码里的空格和横线
+ (NSString *)formatOriginalPhoneNumber:(NSString *)phoneNumber {
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return phoneNumber;
}

+ (NSArray *)getAddressBookContacts {
    return contacts;
}

@end
