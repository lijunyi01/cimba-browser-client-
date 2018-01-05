//
//  Document.swift
//  cimba browser
//
//  Created by jason on 2017/11/15.
//  Copyright © 2017年 jason. All rights reserved.
//

import Cocoa

class Document: NSDocument {

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
        displayName = ""
//        fileURL = nil
//        isDraft = true
//        self.updateChangeCount(NSDocument.ChangeType.changeDiscardable)
        
    }

    override class var autosavesInPlace: Bool {
//        return true
        return false
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
//        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        return "".data(using: String.Encoding.utf8)!
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
    
    override func close() {
        super.close()
        windowCount_G.value = NSDocumentController.shared.documents.count
//        Swift.print("windowCount:" + String(windowCount_G.value))
        
    }
    
//    override func save(withDelegate delegate: Any?, didSave didSaveSelector: Selector?, contextInfo: UnsafeMutableRawPointer?) {
//        Swift.print("save document:" + String(self.isDocumentEdited))
//        super.save(withDelegate: delegate, didSave: didSaveSelector, contextInfo: contextInfo)
//
//    }
}

