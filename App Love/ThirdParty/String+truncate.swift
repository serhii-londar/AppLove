//
//  String+truncate.swift
//
//  Created by Unknown Person Online
//

import Foundation

// gist from gitgub
extension String {
    /// Truncates the string to length number of characters and
    /// doesn't truncate within a word.
    /// appends optional trailing string if longer
    func truncate(length: Int, wordSeparator: String = " ", trailing: String = "…") -> String {
        if self.characters.count > length {
            let words = self.components(separatedBy: wordSeparator)
            var cumulativeCharacters = 0
            var wordsToInclude:[String] = []
            for word in words {
                cumulativeCharacters += word.lengthOfBytes(using: String.Encoding.utf8) + 1
                if cumulativeCharacters < length {
                    wordsToInclude.append(word)
                } else {
                    return wordsToInclude.joined(separator: wordSeparator) + trailing
                }
            }
            return self.substring(to: self.startIndex.advanced(by: length)) + trailing
        } else {
            return self
        }
    }
}
