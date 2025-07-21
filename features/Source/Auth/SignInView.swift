// Created by Leopold Lemmermann on 21.07.25.

import Dependencies
import SwiftUI

public struct SignInView: View {
  @State private var email = ""
  @State private var password = ""
  
  @Dependency(\.session) var session

  public var body: some View {
    VStack(spacing: 12) {
      TextField("Email", text: $email)
        .textInputAutocapitalization(.never)
        .keyboardType(.emailAddress)
      SecureField("Password", text: $password)

      Button("Sign In") {
        Task {
          do {
            let uid = try await session.signInWithEmail(email, password)
            print("Signed in as \(uid)")
          } catch {
            print("Error: \(error)")
          }
        }
      }

      Button("Create Account") {
        Task {
          do {
            let uid = try await session.createUser(email, password)
            print("Created user \(uid)")
          } catch {
            print("Error: \(error)")
          }
        }
      }
    }
    .padding()
  }
  
  public init(email: String = "", password: String = "") {
    self.email = email
    self.password = password
  }
}
