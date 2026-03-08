// Created by Leopold Lemmermann on 21.07.25.

import SwiftUI
import SwiftUIExtensions

public struct AuthenticationView: View {
  @State private var email = ""
  @State private var password = ""
  @State private var error: Error?

  @Environment(\.dismiss) private var dismiss
  @Environment(Authentication.self) private var session

  public var body: some View {
    Form {
      Section {
        TextField("Email", text: $email)
          .keyboardType(.emailAddress)
          .textContentType(.emailAddress)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled()
          .submitLabel(.next)
        
        HStack {
          SecureField("Password", text: $password)
            .textContentType(.password)
            .autocorrectionDisabled()
            .submitLabel(.go)
            .onSubmit {
              Task {
                do {
                  try await session.signIn(email: email, password: password)
                  dismiss()
                } catch { self.error = error }
              }
            }

          AsyncButton {
            do {
              try await session.signUp(email: email, password: password)
              dismiss()
            } catch { self.error = error }
          } label: {
            Label("Create Account", systemImage: "person.badge.plus")
          }
          .disabled(email.isEmpty || password.isEmpty)
          .labelStyle(.iconOnly)
          .buttonStyle(.borderless)

          AsyncButton {
            do {
              try await session.signIn(email: email, password: password)
              dismiss()
            } catch { self.error = error }
          } label: {
            Label("Sign In", systemImage: "arrow.right.circle.fill")
          }
          .labelStyle(.iconOnly)
          .disabled(email.isEmpty || password.isEmpty)
          .buttonStyle(.borderedProminent)
        }
      } header: {
        Text("Welcome!")
      } footer: {
        if let message = error?.localizedDescription {
          Text(message)
            .font(.footnote)
            .foregroundStyle(.red)
        }
      }
    }
    .formStyle(.automatic)
    .presentationDetents([.fraction(0.2)])
    .scrollDisabled(true)
    .trackScreen("AuthenticationView")
  }
  
  public init() {}
}

#Preview {
  @Previewable @State var isPresented = true
  
  Toggle("Sign in", isOn: $isPresented)
    .sheet(isPresented: $isPresented) { AuthenticationView() }
    .firebase()
}
