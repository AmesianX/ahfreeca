package Protocol;

import java.util.ArrayList;
import java.util.concurrent.atomic.AtomicInteger;

public class ConnectionList {
	
	private final static int MAX_USER_COUNT = 0xFF;
	
	private AtomicInteger _ID = new AtomicInteger(0);
	
	private ArrayList<Connection> Connections = new ArrayList<Connection>();

	public ConnectionList() {
		for (int i=0; i<MAX_USER_COUNT; i++) {
			Connections.add(new Connection());
		}
	}
	
	public void add(Object ctx) {		
		for (int i=0; i<MAX_USER_COUNT; i++) {
			int id = _ID.incrementAndGet();
			if (Connections.get(id % MAX_USER_COUNT).isUsing == false) {
				Connections.get(id % MAX_USER_COUNT).id = id; 
				Connections.get(id % MAX_USER_COUNT).isUsing = true; 
				break;
			}
		}
	}
	
	public Connection get(int index) {
		Connection connection = Connections.get(index % MAX_USER_COUNT); 
		if (connection.id != index) return null;
		return connection;
	}
	
}
