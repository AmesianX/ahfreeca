package Protocol.UserList;

public class UserList {
	
	private QList _QList = new QList();
	private Scheduler _Scheduler = new Scheduler(_QList);
	
	public void add(Object ctx) {
		_Scheduler.add(ctx);
	}
	
	public void iterate(UserListIteration iteration) {
		_QList.iterate(iteration);
	}
	
	public void sync(UserListIteration iteration) {
		_Scheduler.sync(iteration);
	}

}
