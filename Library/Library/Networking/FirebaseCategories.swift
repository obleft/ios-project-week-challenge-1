import Foundation

/*
 READ   <- start the application
 
 POST   <- create, creating a new record, Firebase will return a new record identifier
 PUT    <- update a specific record
 DELETE <- delete a specific record
 */


class FirebaseCategories<Item: Codable & FirebaseItem> {
    static var baseURL: URL!  { return URL(string: "https://categories-33813.firebaseio.com/") }
    
    static func requestURL(_ method: String, for id: String = "unknownid") -> URL {
        switch method {
        case "POST":
            // You post to the main DB. It will return a new record identifier
            return baseURL.appendingPathExtension("json")
        case "DELETE", "PUT", "GET":
            // These all work on individual records, and you need to use the
            // record identifier in your URL with one exception, which is when
            // all the records at once, in which case, you do not need the record
            // identifier.
            return baseURL
                .appendingPathComponent(id)
                .appendingPathExtension("json")
        default:
            fatalError("Unknown request method: \(method)")
        }
    }
    
    // Handle a single request: meant for DELETE, PUT, POST.
    // If you were doing a GET, you'd want to pass back a record and not a success token
    static func processRequest(
        method: String,
        for item: Item,
        with completion: @escaping (_ success: Bool) -> Void = { _ in }
        ) {
        
        // Fetch appropriate request URL customized to method
        var request = URLRequest(url: requestURL(method, for: item.id))
        request.httpMethod = method
        
        // Encode this record
        do {
            request.httpBody = try JSONEncoder().encode(item)
        } catch {
            NSLog("Unable to encode \(item): \(error)")
            completion(false)
            return
        }
        
        // Create data task to perform request
        let dataTask = URLSession.shared.dataTask(with: request) { data, _ , error in
            
            // Fail on error
            if let error = error {
                NSLog("Server \(method) error: \(error)")
                completion(false)
                return
            }
            
            // Handle PUT, GET, DELETE and leave
            guard method == "POST" else {
                completion(true)
                return
            }
            
            // Process POST requests
            
            // Fetch identifier from POST
            guard let data = data else {
                NSLog("Invalid server response data")
                completion(false)
                return
            }
            
            do {
                
                // POST request returns `["name": recordIdentifier]`. Store the
                // record identifier
                let nameDict = try JSONDecoder().decode([String: String].self, from: data)
                guard let name = nameDict["name"] else {
                    completion(false)
                    return
                }
                
                // Update record and store that name. POST is now successful
                // and includes the recordIdentifier as part of the item record.
                item.id = name
                processRequest(method: "PUT", for: item)
                completion(true)
                
            } catch {
                
                NSLog("Error decoding JSON response: \(error)")
                completion(false)
                return
            }
        }
        
        dataTask.resume()
    }
    
    static func delete(item: Item, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        processRequest(method: "DELETE", for: item, with: completion)
    }
    
    static func save(item: Item, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        switch item.id.isEmpty {
        case true: // POST, new record
            processRequest(method: "POST", for: item, with: completion)
        case false: // PUT, existing record
            processRequest(method: "PUT", for: item, with: completion)
        }
    }
    
    // Fetch all records and pass them to sender via completion handler
    static func fetchRecords(completion: @escaping ([Item]?) -> Void) {
        let requestURL = baseURL.appendingPathExtension("json")
        let dataTask = URLSession.shared.dataTask(with: requestURL) { data, _, error in
            
            guard error == nil, let data = data else {
                // Guaranteed to work
                if let error = error {
                    NSLog("Error fetching entries: \(error)")
                }
                completion(nil)
                return
            }
            
            do {
                let recordDict = try JSONDecoder().decode([String: Item].self, from:data)
                for (key, value) in recordDict { value.id = key } // pure paranoia
                let records = recordDict.map({ $0.value }) // This converts the [[id: item]] array of dictionary entries into an array of items
                print(records)
                completion(records)
            } catch {
                NSLog("Error decoding received data: \(error)")
                completion([])
            }
        }
        
        dataTask.resume()
    }
}
