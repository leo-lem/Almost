// Created by Leopold Lemmermann on 21.07.25.

import SwiftUI
import SwiftUIExtensions

public struct AuthenticationView: View {
  @State private var email = ""
  @State private var password = ""
  @Environment(\.dismiss) private var dismiss
  @Environment(UserSession.self) private var session

  public var body: some View {
    Form {
      Section {
        TextField("Email", text: $email)
          .textInputAutocapitalization(.never)
          .keyboardType(.emailAddress)

        SecureField("Password", text: $password)
          .onSubmit {
            Task {
              await session.signIn(email: email, password: password, dismiss: dismiss)
            }
          }

        if let message = session.errorMessage {
          Text(message)
            .foregroundStyle(.red)
            .font(.footnote)
        }
      }

      Section {
        AsyncButton {
          await session.signIn(email: email, password: password, dismiss: dismiss)
        } label: {
          Text("Sign In")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)

        HStack {
          AsyncButton {
            await session.signUp(email: email, password: password, dismiss: dismiss)
          } label: {
            Text("Create Account")
              .frame(maxWidth: .infinity)
          }
          
          Divider()

          AsyncButton {
            await session.signInAnonymously(dismiss: dismiss)
          } label: {
            Text("Try without Account")
              .frame(maxWidth: .infinity)
          }
        }
      }
    }
    .buttonStyle(.borderless)
    .presentationDetents([.medium])
    .trackScreen("AuthenticationView")
  }
  
  public init() {}
}

#Preview {
  @Previewable @State var isPresented = true
  
  Toggle("Sign in", isOn: $isPresented)
    .sheet(isPresented: $isPresented) { AuthenticationView() }
    .preview()
}
