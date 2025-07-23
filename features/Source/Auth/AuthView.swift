// Created by Leopold Lemmermann on 21.07.25.

import Dependencies
import SwiftUI
import SwiftUIExtensions

public struct AuthView: View {
  @State var email = ""
  @State var password = ""
  @State var error: String?
  
  @Environment(\.dismiss) var dismiss
  @Dependency(\.authentication) var authentication

  public var body: some View {
    Form {
      Section {
        TextField("Email", text: $email)
          .textInputAutocapitalization(.never)
          .keyboardType(.emailAddress)

        SecureField("Password", text: $password)

        if let error {
          Text(error)
            .foregroundStyle(.red)
            .font(.footnote)
        }
      }

      Section {
        AsyncButton {
          do {
            try await authentication.signIn(email, password)
            dismiss()
          } catch {
            self.error = error.localizedDescription
          }
        } label: {
          Text("Sign In")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)

        AsyncButton {
          do {
            try await authentication.signUp(email, password)
            dismiss()
          } catch {
            self.error = error.localizedDescription
          }
        } label: {
          Text("Create Account")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderless)
      }
    }
  }
  
  public init() {}
}

#Preview {
  @Previewable @State var isPresented = true
  
  Toggle("Sign in", isOn: $isPresented)
    .sheet(isPresented: $isPresented) { AuthView() }
}
