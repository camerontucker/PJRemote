import Foundation
import SwiftSocket

// https://github.com/ymazdy/YazdanSwiftSocket/blob/master/YazdanSwiftSocket/Sources/TCPClient.swift

//  Copyright (c) <2017>, http://yazdan.xyz
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. All advertising materials mentioning features or use of this software
//  must display the following acknowledgement:
//  This product includes software developed by http://yazdan.xyz.
//  4. Neither the name of the http://yazdan.xyz nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY http://yazdan.xyz ''AS IS'' AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL http://yazdan.xyz BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

class Client: TCPClient {
    func read(until: String, timeout: Double = 5000.0) -> String? {
        let first = Date().timeIntervalSince1970
        var data: [Byte] = []
        var string: String?
        var _string: String = ""
        while !_string.contains(until) {
            if let first = self.read(1, timeout: Int(0.1))?.first {
                data.append(first)
            }
            if let str = String(bytes: data, encoding: .utf8) {
                if str != "" {
                    string = str
                }
                _string = str
            }
            if Date().timeIntervalSince1970 - first > timeout {
                return string
            }
        }
        return string
    }
}
