import Vapor
import Foundation
import HTTP

extension Droplet {
    

   
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            try json.set("ip", "\(req.peerHostname)")
            return json
        }

        get("test1") { req in
            let para = "https://www.wired.com/story/how-apple-finally-made-siri-sound-more-human/"
            let res = try self.client.get(para)
            return res
        }

        get("proxy") { req in
            
            guard var para = req.data["pxurl"]?.string  else {

                throw Abort(.badRequest, reason: "no category para")
            }
            print("para = \(para)")

            if para.hasSuffix(".png") {
                print("request png here")
            } else if para.hasPrefix("http://") || para.hasPrefix("https://"){
                print("begin parse url")
                let splits = para._split(separator: "/")
                let dest = splits[0] + "//" + splits[1]
                Post.lastURL = String(dest)
                print("lasturl: \(Post.lastURL)")
//                var xmlStr:String = String(bytes: data, encoding: String.Encoding.utf8)!
//                xmlStr.append("ctlmark")
////                xmlStr = xmlStr.replacingOccurrences(of: "../..", with: "http://127.0.0.1:8080/proxy/?pxurl=https://docs.vapor.codes/2.0")
//                res.body = Body(xmlStr)
//                 print("xmlStr = \(xmlStr)")
            }
//            else  if Post.lastURL.count > 0 {
////                para = "http://"+ \(req.peerHostname) +":8080/proxy/?pxurl=" + Post.lastURL + para
//            }
              let res = try self.client.get(para)

//            if let string = String(data: data, encoding: .utf8) {
//                print(string)
//            } else {
//                print("not a valid UTF-8 sequence")
//            }
            
//            let contents = NSString(data:res.body.bytes, encoding:String.Encoding.utf8.rawValue)
            
//            let res = try self.client.get(para)
            return res
        }
        
        
        func getRedirectSource(_ request: Request) throws -> Response {
            var para = request.uri.path

            para = Post.lastURL +  para
            print("req.urie: \(para)")
            let res = try self.client.get(para)

            return res


        }
        
        

        get("plaintext") { req in
            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }

        get("*") { req in

            let para = req.uri.path
            print("get* : \(para)")
            let chars = para.characters

            let lastThreeChars: String = String(chars.suffix(3))
            let lastFourChars: String = String(chars.suffix(4))
            if lastThreeChars == ".js" || lastFourChars == ".css" {
                return try getRedirectSource(req)
            }

            return "no data"
        }

//        try resource("posts", PostController.self)
    }
}
