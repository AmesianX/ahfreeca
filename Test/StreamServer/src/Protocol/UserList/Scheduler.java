package Protocol.UserList;

import java.util.LinkedList;
import java.util.Queue;

public class Scheduler implements Runnable {
	
	private QList _QList = null;
	
	private Thread _Thread = new Thread(this);
	private boolean _Terminated = false;
	
	private Queue<SchedulerTask> _Tasks = new LinkedList<SchedulerTask>();
	
	public Scheduler(QList list) {
		_QList = list;
		_Thread.start();
	}
	
	protected void finalize() {
		_Terminated = true;
	}
	
	public void add(Object ctx) {
		synchronized (_Tasks) {
			_Tasks.add(new SchedulerTask(0, ctx));
			_Tasks.notifyAll();
		}
	}
	
	public void sync(UserListIteration iteration) {
		synchronized (_Tasks) {
			_Tasks.add(new SchedulerTask(1, iteration));
			_Tasks.notifyAll();
		}	
	}
	
	@Override
	public void run() {
		SchedulerTask task;
		
		while (_Terminated == false) {
			synchronized (_Tasks) {
				while (_Tasks.size() == 0) {
					try {
						_Tasks.wait();
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
				task = _Tasks.remove();
			}
			
			switch (task.task) {
			case 0: _QList.add(task.ctx); break;
			case 1: _QList.iterate((UserListIteration) task.ctx); break;
			}
		}
	}

}
