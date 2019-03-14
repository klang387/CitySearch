//
//  CityNameTrie.swift
//  CitySearch
//
//  Created by Kevin Langelier on 3/13/19.
//  Copyright © 2019 Kevin Langelier. All rights reserved.
//

import Foundation

class TrieNode<T: Hashable> {
    var value: T?
    weak var parent: TrieNode?
    var children: [T:TrieNode] = [:]
    var isTerminating = false
    var city: City?
    
    init(value: T? = nil, parent: TrieNode? = nil) {
        self.value = value
        self.parent = parent
    }
    
    func add(child: T) {
        guard children[child] == nil else { return }
        children[child] = TrieNode(value: child, parent: self)
    }
}

class Trie {
    typealias Node = TrieNode<Character>
    fileprivate let root: Node
    
    init() {
        root = Node()
    }
}

extension Trie {
    func insert(city: City) {
        var currentNode = root
        
        let characters = Array(city.description.lowercased())
        var currentIndex = 0
        
        while currentIndex < characters.count {
            let character = characters[currentIndex]
            if let child = currentNode.children[character] {
                currentNode = child
            } else {
                currentNode.add(child: character)
                currentNode = currentNode.children[character]!
            }
            currentIndex += 1
        }
        currentNode.isTerminating = true
        currentNode.city = city
    }
    
    func matches(prefix: String) -> [City] {
        var cities: [City] = []
        var currentNode = root
        for character in prefix.lowercased() {
            guard let childNode = currentNode.children[character] else {
                return cities
            }
            currentNode = childNode
        }
        if currentNode.isTerminating, let city = currentNode.city {
            cities.append(city)
        }
        let sorted: ((Node, Node) -> Bool) = { return $0.value ?? Character("") > $1.value ?? Character("") }
        var stack: [Node] = Array(currentNode.children.values).sorted(by: { return sorted($0,$1) })
        while !stack.isEmpty {
            currentNode = stack.removeLast()
            if currentNode.isTerminating, let city = currentNode.city {
                cities.append(city)
            }
            stack += Array(currentNode.children.values).sorted(by: { return sorted($0,$1) })
        }
        
        return cities
    }
}
