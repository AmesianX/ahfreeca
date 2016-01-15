
public class UserList {
	
	public void add(Object connection) {
		
	}
	
	public void remove(Object connection) {
		
	}

	private OnUserAdded _OnUserAdded = null;
	
	public OnUserAdded getOnUserAdded() {
		return _OnUserAdded;
	}

	public void setOnUserAdded(OnUserAdded _OnUserAdded) {
		this._OnUserAdded = _OnUserAdded;
	}

	private OnUserRemoved _OnUserRemoved = null;

	public OnUserRemoved getOnUserRemoved() {
		return _OnUserRemoved;
	}

	public void setOnUserRemoved(OnUserRemoved _OnUserRemoved) {
		this._OnUserRemoved = _OnUserRemoved;
	}
	
}
