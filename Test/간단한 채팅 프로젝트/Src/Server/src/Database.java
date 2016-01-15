
public class Database {
	
	public void login(String userid, String password) {
		
	}

	private OnLoginResult _OnLoginResult = null;

	public OnLoginResult getOnLoginResult() {
		return _OnLoginResult;
	}

	public void setOnLoginResult(OnLoginResult _OnLoginResult) {
		this._OnLoginResult = _OnLoginResult;
	}
	
}
