
public class Protocol {
	
	private Socket _Socket = new Socket();
	private UserList _UserList = new UserList();
	private ConnectionList _ConnectionList = new ConnectionList();

	public Protocol() {
		_UserList.setOnUserAdded(new OnUserAdded() {
			@Override
			public void onUserAdded(Object user) {
				// TODO Auto-generated method stub
			}
		});
		
		_UserList.setOnUserRemoved(new OnUserRemoved() {
			@Override
			public void onUserRemoved(Object user) {
				sp_UserOut(user);
			}
		});
		
		_Socket.setOnConnected(new OnConnected() {
			@Override
			public void onConnected(Object connection) {
				_ConnectionList.add(connection);
				sp_AskUserID(connection);
			}
		});
		
		_Socket.setOnDisconnected(new OnDisconnected() {
			@Override
			public void onDisconnected(Object connection) {
				_ConnectionList.remove(connection);
				_UserList.remove(connection);
			}
		});
		
		_Socket.setOnReceived(new OnReceived() {
			@Override
			public void onReceived(Object connection, int packetType, Object data) {
				switch (packetType) {
				case PacketType.ptUserID: {
					// TODO: connection.UserID = ...;
					sp_AskPassword(connection); 
				}
				break;
				
				case PacketType.ptAskPassword: {
					// TODO: Login
				}
				break;
				
				case PacketType.ptChat: {
					// TODO: 
				}
				break;
				
				}
			}
		});
	}
	
	private void sp_AskUserID(Object connection) {
		
	}
	
	private void sp_AskPassword(Object connection) {
		
	}
	
	private void sp_UserOut(Object connection) {
		
	}
	
}
