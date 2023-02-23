//
//  File.swift
//  
//
//  Created by 蒋艺 on 2023/2/23.
//

import Fluent
import Vapor

struct TruePointController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let subroute = routes.grouped("truepoint")
//        subroute.get(use: index).description("get position dataset with a query of batch")
        subroute.post(use: create).description("upload ground truth")
        // todos.group(":todoID") { todo in
        //     todo.delete(use: delete)
        // }
    }
    
    func index(req: Request) async throws -> [TruePoint] {
        if let magic: Int = req.query["magic"] {
            let truePoints = try await TruePoint.query(on: req.db)
                .filter(\.$magic == magic)
                .sort(\.$step)
                .all()
            return truePoints
        }else{
            return []
        }
    }

    func create(req: Request) async throws -> [TruePoint] {
        let truePoints = try req.content.decode([TruePoint].self)
        for truePoint in truePoints{
            try await truePoint.save(on: req.db)
        }
        return truePoints
    }
    
    // func delete(req: Request) async throws -> HTTPStatus {
    //     guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
    //         throw Abort(.notFound)
    //     }
    //     try await todo.delete(on: req.db)
    //     return .noContent
    // }
}
