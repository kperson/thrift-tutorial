namespace java com.chat.api

struct ChatMessage {
  1: string message,
  2: list<byte>image
}

exception UserAlreadyRegisteredException {
 1: string message
} 

service ChatAPI {
  string addNewUser(1: string username) throws (1: UserAlreadyRegisteredException ex),
  void sendMessage(1: ChatMessage message, 2: string username, 3: string token)
}