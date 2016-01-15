
public class Socket {
	
	public void start(int port) {
		
	}
	
	public void stop() {
		
	}
	
	private OnConnected _OnConnected = null;
	
	public OnConnected getOnConnected() {
		return _OnConnected;
	}

	public void setOnConnected(OnConnected _OnConnected) {
		this._OnConnected = _OnConnected;
	}

	private OnDisconnected _OnDisconnected = null;
	
	public OnDisconnected getOnDisconnected() {
		return _OnDisconnected;
	}

	public void setOnDisconnected(OnDisconnected _OnDisconnected) {
		this._OnDisconnected = _OnDisconnected;
	}

	private OnReceived _OnReceived = null;

	public OnReceived getOnReceived() {
		return _OnReceived;
	}

	public void setOnReceived(OnReceived _OnReceived) {
		this._OnReceived = _OnReceived;
	}

}
