//
//  Lang.swift
//  SimplePassword
//
//  Created by Sebastian Mejia on 15/12/21.
//

import Foundation

struct Lang {
    struct Notification {
        static let title = "SimplePassword"
        static let body = "Es buen momento para actualizar tus contraseñas"
    }
    struct Error {
        static let biometricsError = "No haz configurado tu metodo de acceso"
    }
    struct Home {
        static let new = "Crear nueva"
        static let error = "Error"
        static let cancel = "Cancelar"
        static let delete = "Eliminar"
        static let notice = "Importante"
        static let title = "Contraseñas"
        static let showPassword = "Mostrar/Ocultar contraseña"
        static let copyToClipboard = "Copiar al portapapeles"
        static let cellActionMessages = "¿Qué deseas hacer?"
        static let createAccountButton = "Crear primera contraseña"
        static let passwordCopied = "Contraseña copiada al portapapeles."
        static let noAccountsCreated = "Aún no has creado ninguna contraseña."
        static let confirmDeletion = "¿Realmente deseas eliminar esa contraseña?"
    }

}
