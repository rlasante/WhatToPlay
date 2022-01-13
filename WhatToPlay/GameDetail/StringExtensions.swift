//
//  StringExtensions.swift
//  WhatToPlay
//
//  Created by Ungar Peter on 2022. 01. 13..
//  Copyright © 2022. rlasante. All rights reserved.
//

import Foundation

extension String {
    /** Replaces common HTML entities in a description string with plain text equivalents.
        The purpose is not to write a full SGML processor, just a quick fix to improve the legibility of game descriptions.
     */
    var replacingHtmlEntities: String {
        return self.replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#10;", with: "\n")
    }
}
