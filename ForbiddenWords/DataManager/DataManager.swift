//
//  DataManager.swift
//  ForbiddenWords
//
//  Created by Roberto Carmo Mascarenhas on 22/04/25.
//


import SwiftData

// Classe que gerencia seu container e o contexto
@MainActor
final class DataManager {
    static let shared = DataManager()
    
    // Container gerenciado de forma segura
    let container: ModelContainer
    // Contexto do container
    let context: ModelContext
    
    private init() {
        do {
            self.container = try ModelContainer(for: Card.self)
            self.context = container.mainContext
        } catch {
            fatalError("Erro ao inicializar o ModelContainer: \(error.localizedDescription)")
        }
    }
    
    // Método estático para obter uma instância mock ou de fallback para previews/testes
    static func makePreviewContainer() -> ModelContainer {
        // Tenta criar o container, mas caso falhe, retorna um container mock ou vazio
        if let fallbackContainer = try? ModelContainer(for: Card.self) {
            return fallbackContainer
        } else {
            // Aqui você pode retornar um container mock ou um container padrão
            // Por exemplo, um container em memória para testes
            do {
                return try ModelContainer()
            } catch {
                fatalError("Falha ao criar o container de preview: \(error)")
            }
        }
    }
}

