//
//  HTMLParser.swift
//  LiveStreamFails
//
//  Created by Balraj Singh on 25/03/19.
//  Copyright © 2019 balraj. All rights reserved.
//

import Foundation
import SwiftSoup
import PromiseKit

enum HTMLParserError: Error {
  case inValidHTMLString
  case inValidSelectionPath
}

/*
 This class provides all the functionality to parse the HTML using SwiftSoup
 */
struct HTMLParser {
  public static func createDocument(fromHTMLString htmlString: String) -> Result<Document> {
    return (try? SwiftSoup.parse(htmlString))
      .map { Result.fulfilled($0) }
    ?? Result.rejected(HTMLParserError.inValidHTMLString)
  }
  
  public static func selectDoc(path: String)
    -> (_ document: Result<Document>)
    -> Result<Elements> {
      return { (document: Result<Document>) -> Result<Elements> in
        return document.flatMap { (doc: Document) -> Result<Elements> in
          return (try? doc.select(path))
            .map { Result.fulfilled($0) }
            ?? Result.rejected(HTMLParserError.inValidSelectionPath)
        }
      }
  }
  
  public static func selectElem(path: String)
    -> (_ element: Element)
    -> Result<Elements> {
      return { (element: Element) -> Result<Elements> in
          return (try? element.select(path))
            .map { Result.fulfilled($0) }
            ?? Result.rejected(HTMLParserError.inValidSelectionPath)
      }
  }
}
