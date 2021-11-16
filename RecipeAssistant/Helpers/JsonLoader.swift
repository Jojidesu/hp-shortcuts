// Created on 09.09.19. Copyright © 2019 Foodora. All rights reserved.

import Foundation

class JsonLoader {
  static func load<T: Decodable>(fileName: String) -> T {
    do {
      let json = try loadData(for: fileName)
      return try JSONDecoder().decode(T.self, from: json)
    } catch {
      fatalError("Decoding operation is failed -> \(error.localizedDescription)!!!")
    }
  }

  static func loadData(for fileName: String) throws -> Data {
    let bundle = Bundle(for: self)
    guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
      fatalError("\(fileName).json is not found!!!")
    }
    return try Data(contentsOf: url)
  }

  static func loadJsonDictionary(for fileName: String) throws -> [String: Any]? {
    let data = try loadData(for: fileName)
    return try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]
  }
}
