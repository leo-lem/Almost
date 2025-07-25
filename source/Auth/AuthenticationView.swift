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
      Section("Welcome!") {
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
                await session.signIn(email: email, password: password, dismiss: dismiss)
              }
            }
          
          AsyncButton {
            await session.signIn(email: email, password: password, dismiss: dismiss)
          } label: {
            Label("Sign In", systemImage: "arrow.right.circle.fill")
          }
          .labelStyle(.iconOnly)
          .disabled(email.isEmpty || password.isEmpty)
          .buttonStyle(.borderedProminent)
        }
        
        if let message = session.errorMessage {
          Text(message)
            .font(.footnote)
            .foregroundStyle(.red)
        }
        
        AsyncButton {
          await session.signUp(email: email, password: password, dismiss: dismiss)
        } label: {
          Label("Create Account", systemImage: "person.badge.plus")
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .disabled(email.isEmpty || password.isEmpty)
        .buttonStyle(.borderless)
      }
      
      Section{
        AsyncButton {
          await session.signInAnonymously(dismiss: dismiss)
        } label: {
          Label("Try Anonymously", systemImage: "wand.and.stars")
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .buttonStyle(.bordered)
      } header: {
        Text("Or continue without an account")
      } footer: {
        Text("Anonymous sessions are temporary and won't sync across devices.")
          .font(.footnote)
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
      }
    }
    .formStyle(.automatic)
    .presentationDetents([.medium])
    .animation(.default, value: session.state)
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
