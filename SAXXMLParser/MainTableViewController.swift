//
//  MainTableViewController.swift
//  SAXXMLParser
//
//  Created by Ruslan Akberov on 19/08/2019.
//  Copyright © 2019 Ruslan Akberov. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, XMLParserDelegate {
    
    private var tempBook: Book?
    private var currentParsingValue: String?
    private var books = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()
        parseXML()
    }

    private func parseXML() {
        let booksUrl = Bundle.main.url(forResource: "Books", withExtension: "xml")!
        let parser = XMLParser(contentsOf: booksUrl)!
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "book": tempBook = Book()
        case "title": currentParsingValue = "title"
        case "author": currentParsingValue = "author"
        case "country": currentParsingValue = "country"
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let correctedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        switch currentParsingValue {
        case "title": tempBook!.title += correctedString
        case "author": tempBook!.author += correctedString
        case "country": tempBook?.country += correctedString
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "book":
            books.append(tempBook!)
            tempBook = nil
        default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = books[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = book.title
        cell.detailTextLabel?.text = book.author + ", " + book.country
        return cell
    }


}
