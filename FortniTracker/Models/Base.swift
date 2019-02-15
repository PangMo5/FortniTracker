/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct Base: Mappable {
    var date_layout: String?
    var lastupdate: Int?
    var language: String?
    var date: String?
    var rows: Int?
    var vbucks: String?
    var items: [Items]?
    
    var error: Bool?
    var errorCode: String?
    var errorMessage: String?
    var numericErrorCode: Int?
    var originatingService: String?
    var intent: String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		date_layout <- map["date_layout"]
		lastupdate <- map["lastupdate"]
		language <- map["language"]
		date <- map["date"]
		rows <- map["rows"]
		vbucks <- map["vbucks"]
		items <- map["items"]
        
        error <- map["error"]
        errorCode <- map["errorCode"]
        errorMessage <- map["errorMessage"]
        numericErrorCode <- map["numericErrorCode"]
        originatingService <- map["originatingService"]
        intent <- map["intent"]
	}

}
