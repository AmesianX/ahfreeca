package Protocol.UserList;

public class QList {
	
	private QListNode _Header = null;

	public void add(Object ctx) {
		QListNode node = new QListNode();
		node.ctx = ctx;
		node.prior = _Header;
		_Header = node;
	}
	
	public void iterate(UserListIteration iteration) {
		QListNode node = _Header;
		
		while (node != null) {
			iteration.iterate(node.ctx);
			node = node.prior;
		}
	}
	
	public boolean isEmpty() {
		return _Header == null;
	}
	
}
